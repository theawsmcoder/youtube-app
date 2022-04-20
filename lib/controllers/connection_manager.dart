import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionManager {
  late String _uri;
  // var uri = "ws://ws-test01.herokuapp.com/echo";
  late WebSocketChannel? _channel;
  late Stream<dynamic>? _connectionStream;
  bool _connected = false;

  ///uri is the endpoint to connect to
  ConnectionManager({uri = "ws://127.0.0.1:8000/"}) {
    _uri = uri;
  }

  bool isConnected() {
    return _connected;
  }

  bool connect() {
    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(_uri));
      _connectionStream = _channel?.stream;
      _connected = true;
      return _connected;
    } catch (e) {
      _connected = false;
      return _connected;
    }
  }

  bool send(String data) {
    try {
      _channel!.sink.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<dynamic> getConnectionStream() {
    return _connectionStream!;
  }

  void disconnect() {
    _channel!.sink.close();
    _connected = false;
  }
}
