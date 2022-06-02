import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '.././controllers/chat_connector.dart';
import '.././controllers/youtube_connector.dart';
import '../models/commands.dart';
import 'chat_widget.dart';
import 'player_layout.dart';
import 'youtube_webview.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({Key? key}) : super(key: key);
  //late YoutubeController youtubeController;

  @override
  Widget build(BuildContext context) {
    final youtubeController =
        Provider.of<YoutubeController>(context, listen: false);
    final chatController = Provider.of<ChatController>(context, listen: false);

    YoutubeWebview youtubeWebview =
        YoutubeWebview(youtubeController: youtubeController);
    youtubeController.setFunction(youtubeWebview.callJavascriptMethod);

    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "youtube",
          textAlign: TextAlign.center,
        ),
        actions: [
          //IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
          Consumer<ChatController>(
            builder: (context, value, child) => ElevatedButton(
              onPressed:
                  youtubeController.isConnected && chatController.isConnected
                      ? () {
                          youtubeController.disconnect();
                          chatController.disconnect();
                        }
                      : () {
                          youtubeController.connectAndListen();
                          chatController.connectAndListen();
                        },
              child: youtubeController.isConnected && chatController.isConnected
                  ? const Text("dis")
                  : const Text("con"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              youtubeWebview,
              Consumer<YoutubeController>(
                builder: (context, value, child) =>
                    youtubeController.playerInfo.title == 'not-ready'
                        ? const SizedBox()
                        : PlayerLayout(),
              ),
            ],
          ),
          Expanded(
            child: ChatWidget(),
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
