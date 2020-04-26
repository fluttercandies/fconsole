class Log {
  final dynamic log;
  DateTime dateTime;

  Log(this.log) {
    dateTime = DateTime.now();
  }

  @override
  String toString() {
    return log.toString();
  }
}
