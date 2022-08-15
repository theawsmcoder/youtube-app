import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Widget buildUsernameField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Username",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 4) {
            return "Username should be at least 4 characters long";
          }
          return null;
        },
        maxLength: 30,
        controller: usernameController,
        onSaved: ((newValue) {
          usernameController.text = newValue!;
        }),
      );

  Widget buildPasswordField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
        ),
        maxLength: 20,
        obscureText: true,
        validator: (value) {
          if (value!.length < 8) {
            return "Password should be at least 8 characters long";
          }
          return null;
        },
        controller: passwordController,
        onSaved: ((newValue) {
          passwordController.text = newValue!;
        }),
      );

  Widget loginButton(BuildContext context) => ElevatedButton(
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        // to hide the keyboard
        FocusScope.of(context).unfocus();

        if (isValid) {
          formKey.currentState!.save();
        }
      },
      child: const Text("Login"));

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Login",
              style: TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            ),
            buildUsernameField(),
            buildPasswordField(),
            loginButton(context),
            const SizedBox(height: 50),
          ]),
    );
  }
}
