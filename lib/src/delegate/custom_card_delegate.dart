import 'package:fconsole/src/widget/console.dart';
import 'package:fconsole/src/widget/flow_info.dart';
import 'package:flutter/material.dart';

abstract class FConsoleCardDelegate {
  List<CustomCard> cardsBuilder(DefaultCards defaultCards);
}

class DefaultCardDelegate extends FConsoleCardDelegate {
  @override
  List<CustomCard> cardsBuilder(DefaultCards defaultCards) {
    return [
      defaultCards.logCard,
      defaultCards.flowCard,
      defaultCards.sysInfoCard,
    ];
  }
}

class DefaultCards {
  final CustomCard logCard = CustomCard(
    name: 'Log',
    builder: (context) => LogInfoPannel(),
  );
  final CustomCard flowCard = CustomCard(
    name: 'Flow',
    builder: (context) => FlowInfo(),
  );
  final CustomCard sysInfoCard = CustomCard(
    name: 'System',
    builder: (context) => SystemInfoPannel(),
  );
}

class CustomCard {
  final String name;
  final Widget Function(BuildContext context) builder;

  CustomCard({required this.name, required this.builder});
}
