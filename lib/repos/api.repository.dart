import 'package:amplify_api/amplify_api.dart';

import 'package:simpleiawriter/graphql/mutations.graphql.dart';

abstract class ApiRepository {
  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String userId,
      required String gptSessionId});
}

class AmplifyAppRepository implements ApiRepository {
  AmplifyAppRepository({required this.api});
  final AmplifyAPI api;

  @override
  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String userId,
      required String gptSessionId}) async {
    return await api
        .query(
          request: GraphQLRequest<String>(
            document: INIT_GPT_QUERY(),
            variables: <String, String>{
              'message': message,
              'userId': userId,
              'gptSessionId': gptSessionId,
            },
          ),
        )
        .response;
  }
}
