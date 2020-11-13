import 'package:fconsole/src/core/log.dart';

import 'shake_detector.dart';

class FConsole {
  ConsoleOptions options = ConsoleOptions();
  ShakeDetector shakeDetector;
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

  void start({ConsoleOptions options}) {
    this.options = options ?? ConsoleOptions();
  }

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

  List<ConsoleLogListener> _listeners = [];

  addConsoleLogListener(ConsoleLogListener l) {
    if (!_listeners.contains(l)) {
      _listeners.add(l);
    }
  }

  removeConsoleLogListener(ConsoleLogListener l) {
    if (_listeners.contains(l)) {
      _listeners.remove(l);
    }
  }

  notifyAddLog() {
    for (ConsoleLogListener listener in _listeners) {
      listener.onAddLog();
    }
  }

  notifyClearLog() {
    for (ConsoleLogListener listener in _listeners) {
      listener.onClearLog();
    }
  }

  static log(dynamic log) {
    if (log != null) {
      Log lg = Log(log);
      FConsole.instance.verboselog.add(lg);
      FConsole.instance.allLog.add(lg);
      FConsole.instance.notifyAddLog();
    }
  }

  List<Log> logs(int logType) {
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

  static error(dynamic error) {
    if (error != null) {
      Log lg = Log(error);
      FConsole.instance.errorLog.add(lg);
      FConsole.instance.allLog.add(lg);
      FConsole.instance.notifyAddLog();
    }
  }

  void clear() {
    if (currentLogIndex == 0) {
      allLog.clear();
    } else if (currentLogIndex == 1) {
      verboselog.clear();
    } else if (currentLogIndex == 2) {
      errorLog.clear();
    }
    notifyClearLog();
  }
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

abstract class ConsoleLogListener {
  void onAddLog();

  void onClearLog();
}

///How to show the console button
enum ConsoleDisplayMode {
  None, //Don't show
  Shake, //by shake
  Always, // always show
}
