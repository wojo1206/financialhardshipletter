import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/bloc/app-repository.dart';

import 'package:simpleiawriter/graphql/queries.graphql.dart';
import 'package:simpleiawriter/helpers/view-helper.dart';
import 'package:simpleiawriter/models/ModelProvider.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step2-screen.dart';

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
  var _cntToken = 0;
  var _elapsTime = '';

  final stopwatch = Stopwatch();

  List<GptMessage> gptMessages = [];

  Timer? timer1;
  Timer? timer2;
  StreamSubscription<GraphQLResponse<GptMessage>>? stream1;

  @override
  void initState() {
    super.initState();

    timer2 = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      _scrollDown(context);
    });

    stopwatch.start();
    timer1 = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      _elapsTime = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);
    });

    setState(() {
      _isGenerating = true;
    });

    _test();
  }

  @override
  void dispose() {
    if (timer1!.isActive) timer1?.cancel();
    if (timer2!.isActive) timer2?.cancel();

    stopwatch.reset();

    aiTextController.dispose();
    aiScrollController.dispose();

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
                  Text(_elapsTime.toString()),
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

      final res1 = await appRep.usersByEmail(email: email);
      safePrint(res1);

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

        stream1 = subscribe("TEST").listen(
          (event) {
            setState(() {
              GptMessage? msg = event.data;
              if (msg is GptMessage) {
                aiTextController.text += msg.chunk;
                _cntToken += 1;

                gptMessages.add(msg);
              }
            });
            safePrint('Received: $event');
          },
          onError: (Object e) => safePrint('Error: $e'),
        );

        final res4 = await appRep.initGptQuery(
            prompt: "TEST", gptSessionId: res3.data!.id);

        safePrint(res4);

        gptMessages.sort(
          (a, b) => a.createdAt!.getDateTimeInUtc().microsecondsSinceEpoch <
                  b.createdAt!.getDateTimeInUtc().microsecondsSinceEpoch
              ? -1
              : 1,
        );

        aiTextController.text = gptMessages.map((i) => i.chunk).join('');
      }

      Future.delayed(const Duration(milliseconds: 500), () async {
        await _stop(context);
      });
    } on ApiException catch (e) {
      safePrint('ERROR: $e');
    }
  }

  Stream<GraphQLResponse<GptMessage>> subscribe(String uuid) {
    final subscriptionRequest =
        ModelSubscriptions.onCreate(GptMessage.classType);
    return Amplify.API
        .subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    )
        .handleError(
      (Object error) {
        safePrint('Error in subscription stream: $error');
      },
    );
  }

  _scrollDown(BuildContext context) {
    aiScrollController.animateTo(aiScrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 100), curve: Curves.linear);
  }

  _stop(BuildContext context) async {
    if (timer1!.isActive) timer1?.cancel();
    if (timer2!.isActive) timer2?.cancel();
    if (stream1 != null) stream1?.cancel();

    stopwatch.stop();

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
