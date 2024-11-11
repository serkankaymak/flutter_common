// simple_event_bus.dart

import 'dart:io';

typedef EventCallback<T> = void Function(T event);

class SimpleEventBus {
  final Map<Type, List<Function>> _listeners = {};

  // Olay dinleyici ekleme
  void on<T>(EventCallback<T> callback) {
    if (_listeners[T] == null) {
      _listeners[T] = [];
    }
    _listeners[T]!.add(callback);
  }

  // Olay dinleyici kaldırma
  void off<T>(EventCallback<T> callback) {
    _listeners[T]?.remove(callback);
  }

  // Olay yayınlama
  void fire<T>(T event) {
    Type eventType = event.runtimeType;
    if (_listeners[eventType] != null) {
      // Dinleyicilerin bir kopyasını alarak olası değişikliklerden etkilenmemesini sağlıyoruz
      for (var callback in List.from(_listeners[eventType]!)) {
        // Callback'i doğru türde çağırıyoruz
        (callback as EventCallback<T>)(event);
      }
    }
  }
}

// events.dart
abstract class IEvent {}

abstract class UserEvent implements IEvent {}

class UserLoggedInEvent extends UserEvent {
  final String username;
  UserLoggedInEvent(this.username);
}

class DataUpdatedEvent extends UserEvent {
  final String data;
  DataUpdatedEvent(this.data);
}

// main.dart

void main() {
  // Event Bus oluşturun
  SimpleEventBus eventBus = SimpleEventBus();

  // Olay dinleyicisi ekleyin
  void onUserLoggedIn(UserLoggedInEvent event) {
    print('Kullanıcı giriş yaptı: ${event.username}');
  }

  void onDataUpdated(DataUpdatedEvent event) {
    print('Veri güncellendi: ${event.data}');
  }

  eventBus.on<UserLoggedInEvent>(onUserLoggedIn);
  eventBus.on<DataUpdatedEvent>(onDataUpdated);

  // Olay yayınlayın
  eventBus.fire(UserLoggedInEvent('Mehmet'));
  eventBus.fire(DataUpdatedEvent('Güncellenmiş veri'));

  // Kullanıcıdan komut alarak olay yayınlayan bir döngü ekleyelim
  print('Kullanıcı etkileşimine hazır!');
  print(
      'Artırmak için "+" yazın, azaltmak için "-" yazın, çıkmak için "q" ya basın.');
  // Event Bus'un sağladığı olayları dinlemek için basit bir sayaç uygulaması ekleyelim
  int counter = 0;

  void onCounterIncrement(IEvent event) {
    if (event is UserLoggedInEvent) {
      counter++;
      print('Sayaç: $counter');
    }
  }

  eventBus.on<UserLoggedInEvent>(onCounterIncrement);

  while (true) {
    stdout.write('Komut: ');
    String? input = stdin.readLineSync();

    if (input == null) continue;

    if (input == '+') {
      eventBus.fire(UserLoggedInEvent('Ahmet'));
    } else if (input == '-') {
      // Örneğin, veri güncelleme olayını tetikleyelim
      eventBus.fire(DataUpdatedEvent('Azaltıldı'));
    } else if (input.toLowerCase() == 'q') {
      print('Uygulamadan çıkılıyor...');
      break;
    } else {
      print('Geçersiz komut. Lütfen "+", "-", veya "q" girin.');
    }
  }
}
