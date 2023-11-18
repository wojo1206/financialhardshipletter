import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

enum AuthenticationState { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthenticationState.unauthenticated,
    required this.user,
  });

  final AuthenticationState status;
  final User user;
}

sealed class AuthEvent {}

final class AuthChanged extends AuthEvent {
  final AuthenticationState status;

  AuthChanged(this.status);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRepository _apiRep;
  final DataStoreRepository _dataStoreRep;

  AuthBloc({
    required ApiRepository apiRep,
    required DataStoreRepository dataStoreRep,
  })  : _apiRep = apiRep,
        _dataStoreRep = dataStoreRep,
        super(
          AuthState(
              status: AuthenticationState.unknown,
              user: User(email: '', tokens: 0)),
        ) {
    on<AuthChanged>(_onAuthenticationStatusChanged);
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationState.unauthenticated:
        return emit(AuthState(
          status: AuthenticationState.unauthenticated,
          user: User(email: '', tokens: 0),
        ));
      case AuthenticationState.authenticated:
        // @TODO Get email
        return emit(AuthState(
          status: AuthenticationState.authenticated,
          user: User(email: 'TODO', tokens: 999),
        ));

      case AuthenticationState.unknown:
        return emit(AuthState(
          status: AuthenticationState.unknown,
          user: User(email: '', tokens: 0),
        ));
    }
  }
}
