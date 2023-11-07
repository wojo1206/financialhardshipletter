import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/bloc/api.repository.dart';
import 'package:simpleiawriter/bloc/app.bloc.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SignInButton(
                    Buttons.Facebook,
                    onPressed: () async {
                      await _socialSignIn(AuthProvider.facebook).then((value) {
                        if (value) {
                          Navigator.pop(context, true);
                          BlocProvider.of<AppBloc>(context)
                              .add(UserLogIn(value));
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      await _socialSignIn(AuthProvider.google).then((value) {
                        if (value) {
                          Navigator.pop(context, true);
                          BlocProvider.of<AppBloc>(context)
                              .add(UserLogIn(value));
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Text(AppLocalizations.of(context)!.signInExplain)
          ]),
    );
  }

  Future<bool> _socialSignIn(AuthProvider provider) async {
    try {
      final authRep = RepositoryProvider.of<AuthRepository>(context);
      final apiRep = RepositoryProvider.of<ApiRepository>(context);
      // final dataRep = RepositoryProvider.of<DataStoreRepository>(context);

      final res1 = await authRep.signInWithWebUI(provider: provider);
      safePrint(res1);

      final res2 = await authRep.fetchCurrentUserAttributes();
      safePrint(res2);

      if (res2!.isEmpty) throw Exception("Empty auth user attributes.");

      var attr1 =
          res2.where((e) => e.userAttributeKey.key == 'email').firstOrNull;

      if (attr1 == null) throw Exception("Email attribute non exists.");

      final res3 = await apiRep.usersByEmail(email: attr1.value);
      safePrint(res3);

      if (res3.hasErrors) {
        throw Exception(res3.errors.join(', '));
      } else {
        if (res3.data!.items.isEmpty) {
          final res4 = await apiRep.createUser(email: attr1.value);
          safePrint(res4);

          if (res4.hasErrors) {
            throw Exception(res4.errors.join(', '));
          }
        }
      }
    } on Exception catch (e) {
      safePrint(e.toString());
      return false;
    }
    return true;
  }

  Future<void> _handleSignInResult(SignInResult result) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.continueSignInWithMfaSelection:
      // Handle select from MFA methods case
      case AuthSignInStep.continueSignInWithTotpSetup:
      // Handle TOTP setup case
      case AuthSignInStep.confirmSignInWithTotpMfaCode:
      // Handle TOTP MFA case
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
      // Handle SMS MFA case
      case AuthSignInStep.confirmSignInWithNewPassword:
      // Handle new password case
      case AuthSignInStep.confirmSignInWithCustomChallenge:
      // Handle custom challenge case
      case AuthSignInStep.resetPassword:
      // Handle reset password case
      case AuthSignInStep.confirmSignUp:
      // Handle confirm sign up case
      case AuthSignInStep.done:
        safePrint('Sign in is complete');
    }
  }
}
