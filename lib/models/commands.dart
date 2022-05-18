import './command.dart';

class Commands {
  static String username = "";
  static int ping = 0;
  static int max_ping = 0;

  static Command1 connect() {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "connect",
      args: "",
      max_ping: max_ping,
    );
  }

  static Command1 disconnect() {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "disconnect",
      args: "",
      max_ping: max_ping,
    );
  }

  static Command1 sendPing() {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "ping",
      args: "",
      max_ping: max_ping,
    );
  }

  static Command1 stop() {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "stop",
      args: "",
      max_ping: max_ping,
    );
  }

  static Command1 link(String args) {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "link",
      args: args,
      max_ping: max_ping,
    );
  }

  static Command1 start(String args) {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "start",
      args: args,
      max_ping: max_ping,
    );
  }

  static Command1 pause(String args) {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "pause",
      args: args,
      max_ping: max_ping,
    );
  }

  static Command1 seekTo(String args) {
    return Command1(
      username: username,
      timestamp: DateTime.now(),
      ping: ping,
      func: "seekTo",
      args: args,
      max_ping: max_ping,
    );
  }
}
