import 'package:fconsole/fconsole.dart';
import 'package:fconsole/src/style/color.dart';
import 'package:fconsole/src/style/text.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class FlowInfo extends StatefulWidget {
  @override
  _FlowInfoState createState() => _FlowInfoState();
}

class _FlowInfoState extends State<FlowInfo> {
  int currentIndex = 0;
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
            title: "All",
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
            title: "Success",
            space: 12,
            onTap: () {
              setState(() {
                currentIndex = 1;
              });
            },
          ),
          Container(
            width: 0.5,
            height: double.infinity,
            color: ColorPlate.gray,
          ),
          _TapBtn(
            selected: currentIndex == 2,
            small: true,
            title: "Warning",
            space: 12,
            onTap: () {
              setState(() {
                currentIndex = 2;
              });
            },
          ),
        ],
      ),
    );
    return Container(
      child: Column(
        children: [
          tabbar,
          Expanded(
            child: PageView(
              children: [
                ListView.builder(
                  itemCount: FlowCenter.instance.flowList.length,
                  itemBuilder: (context, index) {
                    var flowlog = FlowCenter.instance.flowList[index];
                    return _Row(
                      title: flowlog.id,
                      desc: flowlog.desc,
                      detail1: 'Start: ${flowlog.startTimeText}',
                      detail2: 'End: ${flowlog.endTimeText}',
                      onTap: () {
                        // TODO: flow log详情
                      },
                    );
                  },
                ),
                Center(
                  child: StText.normal('todo'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class AnimatedSwither extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return PageTransitionSwitcher(
//       duration: const Duration(milliseconds: 300),
//       reverse: inProgress,
//       transitionBuilder: (
//         Widget child,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//       ) {
//         return SharedAxisTransition(
//           child: child,
//           animation: animation,
//           secondaryAnimation: secondaryAnimation,
//           transitionType: SharedAxisTransitionType.scaled,
//         );
//       },
//       child: inProgress
//           ? _ProgressContainer(
//               progress: progress,
//             )
//           : updateBtn,
//     );
//   }
// }

class _Row extends StatelessWidget {
  final String title;
  final String desc;
  final String detail1;
  final String detail2;
  final bool isWarning;
  final Function onTap;
  const _Row({
    Key key,
    this.title,
    this.desc,
    this.detail1,
    this.detail2,
    this.isWarning,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
        decoration: BoxDecoration(
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
              child: Icon(
                Icons.warning,
                size: 18,
                color: ColorPlate.orange,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    child: StText.normal(title ?? 'Open Lock'),
                  ),
                  StText.small(
                    desc ?? '2 Logs, 12 Warnings',
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
