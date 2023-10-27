import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/models/assistant/medical.assistant.dart';

class AppState {
  Assistant assistant = MedicalAssistant();
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  // void increment() => emit(state + 1);
  // void decrement() => emit(state - 1);
}
