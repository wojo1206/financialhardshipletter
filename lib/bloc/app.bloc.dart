import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppState {
  int tokens = 0;
  bool isLoggedIn = false;

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode => super.hashCode;
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
      state.tokens = state.tokens + 1;
      emit(state);
    });

    on<UserLogIn>((event, emit) {
      state.isLoggedIn = event.isLoggedIn;
      emit(state);
    });
  }
}
