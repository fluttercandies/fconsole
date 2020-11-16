import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fconsole/fconsole.dart';
import 'package:fconsole_example/style/color.dart';
import 'package:fconsole_example/style/text.dart';
import 'package:tapped/tapped.dart';

import 'style/color.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FConsole.instance.isShow.addListener(() {
      setState(() {});
    });
  }

  bool get consoleHasShow => FConsole.instance.isShow.value;

  double slideValue = 0;

  @override
  Widget build(BuildContext context) {
    return ConsoleWidget(
      options: ConsoleOptions(),
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: ColorPlate.lightGray,
          appBar: AppBar(
            title: const Text(
              'FConsole example app',
            ),
          ),
          body: ListView(
            children: [
              AspectRatio(
                aspectRatio: 24 / 9,
                child: Center(
                  child: StText.big(
                    'FConsole Example',
                    style: TextStyle(color: ColorPlate.blue),
                  ),
                ),
              ),
              SettingRow(
                icon: consoleHasShow ? Icons.tab : Icons.tab_unselected,
                text: consoleHasShow ? 'Console打开' : 'Console关闭',
                right: Container(
                  height: 36,
                  padding: EdgeInsets.only(right: 12),
                  child: Switch(
                    value: consoleHasShow,
                    onChanged: (v) {
                      if (v) {
                        showConsole();
                      } else {
                        hideConsole();
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
              Container(height: 12),
              SettingRow(
                icon: Icons.info_outline,
                text: '打印log',
                right: Container(),
                onTap: () {
                  FConsole.log("打印了一行log");
                },
              ),
              SettingRow(
                icon: Icons.warning,
                text: '打印error',
                right: Container(),
                onTap: () {
                  FConsole.error("打印了一行error");
                },
              ),
              Container(height: 12),
              SettingRow(
                icon: Icons.warning,
                text: '打印',
                right: Container(),
                onTap: () {
                  print(FlowCenter.instance.flowList);
                },
              ),
              SettingRow(
                icon: Icons.warning,
                text: '清除',
                right: Container(),
                onTap: () {
                  FlowCenter.instance.flowList.clear();
                },
              ),
              SettingRow(
                icon: Icons.info_outline,
                text: '滑动事件Flow',
                right: Slider(
                  value: slideValue,
                  onChanged: (v) {
                    FlowLog.of(
                      '滑动Slider',
                      Duration(seconds: 3),
                    ).log('Value: $v');
                    setState(() {
                      slideValue = v;
                    });
                  },
                  // onChangeEnd: (value) => FlowLog.of('滑动Slider').end(),
                ),
              ),
            ],
          ),
          // body: Builder(
          //   builder: (ctx) {
          //     return FlatButton(
          //       onPressed: () {
          //         FConsole.log("asdadasd");
          //       },
          //       child: Center(
          //         child: Text('Running on: $_platformVersion\n'),
          //       ),
          //     );
          //   },
          // ),
          // floatingActionButton: Builder(
          //   builder: (ctx) {
          //     return FlatButton(
          //       onPressed: () {
          //         showConsole();
          //       },
          //       child: Container(
          //         height: 50,
          //         child: Text("show console"),
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final double padding;
  final IconData icon;
  final Widget right;
  final Widget beforeRight;
  final String text;
  final Color textColor;
  final Function onTap;
  const SettingRow({
    Key key,
    this.padding: 14,
    this.icon,
    this.text,
    this.textColor,
    this.right,
    this.onTap,
    this.beforeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Container(
      color: ColorPlate.white,
      padding: EdgeInsets.only(left: 8),
      child: Row(
        children: <Widget>[
          icon == null
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    icon,
                    size: 20,
                    color: textColor,
                  ),
                ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: padding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ColorPlate.lightGray),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: StText.normal(
                        text ?? '--',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      beforeRight ?? Container(),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: right ??
                            Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorPlate.gray,
                                size: 12,
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (onTap == null) {
      return child;
    }
    return Tapped(
      onTap: onTap,
      child: child,
    );
  }
}
