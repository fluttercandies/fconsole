import 'package:fconsole/src/model/flow.dart';
import 'package:fconsole/src/model/log.dart';
import 'package:fconsole/src/style/color.dart';
import 'package:fconsole/src/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:tapped/tapped.dart';

/// 查看一个Flow log的详情
class FlowLogDetailPage extends StatelessWidget {
  final FlowLog? log;
  final Function? onBack;

  const FlowLogDetailPage({
    Key? key,
    required this.log,
    this.onBack,
  }) : super(key: key);

  FlowLog get flowLog => log!;

  @override
  Widget build(BuildContext context) {
    if (log == null) return Container();

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
                    child: StText.normal(flowLog.name),
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
                itemCount: flowLog.logs!.length,
                itemBuilder: (context, index) {
                  var l = flowLog.logs!;
                  var log = l[index];
                  var _index = (index - 1).clamp(
                    0,
                    l.length - 1,
                  );
                  var endTime = flowLog.logs![_index].dateTime!;
                  return GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: "${log.log}",
                        ),
                      );
                      // TODO:
                      // showToast("Copy Success");
                    },
                    child: Container(
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
                            child: StText.normal(
                              "${log.log}",
                              style: TextStyle(
                                color: log.type == LogType.error
                                    ? ColorPlate.red
                                    : null,
                              ),
                            ),
                          ),
                          StText.normal(
                            "+${endTime.difference(log.dateTime!).inMilliseconds.abs()}ms",
                            style: TextStyle(
                              color: log.type == LogType.error
                                  ? ColorPlate.red
                                  : null,
                            ),
                          ),
                        ],
                      ),
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
    Key? key,
    required this.onTap,
    this.child,
    this.right: false,
  }) : super(key: key);

  final bool right;
  final Widget? child;
  final Function? onTap;

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