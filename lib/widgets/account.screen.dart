import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
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
              child:
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                List<KeyVal> items = [
                  KeyVal("Email", state.email),
                  KeyVal("Tokens", state.tokens.toString())
                ];
                return ListView.builder(
                  // Let the ListView know how many items it needs to build.
                  itemCount: items.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].key),
                      subtitle: Text(items[index].val),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class KeyVal {
  final String key;
  final String val;

  KeyVal(this.key, this.val);
}
