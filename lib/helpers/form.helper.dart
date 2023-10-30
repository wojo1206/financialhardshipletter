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
          AppLocalizations.of(context)!.letterTypeCreditCard
    };
  }

  static Widget bodyWrapper(BuildContext context, Widget child) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: child,
        ),
      ),
    );
  }

  static Widget pageWrapperNoScroll(BuildContext context, Widget child) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
      ),
    );
  }
}
