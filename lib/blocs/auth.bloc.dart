import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';

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
  final AuthRepository _authRep;
  final ApiRepository _apiRep;

  AuthBloc({
    required AuthRepository authRep,
    required ApiRepository apiRep,
  })  : _authRep = authRep,
        _apiRep = apiRep,
        super(
          AuthState(status: AuthenticationState.unknown, user: User(email: '')),
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
          user: User(email: ''),
        ));
      case AuthenticationState.authenticated:
        try {
          final stopwatch = Stopwatch();
          stopwatch.start();

          final res1 = await _authRep.fetchCurrentUserAttributes();
          safePrint(stopwatch.elapsedMilliseconds / 1000);

          if (res1!.isEmpty) throw Exception("Empty auth user attributes.");

          var attr1 =
              res1.where((e) => e.userAttributeKey.key == 'email').firstOrNull;

          if (attr1 == null) throw Exception("Email attribute non exists.");

          final res3 = await _apiRep.usersByEmail(email: attr1.value);
          safePrint(stopwatch.elapsedMilliseconds / 1000);

          if (res3.hasErrors) throw Exception(res3.errors.join(', '));

          if (res3.data!.items.isEmpty) {
            final res4 = await _apiRep.createUser(email: attr1.value);
            safePrint(stopwatch.elapsedMilliseconds / 1000);

            if (res4.hasErrors) {
              throw Exception(res4.errors.join(', '));
            }
          }

          User user = res3.data!.items.first ?? User(email: '');

          return emit(
              AuthState(status: AuthenticationState.authenticated, user: user));
        } catch (e) {
          safePrint(e.toString());
        }

        return emit(AuthState(
          status: AuthenticationState.unknown,
          user: User(email: ''),
        ));

      case AuthenticationState.unknown:
        return emit(AuthState(
          status: AuthenticationState.unknown,
          user: User(email: ''),
        ));
    }
  }
}
