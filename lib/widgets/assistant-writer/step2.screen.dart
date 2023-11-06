import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step3.screen.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';

class WriterAssistantStep2 extends StatefulWidget {
  const WriterAssistantStep2({super.key});

  @override
  State<WriterAssistantStep2> createState() => _WriterAssistantStep2State();
}

class _WriterAssistantStep2State extends State<WriterAssistantStep2> {
  late PERSON? perspective = PERSON.first;

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
    return AssistantLayout(
      title: AppLocalizations.of(context)!.assistant,
      helpText: AppLocalizations.of(context)!.hintPage2,
      helpUrl: '',
      children: [
        RadioListTile<PERSON>(
          title: Text(AppLocalizations.of(context)!.askPersonFirst),
          value: PERSON.first,
          groupValue: perspective,
          onChanged: (PERSON? value) {
            setState(() {
              perspective = value;
            });
          },
        ),
        RadioListTile<PERSON>(
          title: Text(AppLocalizations.of(context)!.askPersonThird),
          value: PERSON.third,
          groupValue: perspective,
          onChanged: (PERSON? value) {
            setState(() {
              perspective = value;
            });
          },
        ),
      ],
      onNext: () => Navigator.of(context).push(
        ViewHelper.routeSlide(
          const WriterAssistantStep3(),
        ),
      ),
    );
  }
}
