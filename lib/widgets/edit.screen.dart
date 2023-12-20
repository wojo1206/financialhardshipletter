import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simpleiawriter/blocs/edit.bloc.dart';

import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';

import 'package:simpleiawriter/widgets/form/textarea.form.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.gptSession});

  final GptSession gptSession;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  RegExp kPlaceholder = RegExp(r'\[(.*?)\]');

  final aiTextController = TextEditingController();
  final aiTextFocusNode = FocusNode();

  get onPressed => null;

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
          actions: [
            IconButton(
                onPressed: () =>
                    {Share.shareWithResult(widget.gptSession.original ?? '')},
                icon: const Icon(Icons.ios_share_sharp))
          ],
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
                    GestureDetector(
                      onTap: () {
                        _fillNext(context);
                      },
                      child: Text(AppLocalizations.of(context)!
                          .warningCount(_countTheBlanks(context))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.close),
                      onPressed: () => ViewHelper.goHome(context),
                      label: Text(AppLocalizations.of(context)!.close),
                    ),
                    ElevatedButton(
                      onPressed: () => ViewHelper.goHome(context),
                      child: Text(AppLocalizations.of(context)!.save),
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

  int _countTheBlanks(BuildContext context) {
    String str = aiTextController.text;
    return kPlaceholder.allMatches(str).length;
  }

  _fillNext(BuildContext context) {
    String str = aiTextController.text;

    Iterable<RegExpMatch> matches = kPlaceholder.allMatches(str);
    if (matches.isNotEmpty) {
      aiTextFocusNode.requestFocus();
      aiTextController.selection = TextSelection(
          baseOffset: matches.first.start, extentOffset: matches.first.end);
    }
  }
}
