import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notification/services.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotifcationHelper notifcationHelper = NotifcationHelper();
  int _counter = 0;
  String? token;

  void _incrementCounter() async {
    var payload = {
      'to':
          'dt_0Bj2LQP-M9ENzFpB_8E:APA91bFUnfVsqWQ0c2IA7vgN5UeBt6LYBGVYH1xnds6z5odzvuALTz52hkW06I6of7UylMzNJZ9l-RoBIXZNXZZvhkfWR7-X6v7LB9IE36P182gIRWUVQfl2Q8D4vBTNS0QX4BX5P3Yr',
      'notification': {
        'title': 'My Notification',
        'body': 'notification from mobile',
      },
      'priority': 'high',
      'data': {'name': 'second', 'id': '2131'}
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Key=AAAA3HHRzWA:APA91bE1L-tlxVg3cMVjbkTQXWrFVcptpIv9NnKN7DYwFmkQJ_MpFrHtW0Vn9xyCxAJ-08j-4rcZw3gmGXxMO0Kpg3XA1b6x2vEQ9z1rJJLSP8RT6Bzq5DIxBfNO4DhlHf-0wo04IMN0'
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifcationHelper.requestNotificatinPermission();
    notifcationHelper.gettokenid().then((value) {
      token = value;
      print(token);
      notifcationHelper.firebasemegs(context);
      notifcationHelper.terminatedandback(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
