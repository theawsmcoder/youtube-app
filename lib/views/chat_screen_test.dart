import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/chat_connector.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  TextEditingController controller = TextEditingController();

  _buildMessage(ChatMessage message) => Container(
        height: 50,
        width: double.infinity,
        child: Column(
          children: [
            Text(message.username),
            Text(message.message),
            Text(message.time.toString()),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text(
        "chat",
        textAlign: TextAlign.center,
      ),
    );

    var mediaQuery = MediaQuery.of(context);

    ChatController chatController =
        Provider.of<ChatController>(context, listen: false);

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: mediaQuery.size.height - 200,
        child: Consumer<ChatController>(
          builder: (context, value, child) => Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: chatController.chats.length,
                  itemBuilder: (context, index) =>
                      _buildMessage(chatController.chats[index]),
                ),
              ),
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
                      },
                      icon: Icon(
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
        ),
      ),
    );
  }
}
