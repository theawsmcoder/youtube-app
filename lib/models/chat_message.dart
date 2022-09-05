import 'dart:convert';

class ChatMessage {
  String username;
  String message;
  DateTime time;
  String func;

  ChatMessage({
    required this.username,
    required this.message,
    required this.time,
    this.func = "chat",
  });

  factory ChatMessage.fromJson(String jsonStr) {
    Map jsonMap = json.decode(jsonStr.replaceAll("'", "\""));
    String username = jsonMap['username'];
    String message = jsonMap['message'];
    String func = jsonMap['func'];
    DateTime time = DateTime.parse(jsonMap['time']);

    return ChatMessage(
      username: username,
      message: message,
      time: time,
      func: func,
    );
  }

  @override
  String toString() =>
      '{"func": "$func", "username": "$username", "message": "$message", "time": "$time"}';
}
