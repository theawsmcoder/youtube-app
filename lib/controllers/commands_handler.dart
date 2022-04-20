import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import './connection_manager.dart';
import '../models/command.dart';
import '../models/commands.dart';
import '../models/command_types.dart';

class CommandsHandler with ChangeNotifier {
  //final ConnectionManager conn;
  bool connected = false;
  bool playing = false;
  int ping = 9999;
  late String link;
  late Duration startOffset;
  late String pauseAt;
  late Timer pingTimer;
  late Command com;
  var stream;
/*
  CommandsHandler(this.conn);

  void connectAndListen() {
    if (!conn.isConnected()) {
      conn.connect();
    }

    stream = conn.getConnectionStream().asBroadcastStream();
    stream.listen((event) {
      // TODO handling commands
      event = event.toString().replaceAll("'", "\"");
      com = Command.fromJson(jsonDecode(event));
      try {
        switch (com.command) {
          case CommandTypes.PING:
            // can do some calculations to make the drastic ping changes less drastic
            ping = DateTime.now().difference(com.timestamp).inMilliseconds;
            Commands.ping = ping;
            break;

          case CommandTypes.CONNECT:
            connect();
            break;

          case CommandTypes.DISCONNECT:
            disconnect();
            break;

          case CommandTypes.LINK:
            loadVideo(com.arguments);
            break;

          case CommandTypes.START:
            // need to recalculate the offset based on ping
            startVideo(com.arguments);
            break;

          case CommandTypes.PAUSE:
            pauseVideo(com.arguments);
            break;

          case CommandTypes.SEEK:
            seekVideoTo(com.arguments);
            break;

          default:
            print(com);
            break;
        }
        sendConnect();
        startPinging();
      } catch (e) {
        print("in switch case while handling command");
        print(e);
      }
    });
  }

  void connect() {
    connected = true;
    Commands.clientId = com.username;
    notifyListeners();
  }

  void loadVideo(String link) {
    this.link = link;
    playing = false;
    notifyListeners();
  }

  void startVideo(Duration startOffset) {
    Timer(startOffset, () {
      playing = true;
      notifyListeners();
    });
  }

  void pauseVideo(String pauseAt) {
    playing = false;
    this.pauseAt = pauseAt;
    notifyListeners();
  }

  void seekVideoTo(String seekTo) {
    // Just seeking to a time and pausing there
    pauseVideo(seekTo);
  }

  void sendConnect() {
    try {
      conn.send(Commands.connect().toPyString());
      notifyListeners();
    } catch (e) {
      print("In commands_handler/sendConnect");
      print(e);
    }
  }

  void startPinging() {
    try {
      pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        conn.send(Commands.sendPing().toPyString());
        notifyListeners();
      });
    } on Exception catch (e) {
      print("In commands_handler/startPinging");
      print(e);
    }
  }

  void sendStart(Duration startOffset) {
    try {
      conn.send(Commands.start(startOffset).toPyString());
      startVideo(startOffset);
    } catch (e) {
      print("In commands_handler/sendStart");
      print(e);
    }
  }

  void sendPause(String pauseAt) {
    try {
      conn.send(Commands.pause(pauseAt).toPyString());
      pauseVideo(pauseAt);
    } catch (e) {
      print("In commands_handler/sendPause");
      print(e);
    }
  }

  void sendSeekTo(String seekTo) {
    try {
      conn.send(Commands.seek(seekTo).toPyString());
      seekVideoTo(seekTo);
    } catch (e) {
      print("In commands_handler/sendSeekTo");
      print(e);
    }
  }

  void sendLink(String link) {
    try {
      conn.send(Commands.link(link).toPyString());
      loadVideo(link);
    } catch (e) {
      print("In commands_handler/sendLink");
      print(e);
    }
  }

  void sendDisconnect() {
    try {
      conn.send(Commands.disconnect().toPyString());
      disconnect();
    } catch (e) {
      print("In commands_handler/sendDisconnect");
      print(e);
    }
  }

  void disconnect() {
    try {
      conn.disconnect();
      connected = false;
      playing = false;
      pingTimer.cancel();
      notifyListeners();
    } on Exception catch (e) {
      print("While disconnectng. In commands_handler/disconnect");
      print(e);
    }
    //stream.close();
    //TODO implement stuff
  }*/
}
