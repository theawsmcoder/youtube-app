import 'package:flutter/material.dart';
import '../controllers/auth_service.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);
  static String route = '/login-register-screen';

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late bool isLoginScreen;
  var authService = AuthService.instance;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    isLoginScreen = true;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    super.dispose();
  }

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

  Widget buildConfirmPasswordField() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
        ),
        maxLength: 20,
        obscureText: true,
        validator: (value) {
          if (value != passwordController.text) {
            return "Passwords do not match";
          }
          return null;
        },
        controller: confirmPasswordController,
        onSaved: ((newValue) {
          confirmPasswordController.text = newValue!;
        }),
      );

  Widget loginButton(BuildContext context) => ElevatedButton(
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        // to hide the keyboard
        FocusScope.of(context).unfocus();

        if (isValid) {
          formKey.currentState!.save();
          try {
            authService.signIn(
                usernameController.text, passwordController.text);
            usernameController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid Username or password")));
          }
        }
      },
      child: const Text("Login"));

  Widget registerButton(BuildContext context) => ElevatedButton(
      onPressed: () {
        final isValid = formKey.currentState!.validate();
        // to hide the keyboard
        FocusScope.of(context).unfocus();

        if (isValid) {
          formKey.currentState!.save();
          try {
            print(usernameController.text + passwordController.text);
            authService.signUp(
                usernameController.text, passwordController.text);
            usernameController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User already exists")));
          }
        }
      },
      child: const Text("Register"));

  Widget toggleLoginScreenButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLoginScreen = !isLoginScreen;
          });
        },
        child: isLoginScreen
            ? const Text("Don't have a user? create one")
            : const Text("Already a user? login"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isLoginScreen ? const Text("Login") : const Text("Register")),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          reverse: true,
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
                if (!isLoginScreen) buildConfirmPasswordField(),
                isLoginScreen ? loginButton(context) : registerButton(context),
                toggleLoginScreenButton(),
                const SizedBox(height: 50),
              ]),
        ),
      ),
    );
  }
}
