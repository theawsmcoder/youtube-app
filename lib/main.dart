import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sample/controllers/auth_service.dart';
import 'package:sample/controllers/chat_connector.dart';
import 'package:sample/controllers/youtube_connector.dart';
import 'package:sample/controllers/youtube_data_api_service.dart';
import 'package:sample/views/chat_widget.dart';
import 'package:sample/views/wrapper.dart';
import 'package:sample/views/youtube_screen.dart';
import 'package:sample/views/youtube_search_screen.dart';

import './controllers/stopwatch.dart';
import './views/stopwatch_screen.dart';
import './counter.dart';
import './views/youtube_webview_test.dart';
import 'theme_data.dart';

var chatController = ChatController.instance;
var youtubeController = YoutubeController.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var username = "Bob";
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MyTheme.darkTheme,
      routes: {YoutubeScreen.route: (context) => const YoutubeScreen()},
      home: ChangeNotifierProvider<AuthService>(
        create: (context) => AuthService.instance,
        child: Wrapper(),
        /*child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "youtube",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  //IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
                  Consumer<ChatController>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: youtubeController.isConnected &&
                              chatController.isConnected
                          ? () {
                              youtubeController.disconnect();
                              chatController.disconnect();
                            }
                          : () {
                              youtubeController.connectAndListen();
                              chatController.connectAndListen();
                            },
                      child: youtubeController.isConnected &&
                              chatController.isConnected
                          ? const Text("dis")
                          : const Text("con"),
                    ),
                  ),
                ],
              ),
              body: const YoutubeScreen())),*/
        /*Scaffold(
              appBar: AppBar(title: const Text('Search')),
              body: YoutubeSearchScreen()),*/

        /*ChangeNotifierProvider<YoutubeDataApiService>(
        create: (context) => YoutubeDataApiService.instance,
        child: Scaffold(
          appBar: AppBar(title: const Text('Search')),
          body: const YoutubeSearchScreen(),
        ),
      ),*/

        /*home: ChangeNotifierProvider<Counter>(
        create: (context) => Counter(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),*/
      ),
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
