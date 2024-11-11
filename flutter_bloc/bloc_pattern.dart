// counter_event.dart

import 'dart:async';
import 'dart:io';

abstract class IEvent {}

abstract class CounterEvent implements IEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
// counter_state.dart

class CounterState {
  final int counter;
  CounterState(this.counter);
}
// counter_bloc.dart

class CounterBloc {
  // Singleton instance
  static final CounterBloc _singleton = CounterBloc._internal();

  // Factory constructor returns the singleton instance
  factory CounterBloc() {
    return _singleton;
  }

  // Private named constructor
  CounterBloc._internal() {
    // Dinleyiciyi burada başlatıyoruz
    _eventController.stream.listen(_mapEventToState);
  }

  int _counter = 0;

  // Olayları eklemek için kullanılan Sink
  final StreamController<CounterEvent> _eventController =
      StreamController<CounterEvent>();
  Sink<CounterEvent> get eventSink => _eventController.sink;

  // Durumları dinlemek için kullanılan Stream
  final StreamController<CounterState> _stateController =
      StreamController<CounterState>();
  Stream<CounterState> get stateStream => _stateController.stream;

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else if (event is DecrementEvent) {
      _counter--;
    }
    _stateController.sink.add(CounterState(_counter));
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}

// main.dart

void main() {
  final bloc = CounterBloc();

  // Durum akışını dinle
  bloc.stateStream.listen((state) {
    print('Sayaç Değeri: ${state.counter}');
  });

  print('Sayaç Uygulamasına Hoşgeldiniz!');
  print(
      'Artırmak için "+" yazın, azaltmak için "-" yazın, çıkmak için "q" ya basın.');

  // Kullanıcı girdilerini dinlemek için bir döngü
  while (true) {
    stdout.write('Komut: ');
    String? input = stdin.readLineSync();

    if (input == null) continue;

    if (input == '+') {
      bloc.eventSink.add(IncrementEvent());
    } else if (input == '-') {
      bloc.eventSink.add(DecrementEvent());
    } else if (input.toLowerCase() == 'q') {
      print('Uygulamadan çıkılıyor...');
      bloc.dispose();
      break;
    } else {
      print('Geçersiz komut. Lütfen "+", "-", veya "q" girin.');
    }
  }
}
