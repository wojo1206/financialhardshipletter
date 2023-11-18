import 'package:amplify_flutter/amplify_flutter.dart' show safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

class WritingState {
  const WritingState({required this.gptSession});

  final GptSession gptSession;
}

sealed class WriteEvent {}

final class StartNew extends WriteEvent {
  final User user;

  StartNew(this.user);
}

class WritingBloc extends Bloc<WriteEvent, WritingState> {
  final DataStoreRepository _dataStoreRep;

  WritingBloc({
    required DataStoreRepository dataStoreRep,
  })  : _dataStoreRep = dataStoreRep,
        super(WritingState(gptSession: GptSession())) {
    on<StartNew>((event, emit) async {
      final stopwatch = Stopwatch();
      stopwatch.start();

      final session = await _dataStoreRep.gptSessionCreate();
      safePrint(stopwatch.elapsedMilliseconds / 1000);

      return emit(WritingState(gptSession: session));
    });
  }
}
