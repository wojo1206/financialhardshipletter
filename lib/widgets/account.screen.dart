import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/bloc/app.repository.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();

    _test();
  }

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

  void _test() async {
    final authRep = RepositoryProvider.of<AuthRepository>(context);

    final res1 = await authRep.fetchCurrentUserAttributes();
    safePrint(res1);

    final res2 = await authRep.getCurrentUser();
    safePrint(res2);
  }
}
