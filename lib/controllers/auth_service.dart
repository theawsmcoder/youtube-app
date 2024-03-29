import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:sample/controllers/chat_connector.dart';
import 'package:sample/controllers/youtube_connector.dart';

class AuthService with ChangeNotifier {
  AuthService._instantiate();
  static final AuthService instance = AuthService._instantiate();

  String username = '';
  String token = '';
  String roomId = '';
  bool isSignedIn = false;
  String baseUrl = 'fastapi-backend-test1.herokuapp.com';

  void updateSignInStatus(bool status) {
    isSignedIn = status;
    YoutubeController.instance.setUsername(username: username);
    ChatController.instance.setUsername(username: username);
    notifyListeners();
  }

  Future<String> httpRequest(String route, String auth_token) async {
    var headers = {'Authorization': auth_token};

    var request = Request('GET', Uri.parse('http://$baseUrl$route'));
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw response.stream.bytesToString();
    }
  }

  Future<String> signUp(String username, password) async {
    var headers = {'Content-Type': 'application/json'};

    var request = Request('POST', Uri.parse('http://$baseUrl/sign_up'));
    request.body =
        json.encode({"username": username, "password_hash": password});
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw response.stream.bytesToString();
    }
  }

  Future<String> signIn(String username, String password) async {
    var request = MultipartRequest('POST', Uri.parse('http://$baseUrl/token'));

    request.fields.addAll({'username': username, 'password': password});
    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      updateSignInStatus(true);
      return await response.stream.bytesToString();
    } else {
      throw response.stream.bytesToString();
    }
  }

  void signOut() {
    username = '';
    token = '';
    YoutubeController.instance.setUsername(username: '');
    ChatController.instance.setUsername(username: '');
    updateSignInStatus(false);
  }
}

void main() async {
  var auth = AuthService.instance;

  var username = "new_user";
  var password = "string";
  var signupresp = await auth.signUp(username, password);
  print(signupresp);
  var resp = await auth.signIn(username, password);
  print(resp);
  var token = 'Bearer ${jsonDecode(resp)['access_token']}';
  var user = await auth.httpRequest('/users/current_user', token);
  print(user);
  //var response = await auth.httpRequest('/youtube-screen', token);
  //print(response);
}
