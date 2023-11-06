import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleHistory,
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
          context,
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[],
          )),
    );
  }
}
