import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';
import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/widgets/form/textarea.form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode? focusNodeForUsername;
  late FocusNode? focusNodeForPassword;

  @override
  void initState() {
    super.initState();

    focusNodeForUsername = FocusNode();
    focusNodeForPassword = FocusNode();
  }

  @override
  void dispose() {
    focusNodeForUsername!.dispose();
    focusNodeForPassword!.dispose();

    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Auth - Login', style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.bodyWrapper(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextareaForm(
                        hintText: AppLocalizations.of(context)!.username,
                        helperText: AppLocalizations.of(context)!.username,
                        expands: false,
                        maxLines: 1,
                        focusNode: focusNodeForUsername,
                      ),
                      TextareaForm(
                        hintText: AppLocalizations.of(context)!.password,
                        helperText: AppLocalizations.of(context)!.password,
                        expands: false,
                        maxLines: 1,
                        focusNode: focusNodeForPassword,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forget Password?'),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Sign In'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _socialSignIn(AuthProvider.google);
                          },
                          child: const Text('Sign In with Google'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _socialSignIn(AuthProvider.facebook);
                          },
                          child: const Text('Sign In with Facebook'),
                        ),
                      ),
                    ]),
              ),
            ],
          )),
    );
  }

  Future<void> _socialSignIn(AuthProvider provider) async {
    final authRep = RepositoryProvider.of<AuthRepository>(context);

    final res1 = await authRep.signInWithWebUI(provider: provider);
    safePrint(res1);

    final res2 = await authRep.fetchCurrentUserAttributes();
    safePrint(res2);
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
