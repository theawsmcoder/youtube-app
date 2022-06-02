import 'package:flutter/material.dart';

class MyTheme {
  static const CustomAquaColor = MaterialColor(0xFF1D8C72, {
    50: Color(0xFF4EC7C3),
    100: Color(0xFF42C2B3),
    200: Color(0xFF47BF85),
    300: Color(0xFF43B59A),
    400: Color(0xFF3DAD93),
    500: Color(0xFF2F8F78),
    600: Color(0xFF1D856C),
    700: Color(0xFF1D6B58),
    800: Color(0xFF10473B),
    900: Color(0xFF08362B),
  });

  static final darkTheme = ThemeData(
    //primaryColor: const Color.fromARGB(255, 31, 194, 115),
    //primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: CustomAquaColor,
      brightness: Brightness.dark,
    ).copyWith(secondary: Colors.tealAccent),
  );
}
