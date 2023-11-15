import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';

class VersionInfo extends StatefulWidget {
  const VersionInfo({super.key});

  @override
  State<VersionInfo> createState() => _VersionInfoState();
}

class _VersionInfoState extends State<VersionInfo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return Text(state.packageInfo?.version ?? '');
    });
  }
}
