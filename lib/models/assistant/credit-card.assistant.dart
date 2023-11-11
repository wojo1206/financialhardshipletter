import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';

class CreditCardAssistant extends Assistant {
  @override
  Icon get icon => const Icon(
        Icons.credit_card,
        size: 96.0,
      );

  @override
  Gradient get gradient => const LinearGradient(
      stops: [0, 0.46, 1],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [Color(0xFF23408E), Color(0xFF385399), Color(0xFF3A4CB4)]);

  @override
  String getLabel(BuildContext context) {
    return AppLocalizations.of(context)!.letterTypeCreditCard;
  }
}
