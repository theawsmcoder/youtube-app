import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'connection_manager.dart';
import '.././models/player_info.dart';
import '.././models/command.dart';
import '.././models/commands.dart';

class YoutubeController with ChangeNotifier {
  bool start = false;
  Timer? pingTimer;
  late ConnectionManager conn;
  int ping = 0;
  int max_ping = 0;
  bool remoteEvent = false;
  bool isConnected = false;
  late Command1 command;
  Function? func;
  late String roomId;

  PlayerInfo playerInfo = PlayerInfo(
    title: 'not-ready',
    currentTime: 0.0,
    duration: 0.0,
    playerState: 0,
  );

  static final YoutubeController instance = YoutubeController._instantiate();

  YoutubeController._instantiate();

  void setUsername({required String username}) {
    Commands.username = username;
  }

  void setRoomId({required String roomId}) {
    this.roomId = roomId;
  }

  void setFunction(Function func) {
    this.func = func;
  }

  //here it will play after max_ping/2 + ping/2 (called the function in stopwtch_screen.dart)
  //meaning it will play after time taken for the message to go to the farthest user
  //the json however will only have max_ping/2 as argument and the receiving user will play after max_ping/2 - their ping (called the function in commandsHandler())
  void playVideo(int delay) {
    start = true;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.start((max_ping / 2).toString()).toString());
    }
    // a function to play
    Timer(Duration(milliseconds: delay), () {
      func!("playVideo()");
    });
    print("playing");
    notifyListeners();
  }

  void pauseVideo() {
    start = false;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.pause('').toString());
    }
    func!("pauseVideo()");
    notifyListeners();
  }

  void seekTo(double seconds) {
    if (!remoteEvent && isConnected) {
      conn.send(Commands.seekTo(seconds.toString()).toString());
    }
    func!("seekTo($seconds)");
    start = false;
    notifyListeners();
  }

  void stopVideo() {
    start = false;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.stop().toString());
    }
    // a function to stop
    func!("stopVideo()");
    notifyListeners();
  }

  void loadVideo(String videoId) {
    start = false;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.loadVideo(videoId).toString());
    }
    func!("loadVideo('$videoId')");
    notifyListeners();
  }

  void startPinging() {
    pingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      conn.send(Commands.sendPing().toString());
      if (!conn.isConnected()) {
        timer.cancel();
      }
    });
  }

  void stopPinging() {
    pingTimer!.cancel();
  }

  double getDuration() {
    return playerInfo.duration;
  }

  String getTitle() {
    return playerInfo.title;
  }

  void updatePing(int ping, int max_ping) {
    this.ping = ping;
    this.max_ping = max_ping;
    notifyListeners();
  }

  void changeConnectedStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  void updatePlayerInfo(PlayerInfo pi) {
    if (pi.duration == 0.0) {
      pi.duration = 999;
    }
    playerInfo = pi;
    notifyListeners();
  }

  void connectAndListen() {
    conn = ConnectionManager(
        uri:
            "ws://fastapi-backend-test1.herokuapp.com/ws/commands/$roomId/${Commands.username}");
    conn.connect();
    if (conn.isConnected()) {
      changeConnectedStatus(true);
      startPinging();
      var stream = conn.getConnectionStream().asBroadcastStream();
      stream.listen((event) {
        remoteEvent = true;
        commandsHandler(event.toString());
      });
    }
  }

  void commandsHandler(String json) {
    try {
      command = Command1.fromJson(json);
      if (command.func == "start") {
        var delay = double.parse(command.args!) - ping / 2;
        delay = delay > 0 ? delay : 0;
        if (!start) {
          playVideo(delay.toInt());
        }
      } else if (command.func == "pause") {
        pauseVideo();
      } else if (command.func == "seekTo") {
        var pauseAt = double.parse(command.args!);
        seekTo(pauseAt);
      } else if (command.func == "stop") {
        stopVideo();
      } else if (command.func == "loadVideo") {
        var videoId = command.args!;
        loadVideo(videoId);
      } else if (command.func == "ping") {
        Commands.ping =
            DateTime.now().difference(command.timestamp).inMilliseconds;
        Commands.max_ping = command.max_ping;
        updatePing(Commands.ping, Commands.max_ping);
      }
    } catch (e) {
      print("not a json");
      print(e);
    } finally {
      remoteEvent = false;
    }
  }

  void disconnect() {
    stopPinging();
    conn.disconnect();
    changeConnectedStatus(false);
  }
}
