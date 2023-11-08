import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<AuthUserAttribute> authUserAttrs = [];

  @override
  void initState() {
    super.initState();

    _onInit();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleAccount,
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: authUserAttrs.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = authUserAttrs[index];
                  return ListTile(
                    title: Text(item.userAttributeKey.key),
                    subtitle: Text(item.value),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _onInit() async {
    final authRep = RepositoryProvider.of<AuthRepository>(context);
    authUserAttrs = await authRep.fetchCurrentUserAttributes() ?? [];

    setState(() {});
  }
}
