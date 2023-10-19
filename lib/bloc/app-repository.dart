import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/graphql/queries.graphql.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class AppRepository {
  Future<GraphQLResponse<PaginatedResult<User>>> usersByEmail(
      {required String email});

  Future<GraphQLResponse<GptSession>> createGptSessionForUser(
      {required User user});
}

class HttpAppRepository implements AppRepository {
  HttpAppRepository({required this.api});

  final AmplifyAPI api;

  @override
  Future<GraphQLResponse<PaginatedResult<User>>> usersByEmail(
      {required String email}) async {
    return await api
        .query(
          request: GraphQLRequest<PaginatedResult<User>>(
            document: usersByEmail(),
            modelType: const PaginatedModelType(User.classType),
            variables: <String, String>{'email': email},
            decodePath: 'usersByEmail',
          ),
        )
        .response;
  }

  @override
  Future<GraphQLResponse<GptSession>> createGptSessionForUser(
      {required User user}) {
    final session = GptSession(user: user);

    final request = ModelMutations.create(session);
    return api.mutate(request: request).response;
  }
}
