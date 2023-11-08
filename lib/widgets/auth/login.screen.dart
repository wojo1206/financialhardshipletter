import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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
        title: Text(AppLocalizations.of(context)!.logIn,
            style: Theme.of(context).textTheme.bodyMedium),
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
                    ]),
              ),
            ],
          )),
    );
  }
}
