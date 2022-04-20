import 'dart:convert';

import '../models/command_types.dart';

import './command_types.dart';

class Command {
  ///type represents Command type
  String command;

  ///timestamp of client side
  DateTime timestamp;

  ///data is different depending on the type.
  ///START -> offset (delay),
  ///PAUSE -> seek time,
  ///SEEK -> seek time,
  ///LINK -> youtube video id or link
  dynamic arguments;

  ///timestamp from server.
  //DateTime _serverTimestamp;

  ///ping of client and server.
  int? ping;

  ///a unique token. might use for authentication or something in future
  String? username;

  //String roomId

  Command({
    required this.command,
    required this.timestamp,
    this.arguments,
    this.username,
    this.ping,
  });

  factory Command.fromJson(dynamic json) {
    var type = json['type'];

    var timestamp = DateTime.parse(json['timestamp']);

    var serverTimestamp =
        (json['server-timestamp'] == null || json['server-timestamp'] == "null")
            ? null
            : DateTime.parse(json['server-timestamp']);

    var data;
    try {
      if (type == CommandTypes.LINK)
        data = json['data'];
      else if (type == CommandTypes.START)
        data = Duration(
            seconds: int.parse(json['data'].toString().substring(5, 7)));
      else if (type == CommandTypes.PAUSE)
        data = json['data'];
      else if (type == CommandTypes.SEEK) data = json['data'];
    } catch (e) {
      print('exception in Command -> parsing data');
      print(e);
      data = null;
    }

    var ping = (json['ping'] == null || json['ping'] == "null")
        ? null
        : int.parse(json['ping']);

    var username = (json['client-id'] == null || json['client-id'] == "null")
        ? null
        : json['client-id'];

    var jsonObj = Command(
      command: type,
      timestamp: timestamp,
      arguments: data == null ? null : data,
      ping: ping,
      username: username,
    );

    return jsonObj;
  }

  /*
  void _setServerTimestamp(DateTime serverTimestamp) {
    this._serverTimestamp = serverTimestamp;
  }
  */

  /*
  DateTime getServerTimestamp() {
    return _serverTimestamp;
  }
  */

  @override
  String toString() => {
        "type": command,
        "timestamp": timestamp,
        "data": arguments,
        "username": username,
        "ping": ping,
      }.toString();

  //before sending json obj to python, use this function
  String toPyString() =>
      "{\"type\": \"$command\", \"timestamp\": \"$timestamp\", \"data\": \"$arguments\",  \"username\": \"$username\", \"ping\": \"$ping\"}";

  String fromPyString() => this.toString().replaceAll("'", "\"");
}

class Command1 {
  late String username;
  late DateTime timestamp;
  int? ping;
  late String func;
  String? args;
  late int max_ping;

  Command1({
    required this.username,
    required this.timestamp,
    this.ping,
    required this.func,
    this.args,
    required this.max_ping,
  });

  factory Command1.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));
    String username = jsonMap['username']!;
    DateTime timestamp = DateTime.parse(jsonMap['timestamp']!);
    int ping = int.parse(jsonMap['ping']!);
    String func = jsonMap['func']!;
    String args = jsonMap['args']!;
    int max_ping = int.parse(jsonMap['max_ping']!);

    return Command1(
      username: username,
      timestamp: timestamp,
      ping: ping,
      func: func,
      args: args,
      max_ping: max_ping,
    );
  }

  @override
  String toString() =>
      '{"username": "$username", "timestamp": "$timestamp", "ping": "$ping", "func": "$func", "args": "$args", "max_ping": "$max_ping"}';
}

void main() {
  var a = Command1(
    username: 'a',
    timestamp: DateTime.now(),
    ping: 0,
    func: "ping",
    args: "a b",
    max_ping: 500,
  );
  Command1? fromJsonStr;
  try {
    fromJsonStr = Command1.fromJson(
        "{'username': 'b', 'timestamp': '2022-04-15 14:50:03.147', 'ping': '0', 'func':'ping', 'args': 'c d', 'max_ping': '500'}");
  } catch (e) {
    print(e);
  }
  print(a);
  print(fromJsonStr);
}
