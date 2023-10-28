import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account', style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.bodyWrapper(
          context,
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[],
          )),
    );
  }
}
