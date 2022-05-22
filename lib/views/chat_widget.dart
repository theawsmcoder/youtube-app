import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_connector.dart';
import '../models/chat_message.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatelessWidget {
  ChatWidget({Key? key}) : super(key: key);
  TextEditingController controller = TextEditingController();
  final dateFormat = DateFormat("HH:mm");

  _buildMessage(ChatMessage message, BuildContext context) {
    final username = Provider.of<ChatController>(context).username;
    return Container(
      alignment:
          message.username == username ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.all(7),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 2,
                  spreadRadius: 2),
            ],
            color: message.username == username
                ? Colors.amber[100]
                : Colors.blue[100]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.username,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(message.message,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16)),
            Text(dateFormat.format(message.time),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    ChatController chatController =
        Provider.of<ChatController>(context, listen: false);

    return Consumer<ChatController>(
      builder: (context, value, child) => Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: chatController.chats
                  .map((chat) => _buildMessage(chat, context) as Widget)
                  .toList(),
            ),
          )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: controller,
                ),
              ),
              IconButton(
                  onPressed: () {
                    var temp = ChatMessage(
                      username: chatController.username,
                      message: controller.text,
                      time: DateTime.now(),
                    );
                    chatController.sendMessage(temp);
                    controller.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                  ))
            ],
          ),
          TextButton(
            onPressed: chatController.isConnected
                ? chatController.disconnect
                : chatController.connectAndListen,
            child: chatController.isConnected
                ? const Text("disconnect")
                : const Text("connect"),
          ),
        ],
      ),
    );
  }

  /*_messageFormatter(String messageContent) {
    int splitLength = 38;
    int i = 0;
    String temp = "";
    while (i < messageContent.length) {
      temp +=
          "${messageContent.substring(i, min(i + splitLength, messageContent.length))}\n";
      i += splitLength;
    }
    return temp.substring(0, temp.length - 1);
  }*/
}
