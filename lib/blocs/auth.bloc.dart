import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/api.repository.dart';

import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

enum AuthenticationState { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthenticationState.unknown,
    this.tokens = 0,
    this.settingId = '',
  });

  final AuthenticationState status;
  final int tokens;
  final String settingId;

  AuthState copyWith(
          {AuthenticationState? status, int? tokens, String? settingId}) =>
      AuthState(
          status: status ?? this.status,
          tokens: tokens ?? this.tokens,
          settingId: settingId ?? this.settingId);

  static AuthState empty() => const AuthState(
      status: AuthenticationState.unauthenticated, tokens: 0, settingId: '');
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

  Stream<GraphQLResponse<Setting>>? sub1;

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
    try {
      final res1 = await _authRep.signInWithWebUI(provider: event.provider);

      if (res1.isSignedIn == false) {
        throw Exception("Can't sign in.");
      }

      await _dataStoreRep.clear();
      await _dataStoreRep.start();

      final resp = await _apiRep.settingList();
      final list = resp.data;

      if (list == null) {
        throw Exception("Can't get settings list.");
      }

      Setting? setting;

      if (list.items.isEmpty) {
        var resp = await _apiRep.settingCreate();
        if (resp.data != null) {
          setting = resp.data;
        } else {
          throw Exception("Can't create setting.");
        }
      } else if (list.items.length == 1) {
        setting = list.items.first;
      } else {
        throw Exception("More than one Settings objects.");
      }

      emit(
        AuthState(
          status: AuthenticationState.authenticated,
          tokens: setting!.tokens,
          settingId: setting.id,
        ),
      );
    } catch (ex) {
      addError(ex, StackTrace.current);
      emit(
        AuthState.empty(),
      );
    }
  }
}
