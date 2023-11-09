import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.authUserAttributes, required this.status});

  final AuthenticationStatus status;
  final List<AuthUserAttribute> authUserAttributes;
}

sealed class AuthEvent {}

final class SetAuthUserAttributes extends AuthEvent {
  final List<AuthUserAttribute> authUserAttributes;

  SetAuthUserAttributes(this.authUserAttributes);
}

final class SetStatus extends AuthEvent {
  final AuthenticationStatus status;

  SetStatus(this.status);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          const AuthState(
              authUserAttributes: [], status: AuthenticationStatus.unknown),
        ) {
    on<SetAuthUserAttributes>((event, emit) {
      emit(
        AuthState(
            authUserAttributes: event.authUserAttributes, status: state.status),
      );
    });

    on<SetStatus>((event, emit) {
      emit(
        AuthState(
            authUserAttributes: state.authUserAttributes, status: event.status),
      );
    });
  }
}
