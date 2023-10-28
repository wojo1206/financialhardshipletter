import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step3.screen.dart';
import 'package:simpleiawriter/widgets/writing.screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../form/textarea.form.dart';

class WriterAssistantStep2 extends StatefulWidget {
  const WriterAssistantStep2({super.key});

  @override
  State<WriterAssistantStep2> createState() => _WriterAssistantStep2State();
}

class _WriterAssistantStep2State extends State<WriterAssistantStep2> {
  late PERSON? _character = PERSON.FIRST;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('New Letter - Introduction',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.bodyWrapper(
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
                  RadioListTile<PERSON>(
                    title: Text(AppLocalizations.of(context)!.askPersonFirst),
                    value: PERSON.FIRST,
                    groupValue: _character,
                    onChanged: (PERSON? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  RadioListTile<PERSON>(
                    title: Text(AppLocalizations.of(context)!.askPersonThird),
                    value: PERSON.THIRD,
                    groupValue: _character,
                    onChanged: (PERSON? value) {
                      setState(() {
                        _character = value;
                      });
                    },
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
                        builder: (context) => const WriterAssistantStep3()),
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
