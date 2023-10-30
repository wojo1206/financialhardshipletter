import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

class AppState {
  Assistant? assistant;
  List<AuthUserAttribute> authUserAttr = [];
  List<GptSession> gptSessions = [];
}

sealed class AppEvent {}

final class NewLetter extends AppEvent {
  final Assistant assistant;

  NewLetter(this.assistant);
}

final class UserLogIn extends AppEvent {
  final List<AuthUserAttribute> authUserAttr;

  UserLogIn(this.authUserAttr);
}

final class GetGptSessions extends AppEvent {
  final List<GptSession> authUserAttr;

  GetGptSessions(this.authUserAttr);
}

final class UserLogOut extends AppEvent {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState()) {
    on<NewLetter>((event, emit) {
      state.assistant = event.assistant;
    });

    on<UserLogIn>((event, emit) {
      state.authUserAttr = event.authUserAttr;
    });

    on<UserLogOut>((event, emit) {});
  }
}
