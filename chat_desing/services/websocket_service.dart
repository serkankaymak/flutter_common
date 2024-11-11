// services/websocket_service.dart

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message.dart';

typedef MessageCallback = void Function(Message message);

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;
  final List<MessageCallback> _listeners = [];

  WebSocketService({required this.url});

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      final message = Message.fromJson(decoded['message']);
      _notifyListeners(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void sendMessage(Message message) {
    final encoded = jsonEncode({'message': message.toJson()});
    _channel.sink.add(encoded);
  }

  void addListener(MessageCallback callback) {
    _listeners.add(callback);
  }

  void removeListener(MessageCallback callback) {
    _listeners.remove(callback);
  }

  void _notifyListeners(Message message) {
    for (var listener in _listeners) {
      listener(message);
    }
  }

  void dispose() {
    _channel.sink.close();
    _listeners.clear();
  }
}
