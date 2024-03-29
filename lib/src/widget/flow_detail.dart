import 'dart:convert';

import 'package:fconsole/src/model/flow.dart';
import 'package:fconsole/src/model/log.dart';
import 'package:fconsole/src/style/color.dart';
import 'package:fconsole/src/style/text.dart';
import 'package:fconsole/src/widget/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_view/json_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tapped/tapped.dart';

/// 查看一个Flow log的详情
class FlowLogDetailPage extends StatefulWidget {
  final FlowLog? log;
  final Function? onBack;

  const FlowLogDetailPage({
    Key? key,
    required this.log,
    this.onBack,
  }) : super(key: key);

  @override
  State<FlowLogDetailPage> createState() => _FlowLogDetailPageState();
}

class _FlowLogDetailPageState extends State<FlowLogDetailPage> {
  FlowLog get flowLog => widget.log!;

  Map<int, bool> isJsonViewMap = {};

  @override
  Widget build(BuildContext context) {
    if (widget.log == null) return Container();

    return Container(
      child: Column(
        children: [
          Container(
            color: ColorPlate.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ActBtn(
                  onTap: widget.onBack,
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
                      if (log.isJson) {
                        Clipboard.setData(
                          ClipboardData(
                            text: json.encode(log.log),
                          ),
                        );
                        showFconsoleMessage("JSON Copy Success");
                      } else {
                        Clipboard.setData(
                          ClipboardData(
                            text: "${log.log}",
                          ),
                        );
                        showFconsoleMessage("Copy Success");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
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
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (log.isJson)
                                    _TypeSwitch(
                                      isJson: isJsonViewMap[index] == true,
                                      onChange: (v) {
                                        setState(() {
                                          isJsonViewMap[index] = v;
                                        });
                                      },
                                    ),
                                  if (isJsonViewMap[index] != true)
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: StText.normal(
                                        "${log.log}",
                                        style: TextStyle(
                                          color: log.type == LogType.error
                                              ? ColorPlate.red
                                              : null,
                                        ),
                                      ),
                                    ),
                                  if (isJsonViewMap[index] == true)
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: 480,
                                      ),
                                      margin: EdgeInsets.only(top: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorPlate.lightGray),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Scrollbar(
                                        child: JsonView(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          shrinkWrap: true,
                                          json: log.log,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 64,
                            ),
                            alignment: Alignment.centerRight,
                            child: StText.normal(
                              "+${endTime.difference(log.dateTime!).inMilliseconds.abs()}ms",
                              style: TextStyle(
                                color: log.type == LogType.error
                                    ? ColorPlate.red
                                    : null,
                              ),
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

class _TypeSwitch extends StatelessWidget {
  const _TypeSwitch({
    Key? key,
    required this.isJson,
    required this.onChange,
  }) : super(key: key);

  final bool isJson;
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: ColorPlate.lightGray,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            child: Tapped(
              onTap: () => onChange.call(false),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: !isJson ? ColorPlate.white : ColorPlate.lightGray,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: StText.small('Raw'),
              ),
            ),
          ),
          Expanded(
            child: Tapped(
              onTap: () => onChange.call(true),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isJson ? ColorPlate.white : ColorPlate.lightGray,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: StText.small('JSON'),
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
    this.right = false,
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
