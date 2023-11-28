import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simpleiawriter/blocs/edit.bloc.dart';

import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

import 'package:simpleiawriter/widgets/form/textarea.form.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.gptSession});

  final GptSession gptSession;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final aiTextController = TextEditingController();
  final aiTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _edit();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBloc, EditState>(builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.titleEdit,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Container(padding: const EdgeInsets.only(top: 24.0)),
                Expanded(
                  child: TextareaForm(
                    controller: aiTextController,
                    focusNode: aiTextFocusNode,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        Share.shareWithResult(widget.gptSession.original ?? '')
                      },
                      child: Text(AppLocalizations.of(context)!.share),
                    ),
                    Container(),
                    ElevatedButton(
                      onPressed: () => ViewHelper.goHome(context),
                      child: Text(AppLocalizations.of(context)!.done),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  _edit() {
    aiTextController.text = widget.gptSession.original ?? '';
  }
}
