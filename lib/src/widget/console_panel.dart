part of 'console.dart';

class ConsolePanel extends StatefulWidget {
  final Function onHideTap;

  ConsolePanel(this.onHideTap);

  @override
  _ConsolePanelState createState() => _ConsolePanelState();
}

class _ConsolePanelState extends State<ConsolePanel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var topOpViews = Container(
      height: 50,
      decoration: BoxDecoration(
        color: ColorPlate.lightGray,
        border: Border(
          bottom: BorderSide(color: ColorPlate.gray, width: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            color: currentIndex == 0 ? ColorPlate.white : ColorPlate.clear,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 0) {
                  currentIndex = 0;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: StText.big('Log'),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: ColorPlate.gray.withOpacity(0.5),
          ),
          Container(
            color: currentIndex == 1 ? ColorPlate.white : ColorPlate.clear,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 1) {
                  currentIndex = 1;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: StText.big("Flow"),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: ColorPlate.gray.withOpacity(0.5),
          ),
          Container(
            color: currentIndex == 2 ? ColorPlate.white : ColorPlate.clear,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 2) {
                  currentIndex = 2;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: StText.big("System"),
              ),
            ),
          ),
        ],
      ),
    );
    var bottomOpViews = Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          bottom: MediaQueryData.fromWindow(window).padding.bottom),
      decoration: BoxDecoration(
        color: ColorPlate.lightGray,
        border: Border(
          top: BorderSide(color: ColorPlate.gray, width: 0.2),
        ),
      ),
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Tapped(
                onTap: () {
                  // if (currentIndex == 0) {
                  FConsole.instance.clear(true);
                  // }
                },
                child: Container(
                  color: ColorPlate.clear,
                  child: Center(
                    child: StText.normal("Clear"),
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: ColorPlate.gray,
            ),
            Expanded(
              child: Tapped(
                onTap: () {
                  widget.onHideTap?.call();
                },
                child: Container(
                  color: ColorPlate.clear,
                  child: Center(
                    child: StText.normal(
                      "Hide",
                      style: TextStyle(color: ColorPlate.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return Material(
      color: ColorPlate.black.withOpacity(0.3),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: <Widget>[
            Expanded(
                child: GestureDetector(
              onTap: () {
                widget.onHideTap?.call();
              },
              behavior: HitTestBehavior.translucent,
            )),
            Container(
              alignment: Alignment.bottomCenter,
              color: ColorPlate.white,
              width: double.infinity,
              height: MediaQueryData.fromWindow(window).size.height * 0.8,
              child: Column(
                children: <Widget>[
                  topOpViews,
                  Expanded(
                    child: IndexedStack(
                      index: currentIndex,
                      children: <Widget>[
                        LogInfoPannel(),
                        FlowInfo(),
                        SystemInfoPannel(),
                      ],
                    ),
                  ),
                  bottomOpViews
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  get isDark =>
      MediaQueryData.fromWindow(window).platformBrightness == Brightness.dark;
}

class LogInfoPannel extends StatefulWidget {
  @override
  _LogInfoPannelState createState() => _LogInfoPannelState();
}

class _LogInfoPannelState extends State<LogInfoPannel>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;

  int get currentIndex => _currentTabIndex; //0 all 1 log 2 error

  set currentIndex(int index) {
    _currentTabIndex = index;
    FConsole.instance.currentLogIndex = _currentTabIndex;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabbar = Container(
      height: 40,
      decoration: BoxDecoration(
        color: ColorPlate.lightGray,
        border: Border(
          bottom: BorderSide(color: ColorPlate.gray, width: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: currentIndex == 0 ? ColorPlate.white : ColorPlate.clear,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 0) {
                  currentIndex = 0;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: StText.normal("All"),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: ColorPlate.gray,
          ),
          Container(
            color: currentIndex == 1 ? ColorPlate.white : ColorPlate.clear,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 1) {
                  currentIndex = 1;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: StText.normal("Log"),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: ColorPlate.gray,
          ),
          Container(
            color: currentIndex == 2 ? ColorPlate.white : ColorPlate.clear,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 2) {
                  currentIndex = 2;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: StText.normal("Error"),
              ),
            ),
          ),
        ],
      ),
    );
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorPlate.gray,
            border: Border(
              bottom: BorderSide(color: ColorPlate.gray, width: 0.2),
            ),
          ),
          child: tabbar,
        ),
        Expanded(
          child: IndexedStack(
            children: [_LogListView(0), _LogListView(1), _LogListView(2)],
            index: currentIndex,
          ),
        )
      ],
    );
  }
}

extension _LogColor on Log {
  Color get color {
    switch (this.type) {
      case LogType.log:
        return ColorPlate.darkGray;
        break;
      case LogType.error:
        return ColorPlate.red;
        break;
    }
    return ColorPlate.darkGray;
  }
}

class _LogListView extends StatefulWidget {
  final int currentIndex;

  _LogListView(this.currentIndex);

  @override
  __LogListViewState createState() => __LogListViewState();
}

class __LogListViewState extends State<_LogListView> {
  final TextEditingController _filterTEC = TextEditingController();
  List<Log> logs;
  int currentIndex;

  @override
  initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    logs = FConsole.instance.logs(currentIndex);
    FConsole.instance.addListener(_didUpdateLog);
  }

  @override
  dispose() {
    super.dispose();
    FConsole.instance.removeListener(_didUpdateLog);
    _filterTEC.dispose();
  }

  _didUpdateLog() {
    setState(() {
      logs = FConsole.instance.logs(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Log> newlogs = newLogs();

    return Column(
      children: <Widget>[
        filterView(),
        Expanded(
          child: ListView.builder(
            itemCount: newlogs.length,
            itemBuilder: (ctx, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: newlogs[index].toString(),
                        ),
                      );
                      showToast("Copy Success");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: StText.normal(
                                '${newlogs[index]}',
                                style: TextStyle(
                                  color: newlogs[index].color,
                                ),
                              ),
                            ),
                          ),
                          if (FConsole.instance.options.showTime)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: StText.small(
                                "${time(newlogs[index])}",
                                style: TextStyle(
                                  color: currentIndex == 2
                                      ? ColorPlate.red
                                      : ColorPlate.darkGray,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String time(Log log) {
    if (FConsole.instance.options.showTime) {
      return DateFormat(FConsole.instance.options.timeFormat)
              .format(log.dateTime) ??
          "";
    }
    return "";
  }

  List<Log> newLogs() {
    List<Log> newlogs = List.from(logs);
    if (_filterTEC.text.trim().isNotEmpty) {
      String filter = _filterTEC.text.trim();
      //过滤
      newlogs
        ..retainWhere((log) {
          return log.toString().contains(filter);
        });
    }
    return newlogs;
  }

  Widget filterView() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorPlate.gray, width: 0.2))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              toolbarOptions: ToolbarOptions(),
              controller: _filterTEC,
              clearButtonMode: OverlayVisibilityMode.editing,
              style: TextStyle(color: ColorPlate.black, fontSize: 16),
              decoration: BoxDecoration(),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: double.infinity,
              color: ColorPlate.lightGray,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  "Filter",
                  style: TextStyle(color: ColorPlate.black, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SystemInfoPannel extends StatefulWidget {
  @override
  _SystemInfoPannelState createState() => _SystemInfoPannelState();
}

class _SystemInfoPannelState extends State<SystemInfoPannel> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (mounted) {
      setState(() {});
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      //'Manufacturer': build.manufacturer, //制造商
      'Model': build.model, //终端产品名称
      //'Brand': build.brand, //产品品牌
      // 'version.securityPatch': build.version.securityPatch,
      'Version.sdkInt': build.version.sdkInt,
      'Version.release': build.version.release,
      // 'Version.previewSdkInt': build.version.previewSdkInt,
      // 'Version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      //'version.baseOS': build.version.baseOS,
      // 'Board': build.board,
      //  'bootloader': build.bootloader,

      // 'device': build.device,
      //'display': build.display,
      //'fingerprint': build.fingerprint,
      //'hardware': build.hardware,
      //'host': build.host,
      //'id': build.id,
      // 'product': build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      'SupportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'AndroidId': build.androidId,
      // 'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'Name': data.name,
      'SystemName': data.systemName,
      'SystemVersion': data.systemVersion,
      'Model': data.model,
      //'LocalizedModel': data.localizedModel,
      'IdentifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
//      'utsname.sysname:': data.utsname.sysname,
//      'utsname.nodename:': data.utsname.nodename,
//      'utsname.release:': data.utsname.release,
//      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _deviceData.keys.map((String property) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Text(
                    property,
                    style: const TextStyle(
                      color: ColorPlate.darkGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: Text(
                    '${_deviceData[property]}',
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],
            ),
            Divider(
              height: 1,
            ),
          ],
        );
      }).toList(),
    );
  }
}
