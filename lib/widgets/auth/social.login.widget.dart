import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.status == AuthenticationState.authenticated) {
        Navigator.pop(context, true);
        return const SizedBox.shrink();
      } else {
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
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(LogIn(AuthProvider.facebook));
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(LogIn(AuthProvider.google));
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SignInButton(
                        Buttons.Apple,
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(LogIn(AuthProvider.apple));
                        },
                      ),
                    ),
                  ],
                ),
                Text(AppLocalizations.of(context)!.signInExplain)
              ]),
        );
      }
    });
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
