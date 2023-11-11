import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';
import 'package:simpleiawriter/models/User.dart';

import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';

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
                    Buttons.FacebookNew,
                    onPressed: () async {
                      await _socialSignIn(AuthProvider.facebook)
                          .then((value) => _processResult(value));
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      await _socialSignIn(AuthProvider.google)
                          .then((value) => _processResult(value));
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SignInButton(
                    Buttons.Apple,
                    onPressed: () async {
                      await _socialSignIn(AuthProvider.apple)
                          .then((value) => _processResult(value));
                    },
                  ),
                ),
              ],
            ),
            Text(AppLocalizations.of(context)!.signInExplain)
          ]),
    );
  }

  void _processResult(bool value) {
    BlocProvider.of<AuthBloc>(context).add(AuthChanged(value
        ? AuthenticationState.authenticated
        : AuthenticationState.unauthenticated));

    if (value) {
      Navigator.pop(context, true);
    } else {
      // @TODO Show error.
    }
  }

  Future<bool> _socialSignIn(AuthProvider provider) async {
    final authRep = RepositoryProvider.of<AuthRepository>(context);

    final res1 = await authRep.signInWithWebUI(provider: provider);
    return res1.isSignedIn;
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
