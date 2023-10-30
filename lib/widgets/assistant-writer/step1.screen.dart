import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';

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

    // FormHelper.letterOptions(context).values.forEach(
    //       (e) => letterTypes.add(
    //         ElevatedButton(
    //           child: Text(
    //             e,
    //             style: Theme.of(context).textTheme.bodyLarge,
    //           ),
    //           onPressed: () => Navigator.of(context).push(
    //             MaterialPageRoute(
    //                 builder: (context) => const WriterAssistantStep2()),
    //           ),
    //         ),
    //       ),
    //     );

    FormHelper.letterOptions(context).values.forEach(
          (e) => letterTypes.add(
            Expanded(
              child: Row(
                children: [
                  Radio<String?>(
                      value: null,
                      groupValue: null,
                      onChanged: (String? value) {}),
                  Expanded(
                    child: ViewHelper.boxFlat(
                      context,
                      Text(
                        e,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Assistant - Type',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: FormHelper.bodyWrapper(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.help),
                  label: Text(AppLocalizations.of(context)!.help),
                  onPressed: () => _showHelp(context),
                )
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
  }
}
