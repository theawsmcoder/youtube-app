import 'package:flutter/cupertino.dart';

import 'connection_manager.dart';

import '.././models/chat_message.dart';

class ChatController with ChangeNotifier {
  late ConnectionManager conn;
  bool isConnected = false;
  List<ChatMessage> chats = [
    ChatMessage(
      username: "Alice",
      message: "Bonjour! Je m'appelle Alice.",
      time: DateTime.utc(1969, 7, 20, 20, 12, 02),
    ),
    ChatMessage(
      username: "Bob",
      message: "Enchante, Alice.",
      time: DateTime.utc(1999, 7, 20, 20, 12, 02),
    ),
    ChatMessage(
      username: "Alice",
      message: "Shut up!",
      time: DateTime.utc(2000, 7, 20, 20, 12, 02),
    ),
  ];
  late String username;

  static final instance = ChatController._instantiate();

  ChatController._instantiate();

  void setUsername({required String username}) {
    this.username = username;
  }

  void changeConnectedStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  void sendMessage(ChatMessage message) {
    if (conn.isConnected()) {
      conn.send(message.toString());
    }
    updateChatList(message);
  }

  void updateChatList(ChatMessage message) {
    // maintains chats max length at 256 messages
    if (chats.length > 256) {
      chats.remove(chats[0]);
    }
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
      ChatMessage message = ChatMessage.fromJson(json);
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
