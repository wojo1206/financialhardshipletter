import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart'
    show GraphQLResponse, safePrint;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/models/chatgtp.types.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

class WritingState {
  const WritingState({required this.gptSession});

  final GptSession gptSession;
}

sealed class WriteEvent {}

final class ChatStart extends WriteEvent {
  ChatStart();
}

final class ChatStop extends WriteEvent {
  ChatStop();
}

final class SessionNew extends WriteEvent {
  SessionNew();
}

final class SessionUpdate extends WriteEvent {
  SessionUpdate(this.gptSession);

  final GptSession gptSession;
}

class WritingBloc extends Bloc<WriteEvent, WritingState> {
  final DataStoreRepository _dataStoreRep;
  final ApiRepository _apiRep;

  StreamSubscription<GraphQLResponse<GptMessage>>? stream1;

  WritingBloc({
    required DataStoreRepository dataStoreRep,
    required ApiRepository apiRep,
  })  : _dataStoreRep = dataStoreRep,
        _apiRep = apiRep,
        super(WritingState(gptSession: GptSession())) {
    on<ChatStart>((event, emit) async {
      List<GptMessage> gptMessages = [];
      await emit.forEach(
        _apiRep.subscribeToChat(session: state.gptSession),
        onData: (event) {
          GptMessage? msg = event.data;
          if (msg == null) return state;

          gptMessages.add(msg);

          final chunk = ChatResponseSSE.fromJson(json.decode(msg.chunk));

          if (chunk.choices is List) {
            ChatChoiceSSE? choice = chunk.choices?.first;

            if (choice?.finishReason == 'stop') {}

            _sortText(gptMessages);
          }

          return WritingState(gptSession: state.gptSession);
        },
      );
    });
    on<ChatStop>((event, emit) async {});
    on<SessionNew>((event, emit) async {
      final session = await _dataStoreRep.gptSessionCreate();
      emit(WritingState(gptSession: session));
    });
    on<SessionUpdate>((event, emit) async {
      final session = await _dataStoreRep.gptSessionUpdate(event.gptSession);
      emit(WritingState(gptSession: session));
    });
  }

  String _sortText(gptMessages) {
    gptMessages.sort(
      (a, b) => a.createdAt!.getDateTimeInUtc().microsecondsSinceEpoch <
              b.createdAt!.getDateTimeInUtc().microsecondsSinceEpoch
          ? -1
          : 1,
    );

    return gptMessages
        .map((e) => ChatResponseSSE.fromJson(json.decode(e.chunk)))
        .map((e) => e.choices!.first)
        .map((e) => e.message!.content)
        .join('');
  }
}
