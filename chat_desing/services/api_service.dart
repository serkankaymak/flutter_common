// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/message.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Kullanıcı doğrulama
  Future<User> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  // Mesaj geçmişini alma
  Future<List<Message>> fetchMessageHistory(String chatId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body)['messages'];
      return list.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  // Yeni mesaj gönderme
  Future<Message> sendMessage(
      String chatId, String content, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content, 'sender_id': userId}),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
