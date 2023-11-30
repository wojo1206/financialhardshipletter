import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

sealed class HistoryEvent {}

class HistoryState {
  const HistoryState({required this.gptSessions});

  final List<GptSession> gptSessions;
}

final class Fetch extends HistoryEvent {
  Fetch();
}

final class SessionDelete extends HistoryEvent {
  SessionDelete(this.gptSession);

  final GptSession gptSession;
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
    on<SessionDelete>((event, emit) async {
      await _dataStoreRep.gptSessionDelete(event.gptSession);
      state.gptSessions.removeWhere((item) => item.id == event.gptSession.id);
      return emit(HistoryState(gptSessions: state.gptSessions));
    });
  }
}
