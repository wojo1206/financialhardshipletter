import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';
import 'package:simpleiawriter/widgets/writing.screen.dart';

import '../form/textarea.form.dart';

class WriterAssistantStep3 extends StatefulWidget {
  const WriterAssistantStep3({super.key});

  @override
  State<WriterAssistantStep3> createState() => _WriterAssistantStep3State();
}

class _WriterAssistantStep3State extends State<WriterAssistantStep3> {
  final PageController controller = PageController(
    viewportFraction: 1.0,
  );
  double _sliderVal = 0;
  final StreamController<double> _sliderCtrl = StreamController<double>();

  List<Widget> hardshipReasons = [];
  List<Widget> questionsAndSuggestions = [];

  @override
  void initState() {
    _sliderCtrl.stream
        .debounceTime(const Duration(milliseconds: 200))
        .listen((event) {
      controller
          .animateToPage(
            event.toInt(),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          )
          .then((value) => {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    hardshipReasons = [];
    questionsAndSuggestions = [];

    MedicalAssistant assistant = MedicalAssistant();

    assistant.reasons(context).forEach(
          (e) => hardshipReasons.add(
            FilterChip(
              label: Text(e),
              selected: true,
              onSelected: (value) => {},
            ),
          ),
        );

    assistant.questionsAndSuggestions(context).forEach((e) {
      List<Widget> suggestions = [];

      e.suggestions.forEach((f) {
        suggestions.add(
          FilterChip(
            label: Text(f),
            selected: false,
            onSelected: (value) => {},
          ),
        );
      });

      questionsAndSuggestions.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.question,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: TextareaForm(
                  expands: true,
                  focusNode: e.focusNode,
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  children: suggestions,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return AssistantLayout(
      title: 'Assistant',
      helpText:
          'These ${questionsAndSuggestions.length} questions help to produce a letter specific to you needs.',
      helpUrl: '',
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            clipBehavior: Clip.antiAlias,
            physics: const NeverScrollableScrollPhysics(),
            children: questionsAndSuggestions,
          ),
        ),
        Slider(
          value: _sliderVal,
          min: 0,
          max: (questionsAndSuggestions.length - 1).toDouble(),
          divisions: questionsAndSuggestions.length - 1,
          onChanged: (double value) {
            setState(() {
              _sliderVal = value;
              _sliderCtrl.sink.add(value);
            });
          },
        ),
      ],
      onNext: () {
        if ((_sliderVal.toInt() + 1) < questionsAndSuggestions.length) {
          setState(() {
            _sliderVal += 1.0;
          });
          _sliderCtrl.sink.add(_sliderVal);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WritingScreen()),
          );
        }
      },
    );
  }
}
