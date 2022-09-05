import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../controllers/auth_service.dart';
import '../views/home_screen.dart';
import '../views/login_and_register_screen.dart';
import '../controllers/youtube_connector.dart';
import '../controllers/chat_connector.dart';
import '../controllers/youtube_data_api_service.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);
  final auth = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthService>(context);
    return auth.isSignedIn ? HomeScreen() : const LoginRegisterScreen();
  }
}
