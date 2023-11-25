import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/blocs/app.bloc.dart';
import 'package:simpleiawriter/blocs/auth.bloc.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';
import 'package:simpleiawriter/widgets/writing.screen.dart';

import 'form/textarea.form.dart';

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
  List<Widget> questions = [];

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

    ctrlSlider.close();
  }

  @override
  Widget build(BuildContext context) {
    questions = [];

    Assistant.getQuestionGroups(context).forEach((questionGroup) {
      for (var question in questionGroup.questions) {
        List<Widget> suggestions = [];

        for (var suggestion in question.suggestions) {
          suggestions.add(
            switch (question.enumInput) {
              INPUT.checkbox => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(suggestion.text),
                  subtitle: suggestion.explain.isEmpty
                      ? null
                      : Text(suggestion.explain),
                  value: question.values.contains(suggestion.text),
                  onChanged: (bool? value) {
                    setState(
                      () {
                        if (value == null) {
                          // Intentionally empty
                        } else if (value == true) {
                          question.values.add(suggestion.text);
                        } else if (value == false) {
                          question.values
                              .removeWhere((i) => i == suggestion.text);
                        }
                      },
                    );
                  },
                ),
              INPUT.radio => RadioListTile<String>(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(suggestion.text),
                  subtitle: suggestion.explain.isEmpty
                      ? null
                      : Text(suggestion.explain),
                  value: suggestion.text,
                  groupValue: question.getSingleValue(),
                  onChanged: (String? value) {
                    setState(
                      () {
                        if (value != null) {
                          question.values.clear();
                          question.values.add(suggestion.text);
                        }
                      },
                    );
                  },
                ),
              INPUT.text => ListTile(
                  title: Text(suggestion.text),
                ),
            },
          );
        }

        if (question.hasOther) {
          suggestions.add(
            TextareaForm(
              hintText: AppLocalizations.of(context)!.other,
              expands: false,
              focusNode: question.focusNode,
              controller: question.otherController,
            ),
          );
        }

        suggestions.insert(
          0,
          Text(
            question.text,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        );

        questions.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Scrollbar(
                  controller: questionGroup.scrollController,
                  child: SingleChildScrollView(
                    controller: questionGroup.scrollController,
                    child: Wrap(
                      // spacing: 8.0,
                      children: suggestions,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
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
            children: questions,
          ),
        ),
        Row(
          children: [
            Text('${AppLocalizations.of(context)!.progress}:'),
            Expanded(
              child: Slider(
                value: sliderVal,
                min: 0,
                max: (questions.length - 1).toDouble(),
                divisions: questions.length - 1,
                onChanged: (double value) {
                  setState(() {
                    sliderVal = value;
                    ctrlSlider.sink.add(value);
                  });
                },
              ),
            ),
          ],
        ),
      ],
      onNext: () {
        try {
          if ((sliderVal.toInt() + 1) < questions.length) {
            setState(() {
              sliderVal += 1.0;
            });
            ctrlSlider.sink.add(sliderVal);
          } else {
            final blocAuth = BlocProvider.of<AuthBloc>(context);

            safePrint(Assistant.getPrompt(context).toJson());

            if (blocAuth.state.status != AuthenticationState.authenticated) {
              throw Exception(
                AppLocalizations.of(context)!.pleaseSignIn,
              );
            }
            if (blocAuth.state.tokens <= 0) {
              throw Exception(AppLocalizations.of(context)!.pleasePurchaseMore);
            }
            Navigator.of(context).push(
              ViewHelper.routeSlide(
                const WritingScreen(),
              ),
            );
          }
        } on Exception catch (e) {
          BlocProvider.of<AppBloc>(context).add(SetError(e.toString()));
        }
      },
    );
  }
}
