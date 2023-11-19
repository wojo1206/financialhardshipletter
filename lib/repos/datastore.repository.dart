import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/models/Setting.dart';

abstract class DataStoreRepository {
  Stream<SubscriptionEvent<GptMessage>> gptMessageSubscribe(
      {required GptSession session});

  Future<GptSession> gptSessionCreate();

  Future<GptSession> gptSessionUpdate(GptSession session);

  Future<List<GptSession>> gptSessionFetch();

  Future<Setting> settingCreate(String email, int tokens);

  Future<Setting?> settingFetch(String email);
}

class AmplifyDataStoreRepository implements DataStoreRepository {
  AmplifyDataStoreRepository({required this.dataStore});

  final AmplifyDataStore dataStore;

  @override
  Stream<SubscriptionEvent<GptMessage>> gptMessageSubscribe(
      {required GptSession session}) {
    return dataStore.observe<GptMessage>(
      GptMessage.classType,
      where: GptMessage.GPTSESSION.eq(session.id),
    );
  }

  @override
  Future<GptSession> gptSessionCreate() async {
    final session = GptSession(original: "TEST");
    await dataStore.save(session);
    return session;
  }

  @override
  Future<GptSession> gptSessionUpdate(GptSession session) async {
    await dataStore.save(session);
    return session;
  }

  @override
  Future<List<GptSession>> gptSessionFetch() {
    return dataStore.query<GptSession>(
      GptSession.classType,
      sortBy: [GptSession.CREATEDAT.descending()],
    );
  }

  @override
  Future<Setting> settingCreate(String email, int tokens) async {
    final setting = Setting(email: email, tokens: tokens);
    await dataStore.save(setting);
    return setting;
  }

  @override
  Future<Setting?> settingFetch(String email) async {
    List<Setting?> list = await dataStore.query(
      Setting.classType,
      where: Setting.EMAIL.eq(email),
    );
    return list.isEmpty ? null : list.first;
  }
}
