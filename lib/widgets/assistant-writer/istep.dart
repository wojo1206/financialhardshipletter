// Library a.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

base class MyStep {
  abstract String helpPath;

  void _showHelp(BuildContext context) async {
    if (!await launchUrl(
        Uri.https(
          'tocojest.com',
          helpPath,
        ),
        mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch');
    }
  }
}
