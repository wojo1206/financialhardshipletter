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
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationState.unauthenticated:
        return emit(
            const AuthState(status: AuthenticationState.unauthenticated));
      case AuthenticationState.authenticated:
        var attr = await _authRep.userAttributesFetchCurrent();
        var email = attr
            .firstWhere((element) => element.userAttributeKey.key == 'email')
            .value;

        Setting? setting = await _dataStoreRep.settingFetch(email);
        safePrint(setting);

        setting ??= await _dataStoreRep.settingCreate(email, 1000);
        safePrint(setting);

        return emit(AuthState(
          status: AuthenticationState.authenticated,
          email: email,
          tokens: setting.tokens,
        ));

      case AuthenticationState.unknown:
        return emit(const AuthState(status: AuthenticationState.unknown));
    }
  }
}
