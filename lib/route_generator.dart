import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './views/wrapper.dart';
import './views/home_screen.dart';
import './views/login_and_register_screen.dart';
import './views/youtube_screen.dart';

import './controllers/auth_service.dart';
import '../controllers/chat_connector.dart';
import '../controllers/youtube_connector.dart';
import '../controllers/youtube_data_api_service.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Wrapper.route:
        return MaterialPageRoute(builder: (_) {
          return /*ChangeNotifierProvider<AuthService>(
            create: (context) => AuthService.instance,
            child: */
              Wrapper();
          //);
        });

      case LoginRegisterScreen.route:
        return MaterialPageRoute(builder: (_) => const LoginRegisterScreen());

      case HomeScreen.route:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case YoutubeScreen.route:
        return MaterialPageRoute(builder: (_) => YoutubeScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Route not found'),
        ),
        body: const Center(
          child: Text('Error: Route not found'),
        ),
      ),
    );
  }
}
