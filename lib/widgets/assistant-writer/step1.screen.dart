import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/constants.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:simpleiawriter/widgets/assistant-writer/step2.screen.dart';

import 'package:url_launcher/url_launcher.dart';

class WriterAssistantStep1 extends StatefulWidget {
  const WriterAssistantStep1({super.key});

  @override
  State<WriterAssistantStep1> createState() => _WriterAssistantStep1();
}

class _WriterAssistantStep1 extends State<WriterAssistantStep1> {
  HardshipLetterType? _letterType = HardshipLetterType.medical;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> letterTypes = [];

    FormHelper.getAssistants()?.forEach((e) {
      var icon = e.icon;

      letterTypes.add(
        Expanded(
          child: Row(
            children: [
              Radio<HardshipLetterType>(
                  value: e.letterType,
                  groupValue: _letterType,
                  onChanged: (HardshipLetterType? value) {
                    setState(() {
                      _letterType = value;
                    });
                  }),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [icon, Text(e.getLabel(context))]),
              ),
            ],
          ),
        ),
      );
    });

    safePrint("REPAINT");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Assistant - Type',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.wrapperBody(
        context,
        Column(
          children: [
            ViewHelper.infoText(
                context, AppLocalizations.of(context)!.hintPage1),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: letterTypes),
            ),
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Row(
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
                    builder: (context) => const WriterAssistantStep2()),
              ),
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
  }
}
