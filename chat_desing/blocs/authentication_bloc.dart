// blocs/authentication_bloc.dart

import 'package:bloc/bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import '../repositories/chat_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ChatRepository chatRepository;

  AuthenticationBloc({required this.chatRepository})
      : super(AuthenticationInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final user =
          await chatRepository.authenticate(event.username, event.password);
      emit(AuthenticationSuccess(user));
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
  }
}
