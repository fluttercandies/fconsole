import 'package:fconsole/src/widget/console.dart';
import 'package:fconsole/src/widget/flow_info.dart';
import 'package:flutter/material.dart';

abstract class CustomCardDelegate {
  List<CustomCard> cardsBuilder(DefaultCards defaultCards);
}

class DefaultCardDelegate extends CustomCardDelegate {
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
    'Log',
    (context) => LogInfoPannel(),
  );
  final CustomCard flowCard = CustomCard(
    'Flow',
    (context) => FlowInfo(),
  );
  final CustomCard sysInfoCard = CustomCard(
    'System',
    (context) => SystemInfoPannel(),
  );
}

class CustomCard {
  final String name;
  final Widget Function(BuildContext context) builder;

  CustomCard(this.name, this.builder);
}
