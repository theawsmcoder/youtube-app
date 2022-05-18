import 'package:flutter/material.dart';
import 'package:sample/controllers/youtube_connector.dart';
import 'package:sample/models/player_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:async';
import 'dart:convert';

class YoutubeWebview extends StatelessWidget {
  bool playerReady = false;
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  late YoutubeController youtubeController;

  YoutubeWebview({required this.youtubeController});

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 9 / 16 - 1,
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "about:blank",
        allowsInlineMediaPlayback: true,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        onWebViewCreated: (webViewController) {
          webViewController.loadUrl(
            Uri.dataFromString(
              _player(),
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
    );
  }

  // updates PlayerLayout as per the json received
  void onMessageReceived(JavascriptMessage message) {
    try {
      PlayerInfo pi = PlayerInfo.fromJson(message.message);
      youtubeController.setParams(pi);
    } catch (e) {
      print("Exception in internal Json communication:" + e.toString());
    }
  }

  void callJavascriptMethod(String func) {
    _completer.future.then((webViewController) => webViewController
        .runJavascriptReturningResult('Player.postMessage($func);'));
  }

  String _player() => '''
    <!DOCTYPE html>
    <html>
      <body style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px;">
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
              height: '608',
              width: '1080',
              videoId: 'M7lc1UVf-VE',
              playerVars: {
                'controls': 0,
                'playsinline': 1,
                'enablejsapi': 1,
                'rel': 0,
              },
              
              events: {
                'onReady': onPlayerReady,
                'onStateChange': onPlayerStateChange,
              }
            });
          }

          

          // 4. The API will call this function when the video player is ready.
          // here the Player.postMessage() sends message to app. onMessage() listens and updates state as per the json sent to the app
          function onPlayerReady(event) {
            sendPlayerInfo();
          }

          // 5. The API calls this function when the player's state changes.
          //    The function indicates that when playing a video (state=1),
          //    the player should play for six seconds and then stop.

          function onPlayerStateChange(event) {
            sendPlayerInfo();
          }

          function sendPlayerInfo(){
            var title = player.getVideoData()['title'];
            var duration = player.getDuration();
            var playerState = player.getPlayerState();
            var currentTime = player.getCurrentTime();
            Player.postMessage('{"title":"' + title + '", "duration": "' + duration + '", "playerState": "' + playerState + '", "currentTime": "' + currentTime + '"}');
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

	        function seekTo(seconds){
	          player.seekTo(seconds, true);
	          player.pauseVideo();
	        }

          function getTitle(){
            var title = player.getVideoData()['title'];
            Player.postMessage(title);
          }

          function getTotalDuration(){
            var totalDuration = player.getDuration();
            Player.postMessage(totalDuration);
          }
        </script>
      </body>
    </html>
  ''';
}
