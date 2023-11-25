import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

enum AuthenticationState { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthenticationState.unauthenticated,
    this.email = '',
    this.tokens = 0,
  });

  final AuthenticationState status;
  final int tokens;
  final String email;
}

sealed class AuthEvent {}

final class AuthChanged extends AuthEvent {
  final AuthenticationState status;

  AuthChanged(this.status);
}

final class AuthDataReady extends AuthEvent {
  AuthDataReady();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRep;
  final DataStoreRepository _dataStoreRep;

  AuthBloc({
    required AuthRepository authRep,
    required DataStoreRepository dataStoreRep,
  })  : _authRep = authRep,
        _dataStoreRep = dataStoreRep,
        super(
          const AuthState(status: AuthenticationState.unknown),
        ) {
    on<AuthChanged>(_onAuthenticationStatusChanged);
    on<AuthDataReady>(_onDataStoreReady);
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationState.unauthenticated:
        await _dataStoreRep.stop();
        return emit(
            const AuthState(status: AuthenticationState.unauthenticated));
      case AuthenticationState.authenticated:
        await _dataStoreRep.start();
        return emit(const AuthState(status: AuthenticationState.authenticated));
      case AuthenticationState.unknown:
        return emit(const AuthState(status: AuthenticationState.unknown));
    }
  }

  Future<void> _onDataStoreReady(
    AuthDataReady event,
    Emitter<AuthState> emit,
  ) async {
    var attr = await _authRep.userAttributeFetchCurrent();
    var email = attr
        .firstWhere((element) => element.userAttributeKey.key == 'email')
        .value;

    Setting? setting = await _dataStoreRep.settingFetch(email);
    setting ??= await _dataStoreRep.settingCreate(email, 1000);

    return emit(AuthState(
      status: state.status,
      email: email,
      tokens: setting.tokens,
    ));
  }
}
