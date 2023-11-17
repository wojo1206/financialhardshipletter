import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/graphql/queries.graphql.dart';
import 'package:simpleiawriter/graphql/mutations.graphql.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class ApiRepository {
  Future<GraphQLResponse<GptSession>> createGptSessionForUser(
      {required User user});

  Future<GraphQLResponse<User>> createUser({required String email});

  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String userId,
      required String gptSessionId});

  Future<GraphQLResponse<PaginatedResult<User>>> usersByEmail(
      {required String email});

  Stream<GraphQLResponse<GptMessage>> subscribeToChat(
      {required GptSession session});

  Stream<GraphQLResponse<User>> subscribeToUser({required User user});
}

class AmplifyAppRepository implements ApiRepository {
  AmplifyAppRepository({required this.api});

  final AmplifyAPI api;

  @override
  Future<GraphQLResponse<GptSession>> createGptSessionForUser(
      {required User user}) {
    final session = GptSession(user: user);

    final request = ModelMutations.create(session);
    return api.mutate(request: request).response;
  }

  @override
  Future<GraphQLResponse<User>> createUser({required String email}) {
    final user = User(email: email, tokens: 1000);

    final request = ModelMutations.create(user);
    return api.mutate(request: request).response;
  }

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

  @override
  Stream<GraphQLResponse<User>> subscribeToUser({required User user}) {
    final subscriptionRequest =
        ModelSubscriptions.onUpdate(User.classType, where: User.ID.eq(user.id));

    return api.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    );
  }
}
