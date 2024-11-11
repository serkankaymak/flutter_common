// repositories/chat_repository.dart

import '../models/message.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

class ChatRepository {
  final ApiService apiService;
  final WebSocketService webSocketService;

  ChatRepository({
    required this.apiService,
    required this.webSocketService,
  });

  Future<User> authenticate(String username, String password) {
    return apiService.authenticate(username, password);
  }

  Future<List<Message>> fetchMessageHistory(String chatId) {
    return apiService.fetchMessageHistory(chatId);
  }

  Future<Message> sendMessage(String chatId, String content, String userId) {
    return apiService.sendMessage(chatId, content, userId);
  }

  void connectWebSocket() {
    webSocketService.connect();
  }

  void sendWebSocketMessage(Message message) {
    webSocketService.sendMessage(message);
  }

  void addWebSocketListener(void Function(Message message) listener) {
    webSocketService.addListener(listener);
  }

  void removeWebSocketListener(void Function(Message message) listener) {
    webSocketService.removeListener(listener);
  }

  void dispose() {
    webSocketService.dispose();
  }
}
