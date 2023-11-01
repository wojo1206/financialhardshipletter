import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';
import 'package:simpleiawriter/widgets/writing.screen.dart';

import '../form/textarea.form.dart';

class WriterAssistantStep4 extends StatefulWidget {
  const WriterAssistantStep4({super.key});

  @override
  State<WriterAssistantStep4> createState() => _WriterAssistantStep4State();
}

class _WriterAssistantStep4State extends State<WriterAssistantStep4> {
  late FocusNode? focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();

    Future.delayed(const Duration(seconds: 0), () {
      focusNode?.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode!.dispose();

    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> hardshipReasons = [];

    MedicalAssistant().reasons(context).forEach(
          (e) => hardshipReasons.add(
            FilterChip(
              label: Text(e),
              selected: true,
              onSelected: (value) => {},
            ),
          ),
        );

    return AssistantLayout(
      title: 'Assistant - Questions',
      helpText: '',
      screenNext: const WritingScreen(),
      helpUrl: '',
      children: [
        Expanded(
          child: TextareaForm(
            hintText: AppLocalizations.of(context)!.writerBase,
            focusNode: focusNode,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: hardshipReasons,
        )
      ],
    );
  }
}
