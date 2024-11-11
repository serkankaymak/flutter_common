// models/message.dart

import 'package:equatable/equatable.dart';
import 'user.dart';

class Message extends Equatable {
  final String id;
  final User sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, sender, content, timestamp];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: User.fromJson(json['sender']),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': {
        'id': sender.id,
        'username': sender.username,
      },
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
