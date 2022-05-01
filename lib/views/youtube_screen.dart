import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/views/youtube_webview.dart';
import '.././controllers/youtube_connector.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({Key? key}) : super(key: key);
  //late YoutubeController youtubeController;

  @override
  Widget build(BuildContext context) {
    YoutubeWebview youtubeWebview = YoutubeWebview();
    final youtubeController =
        Provider.of<YoutubeController>(context, listen: false);
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
        height: mediaQuery.size.height,
        child: Column(
          children: [
            youtubeWebview,
            Consumer<YoutubeController>(
              builder: (context, value, child) => ElevatedButton(
                onPressed: youtubeController.start
                    ? () {
                        //print(youtubeController.start);
                        youtubeController.pauseVideo();
                      }
                    : () {
                        //print(youtubeController.start);
                        var delay = (youtubeController.ping / 2 +
                                youtubeController.ping / 2)
                            .toInt();
                        youtubeController.playVideo(delay);
                      },
                child: youtubeController.start
                    ? const Text("pause")
                    : const Text("play"),
              ),
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
