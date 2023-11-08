import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppState extends Equatable {
  int tokens = 0;

  @override
  List<Object> get props => [tokens];
}

sealed class AppEvent {}

final class SetTokens extends AppEvent {
  final int tokens;

  SetTokens(this.tokens);
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState()) {
    on<SetTokens>((event, emit) {
      state.tokens = state.tokens + 1;
      emit(state);
    });
  }
}
