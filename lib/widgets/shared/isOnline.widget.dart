import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';

class IsOnline extends StatefulWidget {
  const IsOnline({super.key});

  @override
  State<IsOnline> createState() => _IsOnlineState();
}

class _IsOnlineState extends State<IsOnline> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () => {BlocProvider.of<AppBloc>(context).add(SyncRefresh())},
      );
    });
  }
}
