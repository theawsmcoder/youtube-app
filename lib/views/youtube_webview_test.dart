import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:async';
import 'dart:convert';

class YoutubeWebviewTest extends StatelessWidget {
  late bool playerReady;
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width * 16 / 9;
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 9 / 16,
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: "about:blank",
                allowsInlineMediaPlayback: true,
                initialMediaPlaybackPolicy:
                    AutoMediaPlaybackPolicy.always_allow,
                onWebViewCreated: (webViewController) {
                  webViewController.loadUrl(
                    Uri.dataFromString(
                      _player(
                        height: width,
                        width: height,
                      ),
                      encoding: Encoding.getByName("utf-8"),
                      mimeType: "text/html",
                    ).toString(),
                  );
                  _completer.complete(webViewController);
                },
                onPageFinished: (url) {
                  playerReady = true;
                },
                javascriptChannels: <JavascriptChannel>{
                  JavascriptChannel(
                      name: 'Player', onMessageReceived: onMessageReceived)
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    callJavascriptMethod('playVideo()');
                  },
                  child: const Text('play'),
                ),
                ElevatedButton(
                  onPressed: () {
                    callJavascriptMethod('pauseVideo()');
                  },
                  child: const Text('pause'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onMessageReceived(JavascriptMessage message) {}

  void callJavascriptMethod(String func) {
    _completer.future.then((webViewController) => webViewController
        .runJavascriptReturningResult('Player.postMessage($func);'));
  }

  String _player({double? height, double? width}) => '''
    <!DOCTYPE html>
    <html>
      <body>
        <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
        <div id="player"></div>

        <script>
          // 2. This code loads the IFrame Player API code asynchronously.
          var tag = document.createElement('script');

          tag.src = "https://www.youtube.com/iframe_api";
          var firstScriptTag = document.getElementsByTagName('script')[0];
          firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

          // 3. This function creates an <iframe> (and YouTube player)
          //    after the API code downloads.
          var player;
          function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
              height: '$height',
              width: '$width',
              videoId: 'M7lc1UVf-VE',
              playerVars: {
                'controls': 0,
                'playsinline': 1,
                'enablejsapi': 1,
                'rel': 0,
              },
              
              events: {
                'onReady': onPlayerReady,
                //'onStateChange': onPlayerStateChange,
              }
            });
          }

          

          // 4. The API will call this function when the video player is ready.
          function onPlayerReady(event) {
            event.target.playVideo();
            //player.addEventListener('onStateChange', onPlayerStateChange);
          }

          // 5. The API calls this function when the player's state changes.
          //    The function indicates that when playing a video (state=1),
          //    the player should play for six seconds and then stop.
          var done = false;
          function onPlayerStateChange(event) {
            /*if (event.data == YT.PlayerState.PLAYING && !done) {
              setTimeout(stopVideo, 6000);
              done = true;
            }*/
            //just testing 
            if(event.data == YT.PlayerState.PAUSED){
                player.loadVideoById('bHQqvYy5KYo');
                done = true;
            } 

          }
          
          function pauseVideo(){
            player.pauseVideo();
          }

          function playVideo(){
            player.playVideo();
          }

          function stopVideo(){
            player.stopVideo();
          } 
        </script>
      </body>
    </html>
  ''';
}
