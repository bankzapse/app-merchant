import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  static const String wsUrl = 'ws://localhost:8080/ws';
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _controller = StreamController.broadcast();
  
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  Future<void> connect() async {
    if (_channel != null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null) return;

    try {
      final uri = Uri.parse('$wsUrl?token=$token');
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            _controller.add(data);
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _reconnect();
        },
        onDone: () {
          print('WebSocket Connection Closed');
          _reconnect();
        },
      );
    } catch (e) {
      print('Could not connect to WebSocket: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    _channel = null;
    Future.delayed(const Duration(seconds: 3), () {
      connect();
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}

final socketService = SocketService();
