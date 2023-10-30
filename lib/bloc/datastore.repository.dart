import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class DataStoreRepository {
  Future<User> createUser({required String email});

  Future<List<GptSession>> fetchGptSessions({required User user});
}

class AmplifyDataStoreRepository implements DataStoreRepository {
  AmplifyDataStoreRepository({required this.dataStore});

  final AmplifyDataStore dataStore;

  @override
  Future<List<GptSession>> fetchGptSessions({required User user}) async {
    try {
      return await dataStore.query(
        GptSession.classType,
        where: GptMessage.GPTSESSION.eq(user.id),
      );
    } on DataStoreException catch (e) {
      safePrint(e.message);
    }
    return [];
  }

  @override
  Future<User> createUser({required String email}) async {
    final user = User(email: email, settings: Setting(tokens: 1000));

    try {
      await dataStore.save(user);
    } on DataStoreException catch (e) {
      safePrint(e.message);
    }

    return user;
  }
}
