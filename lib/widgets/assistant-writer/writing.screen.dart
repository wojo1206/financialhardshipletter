import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/repos/api.repository.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/models/chatgtp.types.dart';

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

  late Timer timer;
  late int elapsed = 0;
  final Stopwatch stopwatch = Stopwatch();

  var cntToken = 0;
  var isGenerating = false;

  List<GptMessage> gptMessages = [];

  StreamSubscription<GraphQLResponse<GptMessage>>? stream1;

  @override
  void initState() {
    super.initState();

    Assistant.getQuestions(context).forEach((element) {
      safePrint('${element.enumQuestion} -> ${element.getValue()}');
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
                  showCursor: isGenerating,
                ),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.tokensUsed(cntToken)),
                  Text(AppLocalizations.of(context)!.timeElapsed(elapsed)),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chevron_right),
                  label: Text(AppLocalizations.of(context)!.next),
                  onPressed: () => {
                    if (isGenerating == false) {_fillTheBlanks(context)}
                  },
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
      aiTextFocusNode.requestFocus();

      stopwatch.start();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          elapsed = stopwatch.elapsed.inSeconds;
        });
      });

      setState(() {
        isGenerating = true;
      });

      final apiRep = RepositoryProvider.of<ApiRepository>(context);
      // final session = apiRep.createGptSessionForUser(user: user)

      stream1 = apiRep.subscribeToChat(session: GptSession(id: 'TODO')).listen(
        (event) {
          GptMessage? msg = event.data;

          if (msg is GptMessage) {
            gptMessages.add(msg);

            final chunk = ChatResponseSSE.fromJson(json.decode(msg.chunk));

            if (chunk.choices is List) {
              final choice = chunk.choices?.first;

              setState(() {
                cntToken += 1;
              });

              if (choice?.finishReason == 'stop') {
                _stop(context);
              }

              _sortText();
              _scrollDown(context);
            }
          }
        },
        onError: (Object e) => safePrint('Error: $e'),
        onDone: () => safePrint('Done'),
      );

      apiRep.initGptQuery(prompt: "", gptSessionId: "TODO");
    } catch (e) {
      safePrint('Error: $e');
    } finally {}
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
      isGenerating = false;
    });

    timer.cancel();
    stopwatch.stop();
  }

  _fillTheBlanks(BuildContext context) {
    _stop(context);

    ViewHelper.promptDialog(context, "TODO");

    RegExp exp = RegExp(r'\[(.*?)\]');
    String str = aiTextController.text;

    Iterable<RegExpMatch> matches = exp.allMatches(str);
    for (final m in matches) {
      print(m[0]);
      str = str.replaceAll(m[0]!, "[TODO]");
    }

    aiTextController.text = str;
  }
}
