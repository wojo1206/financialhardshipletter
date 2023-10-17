import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/helpers/form-helper.dart';
import 'package:simpleiawriter/helpers/view-helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:simpleiawriter/widgets/writing-screen.dart';

import 'form/textarea-form.dart';

class WriterScreen extends StatefulWidget {
  const WriterScreen({super.key});

  @override
  State<WriterScreen> createState() => _WriterScreenState();
}

class _WriterScreenState extends State<WriterScreen> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> letterTypes = [];
    FormHelper.letterOptions(context).values.forEach(
          (e) => letterTypes.add(
            ChoiceChip(
              label: Text(e),
              selected: true,
              onSelected: (value) => {},
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Writer', style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewHelper.listHorizontal(context, letterTypes),
            Expanded(
              child: TextareaForm(
                  hintText: AppLocalizations.of(context)!.writerBase),
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
                  label: const Text("Help"),
                  onPressed: () => _showHelp(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chevron_right),
                  label: const Text("Generate"),
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

  _generateResponse(BuildContext context) {}

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
