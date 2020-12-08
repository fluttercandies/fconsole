import '../../fconsole.dart';

/// console对象
var console = _Console();

class _Console {
  void log([obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9, obj10]) {
    var l = [obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9, obj10];
    FConsole.log(
      l
          .where((element) => element != null)
          .map<String>((e) => e.toString())
          .join(','),
    );
  }

  void error([obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9, obj10]) {
    var l = [obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9, obj10];
    FConsole.error(
      l
          .where((element) => element != null)
          .map<String>((e) => e.toString())
          .join(','),
    );
  }

  /// TODO: 计时
  // void timeStart(String tag) {}

  /// TODO: 计时结束
  // void timeEnd(String tag) {}
}
