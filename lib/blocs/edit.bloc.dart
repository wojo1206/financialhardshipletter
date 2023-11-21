import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

class EditState {
  const EditState({required this.gptSession});

  final GptSession gptSession;
}

sealed class EditEvent {}

final class Fetch extends EditEvent {
  Fetch();
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
  }
}
