import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/history.bloc.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/GptSession.dart';
import 'package:simpleiawriter/widgets/edit.screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    BlocProvider.of<HistoryBloc>(context).add(Fetch());

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.titleHistory,
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
                  itemCount: state.gptSessions.length,
                  itemBuilder: (context, index) {
                    GptSession session = state.gptSessions[index];
                    return Dismissible(
                      onDismissed: (DismissDirection direction) {
                        BlocProvider.of<HistoryBloc>(context)
                            .add(SessionDelete(session));
                      },
                      key: Key(session.id),
                      background: Container(
                        color: Colors.red,
                      ),
                      child: ListTile(
                        title: Text(
                          session.original ?? '',
                          maxLines: 1,
                          softWrap: false,
                        ),
                        subtitle: Text(
                          session.createdAt.toString().length > 9
                              ? session.createdAt.toString().substring(0, 10)
                              : '',
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            ViewHelper.routeSlide(
                              EditScreen(
                                gptSession: session,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
