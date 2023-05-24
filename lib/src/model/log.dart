enum LogType {
  log,
  error,
}

class Log {
  final dynamic log;
  final LogType type;
  final StackTrace? stackTrace;
  DateTime? dateTime;

  Log(
    this.log,
    this.type, {
    this.stackTrace,
  }) {
    dateTime = DateTime.now();
  }

  bool get isJson => log is Map || log is List;

  @override
  String toString() {
    var logText = log.toString();
    return logText;
  }
}
