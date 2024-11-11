// blocs/chat_bloc.dart

import 'package:bloc/bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../repositories/chat_repository.dart';
import '../models/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final String chatId;

  ChatBloc({required this.chatRepository, required this.chatId})
      : super(ChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);

    // WebSocket dinleyicisini ekle
    chatRepository.addWebSocketListener(_onMessageReceived);
    chatRepository.connectWebSocket();
  }

  Future<void> _onLoadChatHistory(
      LoadChatHistory event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.fetchMessageHistory(event.chatId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      final message = await chatRepository.sendMessage(
          event.chatId, event.content, event.userId);
      // Mesajı WebSocket üzerinden de gönderin
      chatRepository.sendWebSocketMessage(message);
      // Lokal olarak eklemek için
      add(ReceiveMessage(message));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final updatedMessages = List<Message>.from((state as ChatLoaded).messages)
        ..add(event.message);
      emit(ChatLoaded(updatedMessages));
    } else {
      emit(ChatLoaded([event.message]));
    }
  }

  void _onMessageReceived(Message message) {
    add(ReceiveMessage(message));
  }

  @override
  Future<void> close() {
    chatRepository.removeWebSocketListener(_onMessageReceived);
    chatRepository.dispose();
    return super.close();
  }
}
