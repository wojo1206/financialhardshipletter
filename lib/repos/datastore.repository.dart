import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class DataStoreRepository {
  Future<User> userCreate({required String email});

  Future<User> userUpdate({required String email});

  Future<GptSession> gptSessionCreate();

  Future<List<GptSession>> gptSessionFetch({required User user});
}

class AmplifyDataStoreRepository implements DataStoreRepository {
  AmplifyDataStoreRepository({required this.dataStore});

  final AmplifyDataStore dataStore;

  @override
  Future<User> userCreate({required String email}) async {
    final user = User(email: email, tokens: 1000);
    try {
      await dataStore.save(user);
    } on DataStoreException catch (e) {
      safePrint(e.message);
    }
    return user;
  }

  @override
  Future<User> userUpdate({required String email}) async {
    User oldUser = (await dataStore.query(
      User.classType,
      where: User.EMAIL.eq(email),
    ))
        .first;

    User newUser = oldUser.copyWith(tokens: 1000);

    try {
      await dataStore.save(newUser);
    } on DataStoreException catch (e) {
      safePrint(e.message);
    }

    return newUser;
  }

  @override
  Future<GptSession> gptSessionCreate() async {
    final newSession = GptSession(original: "TEST");
    try {
      await dataStore.save(newSession);
    } on DataStoreException catch (e) {
      safePrint(e.message);
    }
    return newSession;
  }

  @override
  Future<List<GptSession>> gptSessionFetch({required User user}) async {
    try {
      return await dataStore.query(
        GptSession.classType,
      );
    } on DataStoreException catch (e) {
      safePrint(e.message);
    }
    return [];
  }
}
