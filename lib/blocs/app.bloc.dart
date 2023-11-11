import 'package:flutter_bloc/flutter_bloc.dart';

class AppState {
  const AppState({this.error});

  final String? error;
}

sealed class AppEvent {}

final class SetError extends AppEvent {
  final String error;

  SetError(this.error);
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<SetError>((event, emit) {
      emit(AppState(error: event.error));
    });
  }
}
