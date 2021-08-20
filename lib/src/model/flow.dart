import 'dart:async';

import 'package:fconsole/fconsole.dart';
import 'package:fconsole/src/model/log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlowLogDesc {
  final String? detail;
  final bool? hasError;
  final bool? hasItem;

  FlowLogDesc({
    this.detail,
    this.hasError,
    this.hasItem,
  });

  @override
  String toString() {
    return detail!;
  }
}

// 一个工作流
class FlowLog {
  final String name;

  /// id，可不传，默认为空，在name冲突时作为唯一标识
  final String id;
  List<Log>? logs;

  DateTime? createdAt;

  /// 超时时间，如果超过这个时间就算作一个新Flow
  final Duration? timeout;

  DateTime? _endAt;
  DateTime? get endAt => _endAt;

  FlowLog._({
    required this.name,
    this.logs,
    this.timeout,
    this.createdAt,
    DateTime? end,
    this.id = '',
  }) : _endAt = end {
    logs ??= [];
  }

  FlowLog({
    this.name: "system",
    this.id: "",
    this.logs,
    Duration? timeout: const Duration(seconds: 30),
  })  : createdAt = DateTime.now(),
        this.timeout = timeout ?? const Duration(seconds: 30) {
    logs ??= [];
    FlowCenter.instance!.workingFlow[name + id] = this;
  }

  DateTime? get latestTime {
    if (logs!.length == 0) {
      return createdAt;
    }
    return logs!.last.dateTime;
  }

  DateTime get expireTime =>
      latestTime!.add(timeout ?? const Duration(seconds: 30));

  bool get isTimeout =>
      expireTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch;

  Timer? timer;

  /// 增加一个新log，如果超时了，就总结log并加入已完成
  _addRawLog(Log log) {
    if (isTimeout) {
      this.end(
        'End with timeout(${timeout!.inSeconds}s)',
        LogType.error,
      );
    } else {
      timer?.cancel();
      timer = null;
      timer = Timer(timeout!, () {
        this.end(
          'End with timeout(${timeout!.inSeconds}s)',
          LogType.error,
        );
        timer?.cancel();
        timer = null;
      });
    }
    this.logs!.add(log);
    FlowCenter.instance!._notify();
  }

  /// 添加一个常规log
  log(dynamic log) {
    this._addRawLog(Log(log, LogType.log));
  }

  /// 添加一个常规log
  add(dynamic log) {
    this._addRawLog(Log(log, LogType.log));
  }

  /// 添加一个Error log
  error(dynamic log) {
    this._addRawLog(Log(log, LogType.error));
  }

  /// 结束当前Flow
  end([dynamic log, LogType? type]) {
    if (log != null) {
      this.logs!.add(Log(log, type ?? LogType.log));
    }
    timer?.cancel();
    timer = null;
    _endAt = DateTime.now();
    // 拷贝一份去
    FlowCenter.instance!.flowList.add(FlowLog._(
      name: name,
      logs: List.from(logs!),
      timeout: timeout,
      createdAt: createdAt,
      end: endAt,
    ));
    this.createdAt = DateTime.now();
    this._endAt = null;
    FlowCenter.instance!.workingFlow.remove(name + id);
    this.logs!.clear();
    FlowCenter.instance!._notify();
  }

  FlowLogDesc get desc {
    int normalCount = 0;
    int errorCount = 0;
    for (var log in logs!) {
      if (log.type == LogType.log) {
        normalCount += 1;
      } else {
        errorCount += 1;
      }
    }
    var detail = '$normalCount Logs, $errorCount Errors';
    var duration = '';
    if (endAt != null) {
      duration = ", ${createdAt!.difference(endAt!).inMilliseconds * -1}ms";
    }
    return FlowLogDesc(
      detail: detail + duration,
      hasError: errorCount > 0,
      hasItem: (errorCount + errorCount) > 0,
    );
  }

  String get startTimeText =>
      DateFormat(FConsole.instance!.options.timeFormat).format(createdAt!);

  String get endTimeText => endAt == null
      ? 'null'
      : DateFormat(FConsole.instance!.options.timeFormat).format(endAt!);

  String get shareText => [
        if (logs!.isNotEmpty) "Time: ${logs!.first.dateTime}",
        "Event: $name",
        "Overview: $desc",
        "-----------------",
        logsDesc,
        "-------EOF-------",
      ].join('\n');

  String get logsDesc {
    List<String> logStr = [];
    for (var i = 0; i < logs!.length; i++) {
      var log = logs![i];
      if (i == 0) {
        logStr.add('[start]$log');
        continue;
      }
      var lastLog = logs![i - 1];
      var diff = log.dateTime!.difference(lastLog.dateTime!).inMilliseconds;
      logStr.add('[${diff}ms]$log');
    }
    return logStr.join('\n');
  }

  /// 通过name获取一个正在进行的Flow，如果flow还没有创建，那么就创建一个新的再返回
  static FlowLog of(String name, [Duration? initTimeOut]) {
    if (FlowCenter.instance!.workingFlow[name] == null) {
      FlowCenter.instance!.workingFlow[name] = FlowLog(
        name: name,
        timeout: initTimeOut,
      );
    }
    return FlowCenter.instance!.workingFlow[name]!;
  }

  /// 通过name获取一个正在进行的Flow，如果flow还没有创建，那么就创建一个新的再返回
  /// 此方法可以额外指定一个id，在name相同时，使用id判断是否是同一个flow
  static FlowLog ofNameAndId(
    String name, {
    Duration? initTimeOut,
    String id = '',
  }) {
    if (FlowCenter.instance!.workingFlow[name + id] == null) {
      FlowCenter.instance!.workingFlow[name + id] = FlowLog(
        name: name,
        timeout: initTimeOut,
        id: id,
      );
    }
    return FlowCenter.instance!.workingFlow[name + id]!;
  }

  @override
  String toString() {
    return 'FlowLog: $name\nLog: $logs\n';
  }
}

class FlowCenter extends ChangeNotifier {
  /// 正在进行的流程记录
  Map<String?, FlowLog> workingFlow = {};

  /// 已经完成的流程记录
  List<FlowLog> flowList = [];

  clearAll() {
    this.flowList.clear();
    this.workingFlow.clear();
  }

  _notify() {
    notifyListeners();
  }

  // 工厂模式
  factory FlowCenter() => _getInstance()!;
  static FlowCenter? get instance => _getInstance();
  static FlowCenter? _instance;
  FlowCenter._internal() {
    // 初始化
  }
  static FlowCenter? _getInstance() {
    if (_instance == null) {
      _instance = FlowCenter._internal();
    }
    return _instance;
  }
}
