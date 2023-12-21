import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/graphql/mutations.graphql.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class ApiRepository {
  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String settingId,
      required String gptSessionId});

  Stream<GraphQLResponse<GptMessage>> subscribeToChat(
      {required GptSession session});

  Future<GraphQLResponse<PaginatedResult<Setting>>> settingList();

  Future<GraphQLResponse<Setting>> settingCreate();

  Future<GraphQLResponse<Setting>> settingUpdate({required Setting setting});
}

class AmplifyAppRepository implements ApiRepository {
  AmplifyAppRepository({required this.api});
  final AmplifyAPI api;

  @override
  Future<GraphQLResponse<String>> initGptQuery(
      {required String message,
      required String settingId,
      required String gptSessionId}) async {
    return await api
        .query(
          request: GraphQLRequest<String>(
            document: INIT_GPT_QUERY(),
            variables: <String, String>{
              'message': message,
              'settingId': settingId,
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

  @override
  Future<GraphQLResponse<PaginatedResult<Setting>>> settingList() async {
    final request = ModelQueries.list(Setting.classType);
    return await api.query(request: request).response;
  }

  @override
  Future<GraphQLResponse<Setting>> settingCreate() async {
    final setting = Setting(tokens: 1000);
    final request = ModelMutations.create(setting);
    return await api.mutate(request: request).response;
  }

  @override
  Future<GraphQLResponse<Setting>> settingUpdate(
      {required Setting setting}) async {
    final request = ModelMutations.update(setting);
    return await api.mutate(request: request).response;
  }
}
