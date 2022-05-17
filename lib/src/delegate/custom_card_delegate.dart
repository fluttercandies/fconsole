import 'package:fconsole/src/widget/console.dart';
import 'package:fconsole/src/widget/flow_info.dart';
import 'package:flutter/material.dart';

abstract class FConsoleCardDelegate {
  List<FConsoleCard> cardsBuilder(DefaultCards defaultCards);
}

class DefaultCardDelegate extends FConsoleCardDelegate {
  @override
  List<FConsoleCard> cardsBuilder(DefaultCards defaultCards) {
    return [
      defaultCards.logCard,
      defaultCards.flowCard,
      defaultCards.sysInfoCard,
    ];
  }
}

class DefaultCards {
  final FConsoleCard logCard = FConsoleCard(
    name: 'Log',
    builder: (context) => LogInfoPannel(),
  );
  final FConsoleCard flowCard = FConsoleCard(
    name: 'Flow',
    builder: (context) => FlowInfo(),
  );
  final FConsoleCard sysInfoCard = FConsoleCard(
    name: 'System',
    builder: (context) => SystemInfoPannel(),
  );
}

class FConsoleCard {
  final String name;
  final Widget Function(BuildContext context) builder;

  FConsoleCard({required this.name, required this.builder});
}
