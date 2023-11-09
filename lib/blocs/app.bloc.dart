import 'package:flutter_bloc/flutter_bloc.dart';

class AppState {
  const AppState({required this.tokens});

  final int tokens;
}

sealed class AppEvent {}

final class SetTokens extends AppEvent {
  final int tokens;

  SetTokens(this.tokens);
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState(tokens: 0)) {
    on<SetTokens>((event, emit) {
      emit(AppState(tokens: event.tokens));
    });
  }
}
