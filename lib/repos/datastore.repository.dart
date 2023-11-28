import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class DataStoreRepository {
  Stream<SubscriptionEvent<GptMessage>> gptMessageSubscribe(
      {required GptSession session});

  Future<void> clear();

  Future<GptSession> gptSessionCreate();

  Future<GptSession> gptSessionUpdate(GptSession session);

  Future<List<GptSession>> gptSessionFetch();

  Future<Setting> settingCreate(String email, int tokens);

  Future<Setting?> settingFetch();

  Future<Setting> settingUpdate(Setting setting);

  Future<void> start();

  Future<void> stop();
}

class AmplifyDataStoreRepository implements DataStoreRepository {
  AmplifyDataStoreRepository({required this.dataStore});

  final AmplifyDataStore dataStore;

  @override
  Future<void> clear() {
    return dataStore.clear();
  }

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
    final session = GptSession();
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
  Future<Setting?> settingFetch() async {
    List<Setting?> list = await dataStore.query(
      Setting.classType,
    );
    return list.isEmpty ? null : list.first;
  }

  @override
  Future<Setting> settingUpdate(Setting setting) async {
    final newSetting = setting.copyWith(tokens: 1000);
    await dataStore.save(newSetting);
    return newSetting;
  }

  @override
  Future<void> start() {
    return dataStore.start();
  }

  @override
  Future<void> stop() {
    return dataStore.stop();
  }
}
