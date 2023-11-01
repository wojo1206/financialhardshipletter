import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step4.screen.dart';
import 'package:simpleiawriter/widgets/layout/assistant.layout.dart';

import '../form/textarea.form.dart';

class WriterAssistantStep3 extends StatefulWidget {
  const WriterAssistantStep3({super.key});

  @override
  State<WriterAssistantStep3> createState() => _WriterAssistantStep3State();
}

class _WriterAssistantStep3State extends State<WriterAssistantStep3> {
  late FocusNode? focusNodeForName;
  late FocusNode? focusNodeForContact;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    focusNodeForName = FocusNode();
    focusNodeForContact = FocusNode();

    Future.delayed(const Duration(seconds: 0), () {
      focusNodeForName?.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNodeForName!.dispose();
    focusNodeForContact!.dispose();

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
      title: 'Assistant - Question',
      helpText: AppLocalizations.of(context)!.hintPage3,
      screenNext: const WriterAssistantStep4(),
      helpUrl: '',
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                child: TextareaForm(
                  hintText: AppLocalizations.of(context)!.askYourName,
                  helperText: AppLocalizations.of(context)!.askYourName,
                  expands: false,
                  maxLines: 1,
                  focusNode: focusNodeForName,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                child: TextareaForm(
                  hintText: AppLocalizations.of(context)!.askYourContact,
                  helperText: AppLocalizations.of(context)!.askYourContact,
                  expands: false,
                  maxLines: 1,
                  focusNode: focusNodeForContact,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
