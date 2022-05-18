import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player_layout.dart';
import 'youtube_webview.dart';
import '.././controllers/youtube_connector.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({Key? key}) : super(key: key);
  //late YoutubeController youtubeController;

  @override
  Widget build(BuildContext context) {
    final youtubeController =
        Provider.of<YoutubeController>(context, listen: false);
    YoutubeWebview youtubeWebview =
        YoutubeWebview(youtubeController: youtubeController);
    youtubeController.setFunction(youtubeWebview.callJavascriptMethod);

    var appBar = AppBar(
      title: const Text(
        "youtube",
        textAlign: TextAlign.center,
      ),
    );

    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.width * 9 / 16 + 215 + 48,
        child: Column(
          children: [
            youtubeWebview,
            Stack(
              children: [
                Container(
                  color: Colors.cyan,
                  height: mediaQuery.size.width * 9 / 16,
                  width: mediaQuery.size.width,
                ),
                Consumer<YoutubeController>(
                  builder: (context, value, child) =>
                      youtubeController.playerInfo.title == 'not-ready'
                          ? const SizedBox()
                          : PlayerLayout(),
                ),
              ],
            ),
            Consumer<YoutubeController>(
              builder: (context, value, child) => TextButton(
                onPressed: youtubeController.isConnected
                    ? youtubeController.disconnect
                    : youtubeController.connectAndListen,
                child: youtubeController.isConnected
                    ? const Text("disconnect")
                    : const Text("connect"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
