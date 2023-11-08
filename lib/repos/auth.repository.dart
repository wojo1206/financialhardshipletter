import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

abstract class AuthRepository {
  Future<bool> isUserSignedIn();

  Future<List<AuthUserAttribute>?> fetchCurrentUserAttributes();

  Future<AuthUser> getCurrentUser();

  Future<CognitoSignInResult> signInWithWebUI({required AuthProvider provider});

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
    final result = await auth.getCurrentUser();
    safePrint('getCurrentUser: $result');
    return result;
  }

  @override
  Future<bool> isUserSignedIn() async {
    final result = await auth.fetchAuthSession();
    safePrint('isUserSignedIn: $result');
    return result.isSignedIn;
  }

  @override
  Future<CognitoSignInResult> signInWithWebUI(
      {required AuthProvider provider}) async {
    const pluginOptions = CognitoSignInWithWebUIPluginOptions(
      isPreferPrivateSession: true,
    );

    final result = await auth.signInWithWebUI(
      provider: provider,
      options: const SignInWithWebUIOptions(pluginOptions: pluginOptions),
    );

    return result;
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
