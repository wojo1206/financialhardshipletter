import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/models/User.dart';

import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';

enum AuthenticationState { unknown, authenticated, unauthenticated }

const String EMPTY = "";

class AuthState {
  const AuthState(
      {this.status = AuthenticationState.unauthenticated,
      this.user = User(email: "")});

  final AuthenticationState status;
  final User user;
}

sealed class AuthEvent {}

final class StatusChanged extends AuthEvent {
  final AuthenticationState status;

  StatusChanged(this.status);
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
          const AuthState(status: AuthenticationState.unknown),
        ) {
    on<StatusChanged>((event, emit) {
      emit(
        AuthState(status: event.status),
      );
    });
  }

  Future<void> _onAuthenticationStatusChanged(
    StatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationState.unauthenticated:
        emit(const AuthState(status: AuthenticationState.unauthenticated));
      case AuthenticationState.authenticated:
        // final user = await _tryGetUser();
        final res1 = await _authRep.fetchCurrentUserAttributes();

        if (res1!.isEmpty) throw Exception("Empty auth user attributes.");

        var attr1 =
            res1.where((e) => e.userAttributeKey.key == 'email').firstOrNull;

        if (attr1 == null) throw Exception("Email attribute non exists.");

        final res3 = await apiRep.usersByEmail(email: attr1.value);
        safePrint(res3);

        if (res3.hasErrors) {
          throw Exception(res3.errors.join(', '));
        } else {
          if (res3.data!.items.isEmpty) {
            final res4 = await apiRep.createUser(email: attr1.value);
            safePrint(res4);

            if (res4.hasErrors) {
              throw Exception(res4.errors.join(', '));
            }
          }
        }

        return emit(user != null
            ? const AuthState(status: AuthenticationState.authenticated)
            : const AuthState(status: AuthenticationState.unauthenticated));
      case AuthenticationState.unknown:
        return emit(const AuthState(status: AuthenticationState.unknown));
    }
  }
}
