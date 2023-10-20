import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form-helper.dart';
import 'package:simpleiawriter/helpers/view-helper.dart';
import 'package:simpleiawriter/widgets/writing-screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../form/textarea-form.dart';

class WriterAssistantStep2 extends StatefulWidget {
  const WriterAssistantStep2({super.key});

  @override
  State<WriterAssistantStep2> createState() => _WriterAssistantStep2State();
}

class _WriterAssistantStep2State extends State<WriterAssistantStep2> {
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
    focusNode?.dispose();

    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Letter - Details',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextareaForm(
                hintText: AppLocalizations.of(context)!.writerBase,
                focusNode: focusNode,
              ),
            ),
            FilterChip(
              label: const Text('Aaron Burr'),
              selected: true,
              onSelected: (value) => {},
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
