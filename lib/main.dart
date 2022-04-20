import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './controllers/stopwatch.dart';
import './views/stopwatch_screen.dart';
import './counter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<Stopwatch>(
        create: (context) => Stopwatch(),
        child: StopwatchScreen(),
      ),

      /*home: ChangeNotifierProvider<Counter>(
        create: (context) => Counter(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),*/
    );
  }
}

class MyHomePage extends StatelessWidget {
  final title;
  MyHomePage({Key? key, this.title}) : super(key: key);

  void _printMethod() {
    print("printing");
  }

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
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
            Consumer<Counter>(
              builder: (context, counter, child) {
                if (counter.value != 0) _printMethod();
                return Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        tooltip: 'Increment',
        child: Consumer<Counter>(
          builder: (context, counter, child) {
            return (counter.value % 2) == 0
                ? const Icon(Icons.add)
                : const Icon(Icons.ac_unit);
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
