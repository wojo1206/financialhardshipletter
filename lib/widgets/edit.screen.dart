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

  final aiScrollController = ScrollController();
  final aiTextController = TextEditingController();
  final aiTextFocusNode = FocusNode();

  var currentPlaceholder = 0;
  var countedPlaceholder = 0;

  @override
  void initState() {
    super.initState();

    aiTextController.text = widget.gptSession.modified ?? '';
    countedPlaceholder = _countTheBlanks(context);
  }

  @override
  void dispose() {
    aiTextController.dispose();
    aiScrollController.dispose();
    aiTextFocusNode.dispose();

    super.dispose();
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
                onPressed: () => {Share.shareWithResult(aiTextController.text)},
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
                  child: Scrollbar(
                    controller: aiScrollController,
                    child: TextareaForm(
                      controller: aiTextController,
                      focusNode: aiTextFocusNode,
                      scrollController: aiScrollController,
                      onChanged: _onTextChanged,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.yellow.shade400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!
                          .warningCount(countedPlaceholder)),
                      ElevatedButton(
                        onPressed: () => _fillNext(context),
                        child: Text(AppLocalizations.of(context)!.next),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.close),
                      onPressed: () => _close(context),
                      label: Text(AppLocalizations.of(context)!.close),
                    ),
                    ElevatedButton(
                      onPressed: () => _save(context),
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

  _close(BuildContext context) {
    ViewHelper.goHome(context);
  }

  _save(BuildContext context) {
    final newSession =
        widget.gptSession.copyWith(modified: aiTextController.text);
    BlocProvider.of<EditBloc>(context).add(SessionUpdate(newSession));

    _close(context);
  }

  int _countTheBlanks(BuildContext context) {
    String str = aiTextController.text;
    return kPlaceholder.allMatches(str).length;
  }

  _fillNext(BuildContext context) {
    String str = aiTextController.text;

    Iterable<RegExpMatch> matches = kPlaceholder.allMatches(str);
    if (currentPlaceholder >= matches.length) currentPlaceholder = 0;

    if (matches.isNotEmpty) {
      aiTextFocusNode.requestFocus();
      aiTextController.selection = TextSelection(
          baseOffset: matches.elementAt(currentPlaceholder).start,
          extentOffset: matches.elementAt(currentPlaceholder).end);

      aiScrollController.animateTo(
          matches.elementAt(currentPlaceholder).start.toDouble(),
          duration: const Duration(microseconds: 100),
          curve: Curves.linear);
    }

    currentPlaceholder++;
  }

  _onTextChanged(String str) {
    setState(() {
      countedPlaceholder = kPlaceholder.allMatches(str).length;
    });
  }
}
