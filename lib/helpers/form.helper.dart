import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:simpleiawriter/constants.dart';

class FormHelper {
  static Map<Enum, String> letterOptions(BuildContext context) {
    return {
      HardshipLetterType.medical:
          AppLocalizations.of(context)!.letterTypeMedical,
      HardshipLetterType.mortgage:
          AppLocalizations.of(context)!.letterTypeMortgage,
      HardshipLetterType.creditCard:
          AppLocalizations.of(context)!.letterTypeCreditCard,
      HardshipLetterType.unspecified:
          AppLocalizations.of(context)!.letterTypeUnspecified
    };
  }
}
