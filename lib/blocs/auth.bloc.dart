import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/repos/api.repository.dart';

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

  AuthState copyWith(
          {AuthenticationState? status, String? email, int? tokens}) =>
      AuthState(
          status: status ?? this.status,
          email: email ?? this.email,
          tokens: tokens ?? this.tokens);

  static AuthState empty() => const AuthState(
      status: AuthenticationState.unauthenticated, tokens: 0, email: '');
}

sealed class AuthEvent {}

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
  final ApiRepository _apiRep;

  AuthBloc({
    required AuthRepository authRep,
    required DataStoreRepository dataStoreRep,
    required ApiRepository apiRep,
  })  : _authRep = authRep,
        _dataStoreRep = dataStoreRep,
        _apiRep = apiRep,
        super(
          const AuthState(status: AuthenticationState.unknown),
        ) {
    on<LogOut>(_onLogOut);
    on<LogIn>(_onLogIn);
  }

  Future<void> _onLogOut(
    LogOut event,
    Emitter<AuthState> emit,
  ) async {
    await _authRep.signOut();
    await _dataStoreRep.clear();
    await _dataStoreRep.stop();
    return emit(AuthState.empty());
  }

  Future<void> _onLogIn(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    final res1 = await _authRep.signInWithWebUI(provider: event.provider);
    if (res1.isSignedIn) {
      await _dataStoreRep.clear();
      await _dataStoreRep.start();

      /**
       * Get email
       */
      var attr = await _authRep.userAttributeFetchCurrent();
      var email = attr
          .firstWhere((element) => element.userAttributeKey.key == 'email')
          .value;

      /**
       * Crucial. Read or create setting object.
       */
      var resp = await _apiRep.settingByEmail(email: email);
      int tokens = 0;
      if (resp.data!.items.isEmpty) {
        safePrint('Setting is empty!');
        var resp = await _apiRep.settingCreate(email: email);
        tokens = resp.data!.tokens;
      } else if (resp.data!.items.length == 1) {
        tokens = resp.data!.items.first!.tokens;
      } else {
        safePrint('More than one Settings objects!');
      }

      return emit(
        AuthState(
          status: AuthenticationState.authenticated,
          tokens: tokens,
          email: email,
        ),
      );
    } else {
      return emit(
        AuthState.empty(),
      );
    }
  }
}
