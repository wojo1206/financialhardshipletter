import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/bloc/datastore.repository.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Expanded(
            //   child: ListView.builder(
            //     // Let the ListView know how many items it needs to build.
            //     itemCount: authUserAttrs.length,
            //     // Provide a builder function. This is where the magic happens.
            //     // Convert each item into a widget based on the type of item it is.
            //     itemBuilder: (context, index) {
            //       final item = authUserAttrs[index];

            //       return ListTile(
            //         title: Text(item.userAttributeKey.key),
            //         subtitle: Text(item.value),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  _test() {
    // final appRep = RepositoryProvider.of<DataStoreRepository>(context)
    //     .fetchGptSessions(user: user);
  }
}
