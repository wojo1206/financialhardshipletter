import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/helpers/form-helper.dart';
import 'package:simpleiawriter/helpers/view-helper.dart';
import 'package:simpleiawriter/widgets/assistant-writer/istep.dart';
import 'package:simpleiawriter/widgets/writing-screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WriterAssistantStep1 extends StatefulWidget {
  const WriterAssistantStep1({super.key});

  @override
  State<WriterAssistantStep1> createState() => _WriterAssistantStep1();
}

class _WriterAssistantStep1 extends State<WriterAssistantStep1> {
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
        title: Text('Writer - Context',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewHelper.listHorizontal(context, letterTypes),
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
}
