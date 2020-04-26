import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fconsole/fconsole.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "";

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConsoleWidget(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Builder(
            builder: (ctx) {
              return FlatButton(
                onPressed: () {
                  Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) {
                    return Scaffold(
                      appBar: AppBar(),
                    );
                  }));
                },
                child: Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (ctx) {
              return FlatButton(
                onPressed: () {
                  showConsole();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
