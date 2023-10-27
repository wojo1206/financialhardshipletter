import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/bloc/app.repository.dart';

import 'package:simpleiawriter/graphql/queries.graphql.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/models/chatgtp.types.dart';

import 'form/textarea.form.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
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

    _test();
  }

  @override
  void dispose() {
    aiTextController.dispose();
    aiScrollController.dispose();

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
      body: FormHelper.pageWrapper(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Scrollbar(
                controller: aiScrollController,
                child: TextareaForm(
                  controller: aiTextController,
                  scrollController: aiScrollController,
                  readonly: true,
                ),
              ),
            ),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'This screen is read only.You will be able to adjust\nthe text or share in next screens.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_cntToken.toString()),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                    onPressed: _isGenerating ? () => _stop(context) : null,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chevron_right),
                    label: const Text("Fill the blanks"),
                    onPressed: () => _fillTheBlanks(context),
                  ),
                ])
          ],
        ),
      ),
    );
  }

  Future<void> _test() async {
    try {
      String email = 'wszczurek@tbrelectronics.com';

      final appRep = RepositoryProvider.of<AppRepository>(context);
      final stopwatch = Stopwatch();
      stopwatch.start();

      final res1 = await appRep.usersByEmail(email: email);
      safePrint(res1);
      safePrint(stopwatch.elapsedMilliseconds / 1000);

      User? user;
      if (res1.data!.items.isEmpty) {
        final res2 = await appRep.createUser(email: email);
        safePrint(res2);

        user = res2.data;
      } else {
        user = res1.data!.items.first;
      }

      if (user != null) {
        final res3 = await appRep.createGptSessionForUser(user: user);
        safePrint(res3);
        safePrint(stopwatch.elapsedMilliseconds / 1000);

        final sessionUuid = res3.data!.id;

        stream1 = appRep.subscribeToChat(session: res3.data!).listen(
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

        appRep.initGptQuery(prompt: "TEST", gptSessionId: sessionUuid);
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
    if (stream1 != null) stream1?.cancel();

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
