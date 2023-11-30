import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

enum AuthenticationState { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthenticationState.unknown,
    this.email = '',
    this.tokens = 0,
  });

  final AuthenticationState status;
  final int tokens;
  final String email;
}

sealed class AuthEvent {}

final class AuthDataReady extends AuthEvent {
  AuthDataReady();
}

final class LogIn extends AuthEvent {
  final AuthProvider provider;

  LogIn(this.provider);
}

final class LogOut extends AuthEvent {
  LogOut();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRep;
  final DataStoreRepository _dataStoreRep;
  late StreamSubscription<SubscriptionEvent<Setting>> _settingsUpdated;

  AuthBloc({
    required AuthRepository authRep,
    required DataStoreRepository dataStoreRep,
  })  : _authRep = authRep,
        _dataStoreRep = dataStoreRep,
        super(
          const AuthState(status: AuthenticationState.unknown),
        ) {
    on<AuthDataReady>(_onDataStoreReady);
    on<LogOut>(_onLogOut);
    on<LogIn>(_onLogIn);
  }

  Future<void> _onDataStoreReady(
    AuthDataReady event,
    Emitter<AuthState> emit,
  ) async {
    var attr = await _authRep.userAttributeFetchCurrent();
    var email = attr
        .firstWhere((element) => element.userAttributeKey.key == 'email')
        .value;

    Setting? setting = await _dataStoreRep.settingFetch();
    if (setting == null) {
      safePrint('Setting is empty!');
      setting = await _dataStoreRep.settingCreate(email, 1000);
    }

    return emit(AuthState(
      status: state.status,
      email: email,
      tokens: setting.tokens,
    ));
  }

  Future<void> _onLogOut(
    LogOut event,
    Emitter<AuthState> emit,
  ) async {
    await _authRep.signOut();
    await _dataStoreRep.clear();
    await _dataStoreRep.stop();
    return emit(const AuthState(
        status: AuthenticationState.unauthenticated, tokens: 0, email: ''));
  }

  Future<void> _onLogIn(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    final res1 = await _authRep.signInWithWebUI(provider: event.provider);
    if (res1.isSignedIn) {
      await _dataStoreRep.clear();
      await _dataStoreRep.start();
      return emit(const AuthState(
          status: AuthenticationState.authenticated, tokens: 0, email: ''));
    } else {
      return emit(const AuthState(
          status: AuthenticationState.unauthenticated, tokens: 0, email: ''));
    }
  }
}
