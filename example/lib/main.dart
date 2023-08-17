import 'package:flutter/material.dart';
import 'package:fconsole/fconsole.dart';
import './style/color.dart';
import './style/text.dart';
import 'package:tapped/tapped.dart';

import 'style/color.dart';

void main() => runAppWithFConsole(
      MyApp(),
      delegate: MyCardDelegate(),
    );

class MyCardDelegate extends FConsoleCardDelegate {
  @override
  List<FConsoleCard> cardsBuilder(DefaultCards defaultCards) {
    return [
      defaultCards.logCard,
      defaultCards.flowCard,
      FConsoleCard(
        name: "Custom",
        builder: (ctx) => CustomLogPage(),
      ),
      defaultCards.sysInfoCard,
    ];
  }
}

class CustomLogPage extends StatelessWidget {
  const CustomLogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('custom page content'),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FConsole.instance.status.addListener(() {
      setState(() {});
    });
  }

  bool get consoleHasShow =>
      FConsole.instance.status.value != FConsoleStatus.hide;

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
                  fconsole.log('打印信息:', DateTime.now());
                },
              ),
              SettingRow(
                icon: Icons.warning,
                text: '打印error',
                right: Container(),
                onTap: () {
                  fconsole.error('打印Error:', DateTime.now());
                },
              ),
              Container(height: 12),
              SettingRow(
                icon: Icons.edit,
                text: '原生Print',
                right: Container(),
                onTap: () {
                  print('${DateTime.now().toIso8601String()}');
                },
              ),
              SettingRow(
                icon: Icons.edit,
                text: '原生Throw',
                right: Container(),
                onTap: () {
                  var _ = [][123];
                  throw '${DateTime.now().toIso8601String()}';
                },
              ),
              Container(height: 12),
              SettingRow(
                icon: Icons.info_outline,
                text: '滑动事件Flow',
                right: Slider(
                  value: slideValue,
                  onChanged: (v) {
                    // FlowLog.of(
                    //   '滑动Slider',
                    //   Duration(seconds: 2),
                    // ).log('Value: $v');
                    FlowLog.of(
                      '滑动Slider',
                      Duration(seconds: 2),
                    ).log({
                      'type': 'slide',
                      "value": [
                        for (var i = 0; i < 100; i++)
                          {
                            "value": {
                              "value": {
                                "value": {
                                  "value": "$v",
                                },
                              },
                            },
                          },
                      ],
                    });
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
  final double? padding;
  final IconData? icon;
  final Widget? right;
  final Widget? beforeRight;
  final String? text;
  final Color? textColor;
  final Function? onTap;
  const SettingRow({
    Key? key,
    this.padding = 14,
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
              padding: EdgeInsets.symmetric(vertical: padding ?? 0),
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
