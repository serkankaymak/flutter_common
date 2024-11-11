// main.dart

import 'dart:async';
import 'dart:io';
import 'services/api_service.dart';
import 'services/websocket_service.dart';
import 'repositories/chat_repository.dart';
import 'blocs/authentication_bloc.dart';
import 'blocs/authentication_event.dart';
import 'blocs/authentication_state.dart';
import 'blocs/chat_bloc.dart';
import 'blocs/chat_event.dart';
import 'blocs/chat_state.dart';

void main() async {
  // Servisleri ve repository'yi başlatın
  final apiService = ApiService(
      baseUrl: 'http://localhost:3000'); // API URL'nizi buraya ekleyin
  final webSocketService = WebSocketService(
      url: 'ws://localhost:3000/ws'); // WebSocket URL'nizi buraya ekleyin
  final chatRepository = ChatRepository(
    apiService: apiService,
    webSocketService: webSocketService,
  );

  // Authentication BLoC'u başlatın
  final authBloc = AuthenticationBloc(chatRepository: chatRepository);

  // Authentication State'ini dinleyin
  StreamSubscription authSubscription = authBloc.stream.listen((state) async {
    if (state is AuthenticationSuccess) {
      print('Giriş başarılı! Hoşgeldiniz, ${state.user.username}');

      // Chat BLoC'u başlatın
      final chatBloc = ChatBloc(
          chatRepository: chatRepository,
          chatId:
              'default_chat_id'); // Chat ID'yi ihtiyaçlarınıza göre ayarlayın

      // Chat State'ini dinleyin
      StreamSubscription chatSubscription = chatBloc.stream.listen((chatState) {
        if (chatState is ChatLoaded) {
          print('\n---- Mesaj Geçmişi ----');
          for (var msg in chatState.messages) {
            print(
                '[${msg.timestamp.hour}:${msg.timestamp.minute}] ${msg.sender.username}: ${msg.content}');
          }
          print('---- Mesaj Geçmişi Sonu ----\n');
        } else if (chatState is ChatError) {
          print('Chat hatası: ${chatState.error}');
        } else if (chatState is ChatLoaded) {
          // Yeni mesaj geldiğinde
          // Bu kısım zaten ChatLoaded içinde ele alınıyor
        }
      });

      // Sohbet geçmişini yükleyin
      chatBloc.add(LoadChatHistory('default_chat_id'));

      // Kullanıcıdan komut alarak mesaj gönderme döngüsü
      while (true) {
        stdout.write('Mesajınızı yazın (çıkmak için "q"): ');
        String? input = stdin.readLineSync();

        if (input == null) continue;

        if (input.toLowerCase() == 'q') {
          print('Uygulamadan çıkılıyor...');
          await chatSubscription.cancel();
          await chatBloc.close();
          await authSubscription.cancel();
          await authBloc.close();
          chatRepository.dispose();
          exit(0);
        } else {
          // Mesaj gönder
          chatBloc.add(SendMessage(
              chatId: 'default_chat_id',
              content: input,
              userId: state.user.id));
        }
      }
    } else if (state is AuthenticationFailure) {
      print('Giriş başarısız: ${state.error}');
    }
  });

  // Kullanıcıdan giriş bilgilerini alın
  stdout.write('Kullanıcı Adı: ');
  String? username = stdin.readLineSync();

  stdout.write('Şifre: ');
  String? password = stdin.readLineSync();

  if (username != null && password != null) {
    authBloc.add(LoginRequested(username: username, password: password));
  } else {
    print('Kullanıcı adı ve şifre gereklidir.');
    await authSubscription.cancel();
    await authBloc.close();
    exit(1);
  }
}
