import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/models/chatgtp.types.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/widgets/assistant-writer/tokens.widget.dart';

import '../form/textarea.form.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final aiTextFocusNode = FocusNode();
  final aiTextController = TextEditingController();
  final aiScrollController = ScrollController();

  var _isGenerating = false;
  var _cntToken = 0;

  List<GptMessage> gptMessages = [];

  StreamSubscription<GraphQLResponse<GptMessage>>? stream1;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isGenerating = true;
    });

    _startWriting();
  }

  @override
  void dispose() {
    aiTextController.dispose();
    aiScrollController.dispose();
    aiTextFocusNode.dispose();

    if (stream1 != null) stream1?.cancel();

    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Letter - Writing',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ViewHelper.infoText(
                context, AppLocalizations.of(context)!.hintPage4),
            Expanded(
              child: Scrollbar(
                controller: aiScrollController,
                child: TextareaForm(
                  controller: aiTextController,
                  focusNode: aiTextFocusNode,
                  readonly: true,
                  scrollController: aiScrollController,
                  showCursor: _isGenerating,
                ),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Tokens used: $_cntToken'),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chevron_right),
                  label: const Text("Fill the blanks"),
                  onPressed: () => _fillTheBlanks(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _startWriting() async {
    try {
      final appRep = RepositoryProvider.of<ApiRepository>(context);
      final authRep = RepositoryProvider.of<AuthRepository>(context);

      final stopwatch = Stopwatch();
      stopwatch.start();

      aiTextFocusNode.requestFocus();

      final auth1 = await authRep.fetchCurrentUserAttributes();
      if (auth1!.isEmpty) throw Exception("Empty auth user attributes.");
      safePrint(stopwatch.elapsedMilliseconds / 1000);

      var attr1 =
          auth1.where((e) => e.userAttributeKey.key == 'email').firstOrNull;
      if (attr1 == null) throw Exception("No email attribute.");

      final res1 = await appRep.usersByEmail(email: attr1.value);
      safePrint(stopwatch.elapsedMilliseconds / 1000);

      if (res1.data!.items.isEmpty) throw Exception("No user with that email.");
      User? user = res1.data!.items.first;

      if (user != null) {
        final res2 = await appRep.createGptSessionForUser(user: user);
        safePrint(stopwatch.elapsedMilliseconds / 1000);

        final sessionUuid = res2.data!.id;

        stream1 = appRep.subscribeToChat(session: res2.data!).listen(
          (event) {
            GptMessage? msg = event.data;

            if (msg is GptMessage) {
              gptMessages.add(msg);

              final chunk = ChatResponseSSE.fromJson(json.decode(msg.chunk));

              if (chunk.choices is List) {
                final choice = chunk.choices?.first;

                aiTextController.text += choice!.message!.content;

                setState(() {
                  _cntToken += 1;
                });

                if (choice.finishReason == 'stop') {
                  _sortText();
                  _stop(context);
                }

                _scrollDown(context);
              }
            }
          },
          onError: (Object e) => safePrint('Error: $e'),
          onDone: () => safePrint('Done'),
        );

        appRep.initGptQuery(prompt: "", gptSessionId: sessionUuid);
      }
    } on ApiException catch (e) {
      safePrint('ERROR: $e');
    }
  }

  _sortText() {
    gptMessages.sort(
      (a, b) => a.createdAt!.getDateTimeInUtc().microsecondsSinceEpoch <
              b.createdAt!.getDateTimeInUtc().microsecondsSinceEpoch
          ? -1
          : 1,
    );

    aiTextController.text = gptMessages
        .map((e) => ChatResponseSSE.fromJson(json.decode(e.chunk)))
        .map((e) => e.choices!.first)
        .map((e) => e.message!.content)
        .join('');
  }

  _scrollDown(BuildContext context) {
    aiScrollController.animateTo(aiScrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 100), curve: Curves.linear);
  }

  _stop(BuildContext context) async {
    stream1?.cancel();

    setState(() {
      _isGenerating = false;
    });
  }

  _fillTheBlanks(BuildContext context) {
    _stop(context);

    ViewHelper.promptDialog(context, "TEST");

    RegExp exp = RegExp(r'\[(.*?)\]');
    String str = aiTextController.text;

    Iterable<RegExpMatch> matches = exp.allMatches(str);
    for (final m in matches) {
      print(m[0]);
      str = str.replaceAll(m[0]!, "[CHANGED]");
    }

    aiTextController.text = str;
  }
}
