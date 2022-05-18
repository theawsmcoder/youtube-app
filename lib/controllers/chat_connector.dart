import 'package:flutter/cupertino.dart';

import 'connection_manager.dart';

import '.././models/chat_message.dart';

class ChatController with ChangeNotifier {
  late ConnectionManager conn;
  bool isConnected = false;
  late ChatMessage message;
  List<ChatMessage> chats = [];
  final username = "OnePlus Nord";

  void changeConnectedStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  void sendMessage(ChatMessage message) {
    conn.send(message.toString());
    updateChatList(message);
  }

  void updateChatList(ChatMessage message) {
    chats.add(message);
    notifyListeners();
  }

  void connectAndListen() {
    conn = ConnectionManager(
        uri: "ws://fastapi-backend-test2.herokuapp.com/ws/chat/$username");
    conn.connect();
    if (conn.isConnected()) {
      changeConnectedStatus(true);
      var stream = conn.getConnectionStream().asBroadcastStream();
      stream.listen((event) {
        commandsHandler(event.toString());
      });
    }
  }

  void commandsHandler(String json) {
    try {
      message = ChatMessage.fromJson(json);
      if (message.func == 'chat') {
        updateChatList(message);
      }
    } catch (e) {
      print("not a json");
      print(e);
    }
  }

  void disconnect() {
    conn.disconnect();
    changeConnectedStatus(false);
  }
}
