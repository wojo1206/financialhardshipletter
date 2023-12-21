import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

class EditState {
  const EditState({required this.gptSession});

  final GptSession gptSession;
}

sealed class EditEvent {}

final class Fetch extends EditEvent {
  Fetch();
}

final class SessionUpdate extends EditEvent {
  SessionUpdate(this.gptSession);

  final GptSession gptSession;
}

class EditBloc extends Bloc<EditEvent, EditState> {
  final DataStoreRepository _dataStoreRep;

  EditBloc({
    required DataStoreRepository dataStoreRep,
  })  : _dataStoreRep = dataStoreRep,
        super(EditState(gptSession: GptSession())) {
    on<Fetch>((event, emit) async {
      final session = await _dataStoreRep.gptSessionCreate();
      return emit(EditState(gptSession: session));
    });

    on<SessionUpdate>((event, emit) async {
      final session = await _dataStoreRep.gptSessionUpdate(event.gptSession);
      return emit(EditState(gptSession: session));
    });
  }
}
