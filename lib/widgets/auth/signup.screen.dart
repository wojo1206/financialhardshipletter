import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Auth Sign Up', style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[],
        ),
      ),
    );
  }
}
