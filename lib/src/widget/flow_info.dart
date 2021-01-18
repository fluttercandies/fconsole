import 'package:animations/animations.dart';
import 'package:fconsole/fconsole.dart';
import 'package:fconsole/src/style/color.dart';
import 'package:fconsole/src/style/text.dart';
import 'package:flutter/material.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:share/share.dart';
import 'package:tapped/tapped.dart';

class FlowInfo extends StatefulWidget {
  @override
  _FlowInfoState createState() => _FlowInfoState();
}

class _FlowInfoState extends State<FlowInfo> {
  int currentIndex = 0;

  /// 正在查看详情列表
  bool get isDetailPage => currentLog != null;
  FlowLog currentLog;

  List<FlowLog> get currentList {
    if (currentIndex == 0) {
      return FlowCenter.instance.flowList;
    }
    if (currentIndex == 1) {
      return FlowCenter.instance.workingFlow.values.toList();
    }
    return [];
  }

  @override
  initState() {
    super.initState();
    FlowCenter.instance.addListener(_didUpdateLog);
  }

  @override
  dispose() {
    FlowCenter.instance.removeListener(_didUpdateLog);
    super.dispose();
  }

  _didUpdateLog() {
    setState(() {});
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
          _TapBtn(
            selected: currentIndex == 0,
            small: true,
            title: "Done",
            onTap: () {
              setState(() {
                currentIndex = 0;
              });
            },
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: ColorPlate.gray,
          ),
          _TapBtn(
            selected: currentIndex == 1,
            small: true,
            title: "Processing",
            space: 12,
            onTap: () {
              setState(() {
                currentIndex = 1;
              });
            },
          ),
        ],
      ),
    );
    var detailPage = FlowLogDetailPage(
      flowLog: currentLog,
      onBack: () {
        setState(() {
          currentLog = null;
        });
      },
    );

    var tablePage = Column(
      children: [
        tabbar,
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                var flowlog = currentList[index];
                var desc = flowlog.desc;
                return _Row(
                  title: flowlog.name,
                  desc: desc.detail,
                  detail1: 'Start: ${flowlog.startTimeText}',
                  detail2: 'End: ${flowlog.endTimeText}',
                  isWarning: desc.hasError,
                  onShare: () {
                    Share.share(flowlog.shareText);
                  },
                  onTap: () {
                    // flow log详情
                    setState(() {
                      currentLog = flowlog;
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
    return AnimatedSwither(
      reverse: isDetailPage,
      child: isDetailPage ? detailPage : tablePage,
    );
  }
}

/// 查看一个Flow log的详情
class FlowLogDetailPage extends StatelessWidget {
  final FlowLog flowLog;
  final Function onBack;

  const FlowLogDetailPage({
    Key key,
    this.flowLog,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: ColorPlate.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ActBtn(
                  onTap: onBack,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: ColorPlate.darkGray,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: StText.normal(flowLog.name ?? '--'),
                  ),
                ),
                _ActBtn(
                  onTap: () {
                    Share.share(flowLog.shareText);
                  },
                  right: true,
                  child: Icon(
                    Icons.share,
                    size: 16,
                    color: ColorPlate.darkGray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: .5,
            color: ColorPlate.gray.withOpacity(0.5),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: flowLog.logs.length,
                itemBuilder: (context, index) {
                  var log = flowLog.logs[index];
                  var startTime = flowLog
                      .logs[(index - 1).clamp(
                    0,
                    9999,
                  )]
                      .dateTime;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPlate.white,
                      border: Border(
                        bottom: BorderSide(
                          color: ColorPlate.lightGray,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: StText.normal("${log.log}"),
                        ),
                        StText.normal(
                            "+${log.dateTime.difference(startTime).inMilliseconds}ms"),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActBtn extends StatelessWidget {
  const _ActBtn({
    Key key,
    @required this.onTap,
    this.child,
    this.right: false,
  }) : super(key: key);

  final bool right;
  final Widget child;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: ColorPlate.white,
          border: right
              ? Border(
                  left: BorderSide(
                    color: ColorPlate.gray.withOpacity(.5),
                    width: .5,
                  ),
                )
              : Border(
                  right: BorderSide(
                    color: ColorPlate.gray.withOpacity(.5),
                    width: .5,
                  ),
                ),
        ),
        child: child,
      ),
    );
  }
}

class AnimatedSwither extends StatelessWidget {
  final bool reverse;
  final Widget child;

  const AnimatedSwither({
    Key key,
    this.reverse,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      reverse: !reverse,
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        );
      },
      child: child,
    );
  }
}

/// 一行FlowLog组
class _Row extends StatelessWidget {
  final String title;
  final String desc;
  final String detail1;
  final String detail2;
  final bool isWarning;
  final bool isProcessing;
  final Function onTap;
  final Function onShare;
  const _Row({
    Key key,
    this.title,
    this.desc,
    this.detail1,
    this.detail2,
    this.isWarning: false,
    this.isProcessing: false,
    this.onTap,
    this.onShare,
  }) : super(key: key);

  Icon get icon {
    if (isWarning) {
      return Icon(
        Icons.warning,
        size: 18,
        color: ColorPlate.red,
      );
    }
    if (isProcessing) {
      return Icon(
        Icons.schedule,
        size: 18,
        color: ColorPlate.orange,
      );
    }
    return Icon(
      Icons.check_circle,
      size: 18,
      color: ColorPlate.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LeftScroll(
      key: key,
      onTap: onTap,
      buttons: [
        Tapped(
          onTap: onShare,
          child: Container(
            color: ColorPlate.orange,
            child: Center(
              child: StText.normal(
                'Share',
                style: TextStyle(color: ColorPlate.white),
              ),
            ),
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
        decoration: BoxDecoration(
          color: ColorPlate.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: ColorPlate.gray.withOpacity(.5),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: icon,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    child: StText.normal(title ?? '??'),
                  ),
                  StText.small(
                    desc ?? '- Logs, - Warnings',
                    style: TextStyle(
                      color: ColorPlate.darkGray,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StText.small(detail1 ?? '-'),
                StText.small(detail2 ?? '-'),
              ],
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: ColorPlate.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 选项卡按钮
class _TapBtn extends StatelessWidget {
  final String title;
  final double space;
  final double minwidth;
  final bool selected;
  final bool small;
  final Function onTap;

  const _TapBtn({
    Key key,
    this.title,
    this.space: 24,
    this.selected: false,
    this.onTap,
    this.small: false,
    this.minwidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: minwidth ?? 60),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: selected ? ColorPlate.white : ColorPlate.clear,
          padding: EdgeInsets.symmetric(horizontal: space),
          child: Center(
            child: small
                ? StText.normal(title ?? '??')
                : StText.big(title ?? '??'),
          ),
        ),
      ),
    );
  }
}
