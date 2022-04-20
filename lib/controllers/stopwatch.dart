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
  int max_ping = 0;
  bool remoteEvent = false;
  bool isConnected = false;
  late Command1 command;

  Stopwatch() {
    Commands.username = "OnePlus 9";
  }

  //here it will play after max_ping/2 + ping/2 (called the function in stopwtch_screen.dart)
  //meaning it will play after time taken for the message to go to the farthest user
  //the json however will only have max_ping/2 as argument and the receiving user will play after max_ping/2 - their ping (called the function in commandsHandler())
  void startTimer(int delay) {
    start = true;
    if (!remoteEvent && isConnected) {
      conn.send(Commands.start((max_ping / 2).toString()).toString());
    }
    Timer(Duration(milliseconds: delay), () {
      //maybe add a condition to check if timer is null or inactive and only then start the timer
      //this will avoid running of multiple timer instances
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        stopwatch = Duration(milliseconds: stopwatch.inMilliseconds + 100);
        notifyListeners();
      });
    });
  }

  void pauseTimer(int pausedAt) {
    start = false;
    timer?.cancel();
    if (!remoteEvent && isConnected) {
      conn.send(Commands.pause(stopwatch.inMilliseconds.toString()).toString());
    }
    stopwatch = Duration(milliseconds: pausedAt);
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

  void updatePing(int ping, int max_ping) {
    this.ping = ping;
    this.max_ping = max_ping;
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
      command = Command1.fromJson(json);
      if (command.func == "start") {
        var delay = double.parse(command.args!) - ping / 2;
        if (!start) {
          startTimer(delay.toInt());
        }
      } else if (command.func == "pause") {
        var pausedAt = Duration(milliseconds: int.parse(command.args!));
        pauseTimer(pausedAt.inMilliseconds);
      } else if (command.func == "stop") {
        resetTimer();
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
