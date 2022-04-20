import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:sample/controllers/connection_manager.dart';
import '.././models/command.dart';
import '.././models/commands.dart';

class Stopwatch with ChangeNotifier {
  Duration stopwatch = const Duration(milliseconds: 0);
  bool start = false;
  Timer? timer;
  Timer? pingTimer;
  late ConnectionManager conn;
  int ping = 0;
  bool remoteEvent = false;
  bool isConnected = false;

  Stopwatch() {
    Commands.username = "OnePlus 9";
  }

  void startTimer() {
    start = true;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.start("").toString());
    }
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      stopwatch = Duration(milliseconds: stopwatch.inMilliseconds + 100);
      notifyListeners();
    });
  }

  void pauseTimer() {
    start = false;
    timer?.cancel();
    if (!remoteEvent && isConnected) {
      conn.send(Commands.pause("").toString());
    }
    notifyListeners();
  }

  void resetTimer() {
    start = false;
    timer!.cancel();
    stopwatch = const Duration(milliseconds: 0);
    if (!remoteEvent && isConnected) {
      conn.send(Commands.stop().toString());
    }
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

  void updatePing(int ping) {
    this.ping = ping;
    notifyListeners();
  }

  void changeConnectedStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  //TODO: Add code to handle commands
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

  //TODO: implement commands handler
  void commandsHandler(String json) {
    try {
      var command = Command1.fromJson(json);
      if (command.func == "start") {
        startTimer();
      } else if (command.func == "pause") {
        pauseTimer();
      } else if (command.func == "stop") {
        resetTimer();
      } else if (command.func == "ping") {
        Commands.ping =
            DateTime.now().difference(command.timestamp).inMilliseconds;
        updatePing(Commands.ping);
      }
    } catch (e) {
      print("not a json");
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
