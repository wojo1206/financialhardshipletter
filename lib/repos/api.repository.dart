import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/graphql/mutations.graphql.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class ApiRepository {
  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String email,
      required String gptSessionId});

  Stream<GraphQLResponse<GptMessage>> subscribeToChat(
      {required GptSession session});
}

class AmplifyAppRepository implements ApiRepository {
  AmplifyAppRepository({required this.api});
  final AmplifyAPI api;

  @override
  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String email,
      required String gptSessionId}) async {
    return await api
        .query(
          request: GraphQLRequest<String>(
            document: INIT_GPT_QUERY(),
            variables: <String, String>{
              'message': message,
              'email': email,
              'gptSessionId': gptSessionId,
            },
          ),
        )
        .response;
  }

  @override
  Stream<GraphQLResponse<GptMessage>> subscribeToChat(
      {required GptSession session}) {
    final subscriptionRequest = ModelSubscriptions.onCreate(
      GptMessage.classType,
      where: GptMessage.GPTSESSION.eq(session.id),
    );

    return api.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    );
  }
}
