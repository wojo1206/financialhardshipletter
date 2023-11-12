import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

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
  double sliderVal = 0;
  final StreamController<double> ctrlSlider = StreamController<double>();

  List<Widget> hardshipReasons = [];
  List<Widget> questionsAndSuggestions = [];

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

    Assistant.getQuestions(context).forEach((e) {
      List<Widget> suggestions = [];

      for (var f in e.suggestions) {
        suggestions.add(switch (e.enumInput) {
          INPUT.checkbox => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(f.suggestion),
              value: e.values.contains(f.suggestion),
              onChanged: (bool? value) {
                setState(() {
                  if (value == null) {
                    // Intentionally empty
                  } else if (value == true) {
                    e.values.add(f.suggestion);
                  } else if (value == false) {
                    e.values.removeWhere((i) => i == f.suggestion);
                  }
                });
              },
            ),
          INPUT.radio => RadioListTile<String>(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(f.suggestion),
              value: f.suggestion,
              groupValue: e.getFirstValue(),
              onChanged: (String? value) {
                setState(() {
                  if (value != null) {
                    e.values.clear();
                    e.values.add(f.suggestion);
                  }
                });
              },
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
            hintText: AppLocalizations.of(context)!.other,
            expands: false,
            focusNode: e.focusNode,
            controller: e.otherController,
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
                child: Scrollbar(
                  controller: e.scrollController,
                  child: SingleChildScrollView(
                    controller: e.scrollController,
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
          value: sliderVal,
          min: 0,
          max: (questionsAndSuggestions.length - 1).toDouble(),
          divisions: questionsAndSuggestions.length - 1,
          onChanged: (double value) {
            setState(() {
              sliderVal = value;
              ctrlSlider.sink.add(value);
            });
          },
        ),
      ],
      onNext: () {
        if ((sliderVal.toInt() + 1) < questionsAndSuggestions.length) {
          setState(() {
            sliderVal += 1.0;
          });
          ctrlSlider.sink.add(sliderVal);
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
