import 'package:flutter_bloc/flutter_bloc.dart';

class AppState {
  late int tokens;
  late bool isLoggedIn;
}

sealed class AppEvent {}

final class SetTokens extends AppEvent {
  final int tokens;

  SetTokens(this.tokens);
}

final class UserLogIn extends AppEvent {
  final bool isLoggedIn;

  UserLogIn(this.isLoggedIn);
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState()) {
    on<SetTokens>((event, emit) {
      state.tokens = event.tokens;
    });

    on<UserLogIn>((event, emit) {
      state.isLoggedIn = event.isLoggedIn;
    });
  }
}
