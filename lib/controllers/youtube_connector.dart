import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:sample/controllers/connection_manager.dart';
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
  late Function? func;

  YoutubeController() {
    Commands.username = "OnePlus Nord";
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
    notifyListeners();
  }

  /*void pauseVideo(int pausedAt) {
    start = false;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.pause(pausedAt.toString()).toString());
    }
    // a function to pause
    notifyListeners();
  }*/

  void pauseVideo() {
    start = false;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.pause('').toString());
    }
    func!("pauseVideo()");
    notifyListeners();
  }

  void stopVideo() {
    start = false;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.stop().toString());
    }
    // a function to stop
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

  void updatePing(int ping, int max_ping) {
    this.ping = ping;
    this.max_ping = max_ping;
    notifyListeners();
  }

  void changeConnectedStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  void connectAndListen() {
    conn = ConnectionManager(
        uri:
            "ws://fastapi-backend-test1.herokuapp.com/ws/${Commands.username}");
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
        if (!start) {
          playVideo(delay.toInt());
        }
      } else if (command.func == "pause") {
        //var pausedAt = Duration(milliseconds: int.parse(command.args!));
        //pauseVideo(pausedAt.inMilliseconds);
        pauseVideo();
      } else if (command.func == "stop") {
        stopVideo();
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
