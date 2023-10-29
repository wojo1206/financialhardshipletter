import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/models/assistant/medical.assistant.dart';

class AppState {
  Assistant assistant = MedicalAssistant();
  AuthUser? user;
}

sealed class AppEvent {}

final class UserLogIn extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState()) {
    on<UserLogIn>((event, emit) {
      // handle incoming `CounterIncrementPressed` event
    });
  }
}
