import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:simpleiawriter/graphql/queries.graphql.dart';
import 'package:simpleiawriter/graphql/mutations.graphql.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

abstract class AuthRepository {
  Future<bool> isUserSignedIn();

  Future<List<AuthUserAttribute>?> fetchCurrentUserAttributes();

  Future<AuthUser> getCurrentUser();

  Future<SignInResult?> signInWithWebUI();

  Future<CognitoSignInResult?> signIn(
      {required String username, required String password});

  Future<CognitoSignOutResult?> signOut();
}

class AmplifyAuthRepository implements AuthRepository {
  AmplifyAuthRepository({required this.auth});

  final AmplifyAuthCognito auth;

  @override
  Future<List<AuthUserAttribute>?> fetchCurrentUserAttributes() async {
    try {
      final result = await auth.fetchUserAttributes();
      for (final element in result) {
        safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
      }

      return result;
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
    return null;
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    final user = await auth.getCurrentUser();
    return user;
  }

  @override
  Future<bool> isUserSignedIn() async {
    final result = await auth.fetchAuthSession();
    return result.isSignedIn;
  }

  @override
  Future<SignInResult?> signInWithWebUI() async {
    try {
      const pluginOptions = CognitoSignInWithWebUIPluginOptions(
        isPreferPrivateSession: true,
      );

      return await auth.signInWithWebUI(
        provider: AuthProvider.google,
        options: const SignInWithWebUIOptions(pluginOptions: pluginOptions),
      );
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
    return null;
  }

  /// Returns
  ///
  /// ```
  /// {
  ///   "isSignedIn": true,
  ///   "nextStep": {
  ///     "additionalInfo": {},
  ///     "signInStep": "done",
  ///     "missingAttributes": []
  ///   }
  /// }
  /// ```
  @override
  Future<CognitoSignInResult?> signIn(
      {required String username, required String password}) async {
    try {
      return await auth.signIn(
        username: username,
        password: password,
      );
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
    return null;
  }

  @override
  Future<CognitoSignOutResult?> signOut() async {
    try {
      return await auth.signOut();
    } on AuthException catch (e) {
      safePrint('Error signing out: ${e.message}');
    }
    return null;
  }
}
