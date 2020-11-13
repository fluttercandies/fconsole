import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:fconsole/src/core/fconsole.dart';
import 'package:fconsole/src/model/log.dart';
import 'package:fconsole/src/style/color.dart';
import 'package:fconsole/src/style/text.dart';
import 'package:fconsole/src/widget/flow_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:oktoast/oktoast.dart';
import 'package:tapped/tapped.dart';

part 'console_panel.dart';

part 'console_container.dart';

LinkedHashMap<Object, BuildContext> _contextMap = LinkedHashMap();

OverlayEntry consoleEntry;

///show console btn
void showConsole({BuildContext context}) {
  if (!FConsole.instance.isShow.value) {
    FConsole.instance.isShow.value = true;
    context ??= _contextMap.values.first;
    _ConsoleTheme _consoleTheme = _ConsoleTheme.of(context);
    Widget consoleBtn = _consoleTheme.consoleBtn ?? _consoleBtn();

    Alignment consolePosition =
        _consoleTheme.consolePosition ?? Alignment(-0.8, 0.7);

    consoleEntry = OverlayEntry(builder: (ctx) {
      return ConsoleContainer(
        consoleBtn: consoleBtn,
        consolePosition: consolePosition,
      );
    });
    Overlay.of(context).insert(consoleEntry);
  }
}

///hide console btn
void hideConsole({BuildContext context}) {
  if (consoleEntry != null && FConsole.instance.isShow.value) {
    FConsole.instance.isShow.value = false;
    consoleEntry.remove();
    consoleEntry = null;
  }
}

OverlayEntry consolePanelEntry;

///show console panel
showConsolePanel(Function onHideTap, {BuildContext context}) {
  context ??= _contextMap.values.first;
  consolePanelEntry = OverlayEntry(builder: (ctx) {
    return ConsolePanel(() {
      onHideTap?.call();
      hideConsolePanel();
    });
  });
  Overlay.of(context).insert(consolePanelEntry);
}

hideConsolePanel() {
  if (consolePanelEntry != null) {
    consolePanelEntry.remove();
    consolePanelEntry = null;
  }
}

class ConsoleWidget extends StatefulWidget {
  final Widget child;
  final Widget consoleBtn;
  final Alignment consolePosition;

  ConsoleWidget({
    Key key,
    @required this.child,
    this.consolePosition,
    this.consoleBtn,
  }) : super(key: key);

  @override
  _ConsoleWidgetState createState() => _ConsoleWidgetState();
}

class _ConsoleWidgetState extends State<ConsoleWidget> {
  dispose() {
    _contextMap.remove(this);
    FConsole.instance.stopShakeListener();
    super.dispose();
  }

  initState() {
    super.initState();
    if (FConsole.instance.options.displayMode == ConsoleDisplayMode.Shake) {
      FConsole.instance.startShakeListener(() {
        if (mounted) {
          showConsole();
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (FConsole.instance.options.displayMode == ConsoleDisplayMode.Always) {
        showConsole();
      }
    });
  }

  Widget build(BuildContext context) {
    return Localizations(
      locale: Locale("zh"),
      delegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: MediaQuery(
        data: MediaQueryData.fromWindow(window).removePadding(removeTop: true),
        child: Material(
          child: OKToast(
            radius: 4,
            backgroundColor: ColorPlate.black.withOpacity(0.6),
            child: _ConsoleTheme(
              consoleBtn: widget.consoleBtn,
              consolePosition: widget.consolePosition,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Overlay(initialEntries: [
                  OverlayEntry(builder: (ctx) {
                    _contextMap[this] = ctx;
                    return widget.child;
                  })
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsoleTheme extends InheritedWidget {
  final Widget consoleBtn;
  final Widget child;
  final Alignment consolePosition;

  _ConsoleTheme({this.child, this.consoleBtn, this.consolePosition})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static _ConsoleTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ConsoleTheme>();
}
