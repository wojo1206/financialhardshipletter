import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';
import 'package:simpleiawriter/widgets/assistant-writer/writing.screen.dart';

import '../form/textarea.form.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final PageController ctrlPage = PageController(
    viewportFraction: 1.0,
  );
  double _sliderVal = 0;
  final StreamController<double> ctrlSlider = StreamController<double>();

  List<Widget> hardshipReasons = [];
  List<Widget> questionsAndSuggestions = [];

  MedicalAssistant assistant = MedicalAssistant();

  @override
  void initState() {
    ctrlSlider.stream
        .debounceTime(const Duration(milliseconds: 200))
        .listen((event) {
      ctrlPage
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

  @override
  Widget build(BuildContext context) {
    questionsAndSuggestions = [];

    assistant.questionsAndSuggestions(context).forEach((e) {
      List<Widget> suggestions = [];

      for (var f in e.suggestions) {
        suggestions.add(switch (e.enumInput) {
          INPUT.checkbox => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(f.suggestion),
              value: false,
              onChanged: (bool? value) {},
            ),
          INPUT.radio => RadioListTile<String>(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(f.suggestion),
              value: '',
              groupValue: '',
              onChanged: (String? value) {},
            ),
          INPUT.text => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(f.suggestion),
              value: false,
              onChanged: (bool? value) {},
            ),
        });
      }

      if (e.hasOther) {
        suggestions.add(
          TextareaForm(
            hintText: 'Other ...',
            expands: false,
            focusNode: e.focusNode,
          ),
        );
      }

      questionsAndSuggestions.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  e.question,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              // Expanded(
              //   child: TextareaForm(
              //     expands: true,
              //     focusNode: e.focusNode,
              //   ),
              // ),
              Expanded(
                child: RawScrollbar(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      children: suggestions,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return AssistantLayout(
      title: AppLocalizations.of(context)!.assistant,
      helpText: '',
      helpUrl: '',
      children: [
        Expanded(
          child: PageView(
            controller: ctrlPage,
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
              ctrlSlider.sink.add(value);
            });
          },
        ),
      ],
      onNext: () {
        if ((_sliderVal.toInt() + 1) < questionsAndSuggestions.length) {
          setState(() {
            _sliderVal += 1.0;
          });
          ctrlSlider.sink.add(_sliderVal);
        } else {
          Navigator.of(context).push(
            ViewHelper.routeSlide(
              const WritingScreen(),
            ),
          );
        }
      },
    );
  }
}
