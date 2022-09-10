import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_connector.dart';
import '../controllers/youtube_connector.dart';
import '../controllers/auth_service.dart';
import '../controllers/youtube_data_api_service.dart';
import '../models/commands.dart';

import 'chat_widget.dart';
import 'player_layout.dart';
import 'youtube_webview.dart';
import 'search_widget.dart';

class YoutubeScreen extends StatelessWidget {
  YoutubeScreen({Key? key}) : super(key: key);
  static const String route = '/youtube-screen';
  //late YoutubeController youtubeController;

  @override
  Widget build(BuildContext context) {
    /*final youtubeController =
        Provider.of<YoutubeController>(context, listen: false);
    final chatController = Provider.of<ChatController>(context, listen: false);

    YoutubeWebview youtubeWebview =
        YoutubeWebview(youtubeController: youtubeController);
    youtubeController.setFunction(youtubeWebview.callJavascriptMethod);*/
    //Provider.of<YoutubeController>(context, listen: false);

    final youtubeController = YoutubeController.instance;
    final chatController = ChatController.instance;
    final auth = AuthService.instance;
    YoutubeWebview youtubeWebview = YoutubeWebview();

    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Watch Party"), actions: [
        IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: const Icon(Icons.logout))
      ]),
      body: Column(
        children: [
          Stack(
            children: [
              youtubeWebview,
              youtubeController.playerInfo.title == 'not-ready'
                  ? const SizedBox()
                  : Consumer<YoutubeController>(
                      builder: (context, value, child) => PlayerLayout(),
                    ),
            ],
          ),
          Expanded(
            child: /*Consumer<ChatController>(
              builder: (context, value, child)=> */
                ChatWidget(),
            //),
          ),
          TextButton(
            onPressed: () => showBottomSheet(
              backgroundColor: Colors.black38,
              context: context,
              builder: (context) => Consumer<YoutubeDataApiService>(
                builder: (context, value, child) => WillPopScope(
                  onWillPop: () async => false,
                  child: SearchWidget(),
                ),
              ),
            ),
            child: const Text('search a video'),
          ),
          /*Consumer<YoutubeController>(
              builder: (context, value, child) => TextButton(
                onPressed: youtubeController.isConnected
                    ? youtubeController.disconnect
                    : youtubeController.connectAndListen,
                child: youtubeController.isConnected
                    ? const Text("disconnect")
                    : const Text("connect"),
              ),
            ),*/
        ],
      ),
    );
  }
}
