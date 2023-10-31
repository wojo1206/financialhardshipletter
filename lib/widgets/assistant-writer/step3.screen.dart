import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step4.screen.dart';
import 'package:simpleiawriter/widgets/writing.screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../form/textarea.form.dart';

class WriterAssistantStep3 extends StatefulWidget {
  const WriterAssistantStep3({super.key});

  @override
  State<WriterAssistantStep3> createState() => _WriterAssistantStep3State();
}

class _WriterAssistantStep3State extends State<WriterAssistantStep3> {
  late FocusNode? focusNodeForName;
  late FocusNode? focusNodeForContact;

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

    return Scaffold(
      appBar: AppBar(
        title: Text('New Letter - Introduction',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ViewHelper.infoText(
                context, AppLocalizations.of(context)!.hintPage2),
            Expanded(
              child: Column(
                children: [
                  TextareaForm(
                    hintText: AppLocalizations.of(context)!.askYourName,
                    helperText: AppLocalizations.of(context)!.askYourName,
                    expands: false,
                    maxLines: 1,
                    focusNode: focusNodeForName,
                  ),
                  TextareaForm(
                    hintText: AppLocalizations.of(context)!.askYourContact,
                    helperText: AppLocalizations.of(context)!.askYourContact,
                    expands: false,
                    maxLines: 1,
                    focusNode: focusNodeForContact,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.help),
                  label: Text(AppLocalizations.of(context)!.help),
                  onPressed: () => _showHelp(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chevron_right),
                  label: Text(AppLocalizations.of(context)!.next),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const WriterAssistantStep4()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showHelp(BuildContext context) async {
    if (!await launchUrl(
        Uri.https(
          'tocojest.com',
          '/en/my-apps/recipe-polisher-app/recipe-polisher-privacy-policy',
        ),
        mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch');
    }

    // ViewHelper.helpSheet(context, "HELP");
  }
}
