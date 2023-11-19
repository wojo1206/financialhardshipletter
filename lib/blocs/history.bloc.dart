import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

class HistoryState {
  const HistoryState({required this.gptSessions});

  final List<GptSession> gptSessions;
}

sealed class HistoryEvent {}

final class Fetch extends HistoryEvent {
  Fetch();
}

final class SessionUpdate extends HistoryEvent {
  SessionUpdate(this.gptSession);

  final GptSession gptSession;
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DataStoreRepository _dataStoreRep;

  HistoryBloc({
    required DataStoreRepository dataStoreRep,
  })  : _dataStoreRep = dataStoreRep,
        super(const HistoryState(gptSessions: [])) {
    on<Fetch>((event, emit) async {
      final sessions = await _dataStoreRep.gptSessionFetch();
      return emit(HistoryState(gptSessions: sessions));
    });
  }
}
