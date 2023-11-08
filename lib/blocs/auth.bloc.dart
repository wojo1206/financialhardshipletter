import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  AuthenticationStatus status = AuthenticationStatus.unknown;

  @override
  List<Object> get props => [status];
}

sealed class AuthEvent {}

final class SetStatus extends AuthEvent {
  final AuthenticationStatus status;

  SetStatus(this.status);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<SetStatus>((event, emit) {
      state.status = event.status;
      emit(state);
    });
  }
}
