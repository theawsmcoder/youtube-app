import 'dart:async';

import './models/command.dart';
import './models/commands.dart';
import './controllers/connection_manager.dart';

void main() {
  var username = 'asac';
  ConnectionManager conn =
      ConnectionManager(uri: "ws://127.0.0.1:8000/ws/$username");
  Command1 command;
  conn.connect();
  print(conn.isConnected());
  if (conn.isConnected()) {
    var stream = conn.getConnectionStream().asBroadcastStream();
    stream.listen((event) {
      print(event.toString());
      var received = event.toString();
      try {
        command = Command1.fromJson(received);
        print(command);
      } catch (e) {
        print("not a json");
      }
    });
    Timer(Duration(seconds: 5), () {
      conn.send(Commands.start("1").toString());
    });
  }
}
