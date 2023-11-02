import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

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
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> hardshipReasons = [];
    List<Widget> questionsAndSuggestions = [];

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
        Column(
          children: [
            Expanded(
              child: TextareaForm(
                hintText: e.question,
                helperText: e.question,
                expands: true,
                focusNode: e.focusNode,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.hardEdge,
              child: Wrap(
                spacing: 8.0,
                children: suggestions,
              ),
            ),
          ],
        ),
      );
    });

    return AssistantLayout(
      title: 'Assistant',
      helpText:
          'These ${questionsAndSuggestions.length} questions help to produce a letter specific to you needs.',
      helpUrl: '',
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: PageView(
            controller: controller,
            clipBehavior: Clip.antiAlias,
            children: questionsAndSuggestions,
            onPageChanged: (value) => {
              setState(() {
                _currentSliderValue = value.toDouble();
              })
            },
          ),
        ),
        Expanded(child: Container()),
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: (questionsAndSuggestions.length - 1).toDouble(),
          divisions: questionsAndSuggestions.length - 1,
          onChanged: (double value) {
            var asInt = value.toInt();
            setState(() {
              controller
                  .animateToPage(
                    asInt,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  )
                  .then((value) {});
            });
          },
        ),
      ],
      onNext: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const WritingScreen()),
        );
      },
    );
  }
}
