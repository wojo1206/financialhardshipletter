import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';
import 'package:simpleiawriter/blocs/writing.bloc.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/repos/api.repository.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/models/chatgtp.types.dart';
import 'package:simpleiawriter/widgets/edit.screen.dart';

import 'form/textarea.form.dart';

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

    Assistant.getQuestionGroups(context).forEach((questionGroup) {
      questionGroup.questions.forEach((question) {
        safePrint('${question.enumQuestion} -> ${question.getAllValues()}');
      });
    });

    _startWriting();
  }

  @override
  void dispose() {
    aiTextController.dispose();
    aiScrollController.dispose();
    aiTextFocusNode.dispose();

    timer.cancel();
    stream1?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingBloc, WritingState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.writer,
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.redo),
                    label: Text(AppLocalizations.of(context)!.redo),
                    onPressed: _redo,
                  ),
                  Container(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chevron_right),
                    label: Text(AppLocalizations.of(context)!.next),
                    onPressed: _next,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  _next() {
    if (isGenerating == true) {
      return;
    }
    final blocWriter = BlocProvider.of<WritingBloc>(context);

    GptSession updated =
        blocWriter.state.gptSession.copyWith(original: aiTextController.text);

    blocWriter.add(SessionUpdate(updated));

    Navigator.of(context).push(
      ViewHelper.routeSlide(
        EditScreen(
          gptSessionId: updated.id,
        ),
      ),
    );
  }

  _redo() {
    if (isGenerating == true) {
      return;
    }

    stopwatch.reset();
    setState(() {
      cntToken = 0;
      gptMessages = [];
      aiTextController.text = "";
    });

    _startWriting();
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

      final blocAuth = BlocProvider.of<AuthBloc>(context);
      final blocWriter = BlocProvider.of<WritingBloc>(context);

      final apiRep = RepositoryProvider.of<ApiRepository>(context);

      blocWriter.add(SessionNew());
      safePrint(blocWriter.state.gptSession);

      stream1 =
          apiRep.subscribeToChat(session: blocWriter.state.gptSession).listen(
        (event) {
          GptMessage? msg = event.data;
          if (msg == null) return;

          gptMessages.add(msg);

          final chunk = ChatResponseSSE.fromJson(json.decode(msg.chunk));

          if (chunk.choices is List) {
            ChatChoiceSSE? choice = chunk.choices?.first;

            setState(() {
              cntToken += 1;
            });

            if (choice?.finishReason == 'stop') {
              _stop(context);
            }

            _sortText();
            _scrollDown(context);
          }
        },
        onError: (Object e) => safePrint('Error: $e'),
        onDone: () => safePrint('Done'),
      );

      apiRep.initGptQuery(
        message: const JsonEncoder().convert(Assistant.getPrompt(context)),
        email: blocAuth.state.email,
        gptSessionId: blocWriter.state.gptSession.id,
      );
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
      safePrint(m[0]);
      str = str.replaceAll(m[0]!, "[TODO]");
    }

    aiTextController.text = str;
  }
}
