import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class DataStoreRepository {
  Stream<SubscriptionEvent<GptMessage>> gptMessageSubscribe(
      {required GptSession session});

  Future<GptSession> gptSessionCreate();

  Future<List<GptSession>> gptSessionFetch();
}

class AmplifyDataStoreRepository implements DataStoreRepository {
  AmplifyDataStoreRepository({required this.dataStore});

  final AmplifyDataStore dataStore;

  @override
  Stream<SubscriptionEvent<GptMessage>> gptMessageSubscribe(
      {required GptSession session}) {
    return dataStore.observe<GptMessage>(
      GptMessage.classType,
      where: GptMessage.GPTSESSION.eq(session),
    );
  }

  @override
  Future<GptSession> gptSessionCreate() async {
    final newSession = GptSession(original: "TEST");
    await dataStore.save(newSession);
    return newSession;
  }

  @override
  Future<List<GptSession>> gptSessionFetch() async {
    return await dataStore.query(
      GptSession.classType,
    );
  }
}
