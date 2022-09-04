import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/controllers/youtube_data_api_service.dart';

import '../controllers/auth_service.dart';
import '../controllers/chat_connector.dart';
import '../controllers/youtube_connector.dart';
import 'youtube_screen.dart';

import 'dart:math';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static String route = '/home-screen';
  final auth = AuthService.instance;
  final random = Random();
  final roomFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<YoutubeController>(
            create: (context) => YoutubeController.instance,
          ),
          ChangeNotifierProvider<ChatController>(
            create: (context) => ChatController.instance,
          ),
          ChangeNotifierProvider<YoutubeDataApiService>(
            create: (context) => YoutubeDataApiService.instance,
          ),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
              actions: [
                IconButton(
                    onPressed: () {
                      auth.signOut();
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
            body: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setRoomId((random.nextInt(89999) + 10000).toString());
                      Navigator.of(context).pushNamed(YoutubeScreen.route);
                    },
                    child: const Text("Create Room")),
                ElevatedButton(
                    onPressed: () async {
                      await _dialog(context);
                    },
                    child: const Text("Join Room"))
              ],
            )));
  }

  Future _dialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter Room Id"),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: roomFieldController,
              decoration: const InputDecoration(
                labelText: "Room ID",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                var regex = RegExp(r'^[0-9]$');
                if (value!.length != 5) {
                  return "Room ID is 5 digit long";
                }
                if (!regex.hasMatch(value)) {
                  return "Invalid ID";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _submitButton(context);
                },
                child: const Text("SUBMIT"))
          ],
        ),
      );

  void _submitButton(context) {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      setRoomId(roomFieldController.text);
      Navigator.of(context).pop();
      roomFieldController.clear();
      Navigator.of(context).pushNamed(YoutubeScreen.route);
    }
  }

  void setRoomId(String roomId) {
    auth.roomId = roomId;
    ChatController.instance.setRoomId(roomId: auth.roomId);
    YoutubeController.instance.setRoomId(roomId: auth.roomId);
  }
}
