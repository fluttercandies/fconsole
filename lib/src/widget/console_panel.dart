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
    return Material(
      color: Colors.black26,
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
              color: Colors.white,
              width: double.infinity,
              height: MediaQueryData.fromWindow(window).size.height * 0.8,
              child: Column(
                children: <Widget>[
                  topOpViews(),
                  Expanded(
                    child: IndexedStack(
                      index: currentIndex,
                      children: <Widget>[LogInfoPannel(), SystemInfoPannel()],
                    ),
                  ),
                  bottomOpViews()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topOpViews() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: currentIndex == 0 ? Colors.white : Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 0) {
                  currentIndex = 0;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: Text("Log",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: Colors.grey[300],
          ),
          Container(
            color: currentIndex == 1 ? Colors.white : Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 1) {
                  currentIndex = 1;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: Text(
                  "System",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomOpViews() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          bottom: MediaQueryData.fromWindow(window).padding.bottom),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2))),
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (currentIndex == 0) {
                    FConsole.instance.clear();
                  }
                },
                child: Center(
                  child: Text("Clear", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey[300],
            ),
            Expanded(
              child: CupertinoButton(
                onPressed: () {
                  widget.onHideTap?.call();
                },
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    "Hide",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
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
  TabController tabController;

  List<Widget> _logViewList = [
    _LogListView(0),
    _LogListView(1),
    _LogListView(2)
  ];

  int currentIndex = 0; //0 all 1 log 2 error

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentIndex = tabController.index;
      FConsole.instance.currentLogIndex = currentIndex;
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget tabbar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: currentIndex == 0 ? Colors.white : Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 0) {
                  currentIndex = 0;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: Text("All",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ),
          Container(
            color: currentIndex == 1 ? Colors.white : Colors.transparent,
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
                child: Text("Log",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: Colors.grey[300],
          ),
          Container(
            color: currentIndex == 2 ? Colors.white : Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                if (currentIndex != 2) {
                  currentIndex = 2;
                  setState(() {});
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: Text(
                  "Error",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
            child: tabbar()),
        Expanded(
          child: IndexedStack(
            children: _logViewList,
            index: currentIndex,
          ),
        )
      ],
    );
  }
}

class _LogListView extends StatefulWidget {
  final int currentIndex;

  _LogListView(this.currentIndex);

  @override
  __LogListViewState createState() => __LogListViewState();
}

class __LogListViewState extends State<_LogListView> with ConsoleLogListener {
  final TextEditingController _filterTEC = TextEditingController();
  List<Log> logs;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    List<Log> newlogs = newLogs();

    return Column(
      children: <Widget>[
        filterView(),
        Expanded(
            child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(
                        ClipboardData(text: newlogs[index].toString()));
                    showToast("Copy Success");
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (FConsole.instance.options.showTime)
                          Text(time(newlogs[index]) + " : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 16)),
                        Expanded(
                          child: Text(
                            newlogs[index].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: currentIndex == 2
                                    ? Colors.red
                                    : Colors.black54,
                                fontSize: 16),
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
          itemCount: newlogs.length,
        )),
      ],
    );
  }

  initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    logs = FConsole.instance.logs(currentIndex);
    FConsole.instance.addConsoleLogListener(this);
  }

  dispose() {
    super.dispose();
    FConsole.instance.removeConsoleLogListener(this);
    _filterTEC.dispose();
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
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              toolbarOptions: ToolbarOptions(),
              controller: _filterTEC,
              clearButtonMode: OverlayVisibilityMode.editing,
              style: TextStyle(color: Colors.black, fontSize: 16),
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
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  "Filter",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void onAddLog() {
    logs = FConsole.instance.logs(currentIndex);
    setState(() {});
  }

  @override
  void onClearLog() {
    logs = FConsole.instance.logs(currentIndex);
    setState(() {});
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
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
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
