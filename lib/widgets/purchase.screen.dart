import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/bloc/app.bloc.dart';
import 'package:simpleiawriter/bloc/api.repository.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<AuthUserAttribute> authUserAttrs =
        BlocProvider.of<AppBloc>(context).state.authUserAttr;

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase', style: Theme.of(context).textTheme.bodyMedium),
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
}
