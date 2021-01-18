import 'dart:async';

import 'package:fconsole/fconsole.dart';
import 'package:fconsole/src/model/log.dart';
import 'package:flutter/material.dart';

import '../model/log.dart';
import 'shake_detector.dart';

typedef ErrHandler = void Function(
    Zone, ZoneDelegate, Zone, Object, StackTrace);

// TODO: 拦截的log需不需要显示在其他地方?
void runFConsoleApp(Widget app, {ErrHandler errHandler}) {
  FlutterError.onError = (details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  var zoneSpecification = ZoneSpecification(
    print: (
      Zone self,
      ZoneDelegate parent,
      Zone zone,
      String line,
    ) {
      FConsole.log(line, noPrint: true);
      Zone.current.parent?.print(line);
    },
    handleUncaughtError: (
      Zone self,
      ZoneDelegate parent,
      Zone zone,
      Object error,
      StackTrace stackTrace,
    ) {
      // TODO: 堆栈错误可处理
      FConsole.error(error, noPrint: true);
      Zone.current.parent?.print('$error');
      errHandler?.call(self, parent, zone, error, stackTrace);
    },
  );
  runZoned(
    () => runApp(app),
    zoneSpecification: zoneSpecification,
  );
}

class FConsole extends ChangeNotifier {
  ConsoleOptions options = ConsoleOptions();
  ShakeDetector shakeDetector;

  ValueNotifier isShow = ValueNotifier(false);

  void startShakeListener(Function() onShake) {
    stopShakeListener();
    shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
      ///detecotor phone shake
      onShake?.call();
    });
  }

  void stopShakeListener() {
    if (shakeDetector != null) {
      shakeDetector.stopListening();
      shakeDetector = null;
    }
  }

  List<Log> allLog = [];
  List<Log> errorLog = [];
  List<Log> verboselog = [];
  int currentLogIndex = 0;

  List<Log> logListOfType(int logType) {
    if (logType == 0) {
      return allLog;
    }
    if (logType == 1) {
      return verboselog;
    }
    if (logType == 2) {
      return errorLog;
    }
    return null;
  }

  static log(dynamic log, {bool noPrint = false}) {
    // 有这个参数时，是自己捕获的print，不需要再打印
    if (!noPrint) {
      print(log);
      return;
    }
    if (FConsole.instance.isShow.value == false) {
      return;
    }
    if (log != null) {
      Log lg = Log(log, LogType.log);
      FConsole.instance.verboselog.add(lg);
      FConsole.instance.allLog.add(lg);
      FConsole.instance.notifyListeners();
    }
  }

  static error(dynamic error, {bool noPrint = false}) {
    if (!noPrint) {
      print(error);
    }
    if (FConsole.instance.isShow.value == false) {
      return;
    }
    if (error != null) {
      Log lg = Log(error, LogType.error);
      FConsole.instance.errorLog.add(lg);
      FConsole.instance.allLog.add(lg);
      FConsole.instance.notifyListeners();
    }
  }

  void clear(bool clearAll) {
    if (clearAll) {
      allLog.clear();
      verboselog.clear();
      errorLog.clear();
    } else {
      if (currentLogIndex == 0) {
        allLog.clear();
      } else if (currentLogIndex == 1) {
        verboselog.clear();
      } else if (currentLogIndex == 2) {
        errorLog.clear();
      }
    }
    FConsole.instance.notifyListeners();
  }

  /// 单例
  static FConsole _instance;

  factory FConsole() => _getInstance();

  static FConsole get instance => _getInstance();

  static FConsole _getInstance() {
    if (_instance == null) {
      _instance = FConsole._();
    }
    return _instance;
  }

  FConsole._();
}

class ConsoleOptions {
  final bool showTime;
  final String timeFormat;
  final ConsoleDisplayMode displayMode;

  ConsoleOptions({
    this.showTime = true,
    this.timeFormat = "HH:mm:ss",
    this.displayMode = ConsoleDisplayMode.Shake,
  });
}

///How to show the console button
enum ConsoleDisplayMode {
  None, //Don't show
  Shake, //by shake
  Always, // always show
}
