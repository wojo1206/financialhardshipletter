import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:simpleiawriter/bloc/api.repository.dart';
import 'package:simpleiawriter/bloc/app.bloc.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';
import 'package:simpleiawriter/bloc/datastore.repository.dart';
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
      body: FormHelper.wrapperBody(
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
                        child: SignInButton(
                          Buttons.Facebook,
                          onPressed: () {
                            _socialSignIn(AuthProvider.facebook).then((value) =>
                                BlocProvider.of<AppBloc>(context)
                                    .add(UserLogIn(value)));
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            _socialSignIn(AuthProvider.google).then((value) =>
                                BlocProvider.of<AppBloc>(context)
                                    .add(UserLogIn(value)));
                          },
                        ),
                      ),
                    ]),
              ),
            ],
          )),
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

      if (res3.data!.items.isEmpty) {
        final res4 = await apiRep.createUser(email: attr1.value);
        safePrint(res4);
      } else {
        throw Exception("User not created.");
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
