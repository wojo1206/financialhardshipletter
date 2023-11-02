import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:simpleiawriter/helpers/form.helper.dart';
import 'package:simpleiawriter/helpers/view.helper.dart';
import 'package:url_launcher/url_launcher.dart';

class AssistantLayout extends StatelessWidget {
  const AssistantLayout(
      {super.key,
      required this.title,
      required this.helpUrl,
      required this.helpText,
      required this.children,
      required this.onNext});

  final String title;
  final String helpUrl;
  final String helpText;

  final List<Widget> children;

  final Function onNext;

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [];

    if (helpText.isNotEmpty) {
      elements.add(ViewHelper.infoText(context, helpText));
    }

    elements.add(_buildBody(context));
    elements.add(_buildActionRow(context));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: elements,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
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
          onPressed: () => onNext(),
        ),
      ],
    );
  }

  _showHelp(BuildContext context) async {
    if (!await launchUrl(Uri.https('tocojest.com', helpUrl),
        mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch');
    }
  }
}
