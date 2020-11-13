import 'package:fconsole/fconsole.dart';
import 'package:fconsole/src/model/log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 一个工作流
class FlowLog {
  final String id;
  List<Log> logs;

  DateTime createdAt;

  /// 超时时间，如果超过这个时间就算作一个新Flow
  final Duration timeout;

  DateTime _endAt;
  DateTime get endAt => _endAt;

  FlowLog._({
    this.id,
    this.logs,
    this.timeout,
    this.createdAt,
    DateTime end,
  }) : _endAt = end {
    logs ??= [];
  }

  FlowLog({
    this.id: "system",
    this.logs,
    this.timeout: const Duration(seconds: 30),
  }) : createdAt = DateTime.now() {
    logs ??= [];
    FlowCenter.instance.workingFlow[id] = this;
  }

  DateTime get latestTime {
    if (logs.length == 0) {
      return createdAt;
    }
    return logs.last.dateTime;
  }

  DateTime get expireTime => latestTime.add(timeout);

  bool get isTimeout =>
      expireTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch;

  /// 增加一个新log，如果超时了，就总结log加入已完成
  addRawLog(Log log) {
    if (isTimeout) {
      this.end();
    }
    this.logs.add(log);
    FlowCenter.instance._notify();
  }

  /// 添加一个常规log
  log(dynamic log) {
    this.addRawLog(Log(log, LogType.log));
  }

  /// 添加一个常规log
  add(dynamic log) {
    this.addRawLog(Log(log, LogType.log));
  }

  /// 添加一个Error log
  error(dynamic log) {
    this.addRawLog(Log(log, LogType.log));
  }

  /// 结束当前Flow
  end() {
    _endAt = DateTime.now();
    // 拷贝一份去
    FlowCenter.instance.flowList.add(FlowLog._(
      id: id,
      logs: List.from(logs),
      timeout: timeout,
      createdAt: createdAt,
      end: endAt,
    ));
    this.createdAt = DateTime.now();
    this._endAt = null;
    FlowCenter.instance.workingFlow[id] = null;
    this.logs.clear();
    FlowCenter.instance._notify();
  }

  String get desc {
    int normalCount = 0;
    int errorCount = 0;
    for (var log in logs) {
      if (log.type == LogType.log) {
        normalCount += 1;
      } else {
        errorCount += 1;
      }
    }
    return '$normalCount Logs, $errorCount Errors';
  }

  String get startTimeText =>
      DateFormat(FConsole.instance.options.timeFormat).format(createdAt);

  String get endTimeText =>
      DateFormat(FConsole.instance.options.timeFormat).format(endAt);

  /// 通过id获取一个正在进行的Flow，如果flow还没有创建，那么就创建一个新的再返回
  static FlowLog of(String id, [Duration initTimeOut]) {
    if (FlowCenter.instance.workingFlow[id] == null) {
      FlowCenter.instance.workingFlow[id] =
          FlowLog(id: id, timeout: initTimeOut);
    }
    return FlowCenter.instance.workingFlow[id];
  }

  @override
  String toString() {
    return 'FlowLog: $id\nLog: $logs\n';
  }
}

class FlowCenter extends ChangeNotifier {
  /// 正在进行的流程记录
  Map<String, FlowLog> workingFlow = {};

  /// 已经完成的流程记录
  List<FlowLog> flowList = [];

  _notify() {
    notifyListeners();
  }

  // 工厂模式
  factory FlowCenter() => _getInstance();
  static FlowCenter get instance => _getInstance();
  static FlowCenter _instance;
  FlowCenter._internal() {
    // 初始化
  }
  static FlowCenter _getInstance() {
    if (_instance == null) {
      _instance = FlowCenter._internal();
    }
    return _instance;
  }
}
