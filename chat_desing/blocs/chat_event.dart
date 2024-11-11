// blocs/chat_event.dart

import 'package:equatable/equatable.dart';
import '../models/message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChatHistory extends ChatEvent {
  final String chatId;

  LoadChatHistory(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final String userId;

  SendMessage(
      {required this.chatId, required this.content, required this.userId});

  @override
  List<Object?> get props => [chatId, content, userId];
}

class ReceiveMessage extends ChatEvent {
  final Message message;

  ReceiveMessage(this.message);

  @override
  List<Object?> get props => [message];
}
