import '../../fconsole.dart';

/// console对象
var fconsole = _Console();

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
}
