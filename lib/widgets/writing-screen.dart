import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/view-helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/widgets/writer-screen.dart';

import 'form/textarea-form.dart';

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

  Timer? timer1;
  Timer? timer2;

  @override
  void initState() {
    super.initState();

    var cnt1 = 0;
    timer1 = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      cnt1++;
      aiTextController.text += " [WORD${cnt1}]";

      if (cnt1 > 100) {
        _stop(context);
        _scrollDown(context);
      }
    });

    timer2 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _scrollDown(context);
    });

    setState(() {
      _isGenerating = true;
    });
  }

  @override
  void dispose() {
    // Dispose timers first.
    _stop(context);

    aiTextController.dispose();
    aiScrollController.dispose();

    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing', style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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

  Future<void> createTodo() async {
    try {
      final todo = Users(email: 'wszczurek@tbrelectronics.com', tokens: 5000);
      final request = ModelMutations.create(todo);
      final response = await Amplify.API.mutate(request: request).response;

      final createdTodo = response.data;
      if (createdTodo == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdTodo.email}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<WriterPrompt?> writerPrompt() async {
    try {
      final prompt = WriterPrompt(msg: "ECHO");
      final request = ModelQueries.get(todo);
      final response = await Amplify.API.query(request: request).response;
      final todo = response.data;
      if (todo == null) {
        safePrint('errors: ${response.errors}');
      }
      return todo;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  _scrollDown(BuildContext context) {
    aiScrollController.animateTo(aiScrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 100), curve: Curves.linear);
  }

  _stop(BuildContext context) async {
    timer1?.cancel();
    timer2?.cancel();

    setState(() {
      _isGenerating = false;
    });

    await createTodo();
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
