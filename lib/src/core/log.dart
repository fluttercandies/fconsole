enum LogType {
  log,
  error,
}

class Log {
  final dynamic log;
  final LogType type;
  DateTime dateTime;

  Log(this.log, this.type) {
    dateTime = DateTime.now();
  }

  @override
  String toString() {
    return log.toString();
  }
}
