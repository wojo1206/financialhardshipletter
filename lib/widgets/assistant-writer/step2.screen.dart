import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step3.screen.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';

class WriterAssistantStep2 extends StatefulWidget {
  const WriterAssistantStep2({super.key});

  @override
  State<WriterAssistantStep2> createState() => _WriterAssistantStep2State();
}

class _WriterAssistantStep2State extends State<WriterAssistantStep2> {
  late PERSON? _character = PERSON.first;

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
      title: 'Assistant - Introduction',
      helpText: AppLocalizations.of(context)!.hintPage2,
      screenNext: const WriterAssistantStep3(),
      helpUrl: '',
      children: [
        RadioListTile<PERSON>(
          title: Text(AppLocalizations.of(context)!.askPersonFirst),
          value: PERSON.first,
          groupValue: _character,
          onChanged: (PERSON? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<PERSON>(
          title: Text(AppLocalizations.of(context)!.askPersonThird),
          value: PERSON.third,
          groupValue: _character,
          onChanged: (PERSON? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ],
    );
  }
}
