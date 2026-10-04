import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebSocketService {
  WebSocketChannel? _channel;

  Stream<dynamic>? get stream => _channel?.stream;

  void connect({required String accessToken}) {
    final uri = Uri.parse('ws://localhost:8080/ws/chat?token=$accessToken');

    _channel = WebSocketChannel.connect(uri);
  }

  void sendMessage({ required String receiverId, required String content}) {
    if (_channel == null) {
      throw Exception("WebSocket is not connected");
    }

    final payload = {
      "receiverId": receiverId,
      "content": content,
    };

    _channel!.sink.add(jsonEncode(payload));
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }
}