import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/widgets/writing.screen.dart';

import 'package:url_launcher/url_launcher.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('New Letter - Introduction',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  label: const Text('Generate'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const WritingScreen()),
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
