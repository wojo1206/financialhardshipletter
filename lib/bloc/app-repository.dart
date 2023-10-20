import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/graphql/queries.graphql.dart';
import 'package:simpleiawriter/graphql/mutations.graphql.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class AppRepository {
  Future<GraphQLResponse<User>> createUser({required String email});

  Future<void> initGptQuery(
      {required String prompt, required String gptSessionId});

  Future<GraphQLResponse<PaginatedResult<User>>> usersByEmail(
      {required String email});

  Future<GraphQLResponse<GptSession>> createGptSessionForUser(
      {required User user});

  Stream<GraphQLResponse<GptMessage>> subscribeToChat(
      {required GptSession session});
}

class HttpAppRepository implements AppRepository {
  HttpAppRepository({required this.api});

  final AmplifyAPI api;

  @override
  Future<GraphQLResponse<User>> createUser({required String email}) {
    final user = User(email: email);

    final request = ModelMutations.create(user);
    return api.mutate(request: request).response;
  }

  @override
  Future<void> initGptQuery(
      {required String prompt, required String gptSessionId}) async {
    await api
        .query(
          request: GraphQLRequest<void>(
            document: INIT_GPT_QUERY(),
            variables: <String, String>{
              'prompt': prompt,
              'gptSessionId': gptSessionId
            },
            decodePath: 'String',
          ),
        )
        .response;
  }

  @override
  Future<GraphQLResponse<PaginatedResult<User>>> usersByEmail(
      {required String email}) async {
    return await api
        .query(
          request: GraphQLRequest<PaginatedResult<User>>(
            document: USERS_BY_EMAIL(),
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

  @override
  Stream<GraphQLResponse<GptMessage>> subscribeToChat(
      {required GptSession session}) {
    final subscriptionRequest = ModelSubscriptions.onCreate(
      GptMessage.classType,
      where: GptMessage.ID.eq(uuid),
    );

    return Amplify.API
        .subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    )
        .handleError(
      (Object error) {
        safePrint('Error in subscription stream: $error');
      },
    );
  }
}
