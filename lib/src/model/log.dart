enum LogType {
  log,
  error,
}

class Log {
  final dynamic log;
  final LogType type;
  DateTime? dateTime;

  Log(
    this.log,
    this.type,
  ) {
    dateTime = DateTime.now();
  }

  bool get isJson => log is Map || log is List;

  @override
  String toString() {
    return log.toString();
  }
}
