import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:simpleiawriter/constants.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

class MortgageAssistant extends Assistant {
  @override
  Icon get icon => const Icon(
        Icons.house,
        size: 96.0,
      );

  @override
  Gradient get gradient => const LinearGradient(
      stops: [0, 0.46, 1],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Color(0xFF23408E), Color(0xFF385399), Color(0xFF3A4CB4)]);

  @override
  HardshipLetterType get letterType => HardshipLetterType.mortgage;

  @override
  String getLabel(BuildContext context) {
    return AppLocalizations.of(context)!.letterTypeMortgage;
  }

  @override
  List<String> outcomes(BuildContext context) {
    return ['debt forgiveness', 'debt settlement'];
  }

  @override
  List<String> reasons(BuildContext context) {
    return [
      'death of a family member',
      'layoff',
      'loss of insurance',
      'severe illness',
      'severe injury',
    ];
  }
}
