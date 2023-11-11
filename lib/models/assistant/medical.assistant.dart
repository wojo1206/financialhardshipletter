import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';

class MedicalAssistant extends Assistant {
  @override
  Icon get icon => const Icon(
        Icons.medical_services,
        size: 96.0,
      );

  @override
  Gradient get gradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment(0.8, 1),
        colors: <Color>[
          Color(0xff1f005c),
          Color(0xff5b0060),
          Color(0xff870160),
          Color(0xffac255e),
          Color(0xffca485c),
          Color(0xffe16b5c),
          Color(0xfff39060),
          Color(0xffffb56b),
        ], // Gradient from https://learnui.design/tools/gradient-generator.html
        tileMode: TileMode.mirror,
      );

  @override
  String getLabel(BuildContext context) {
    return AppLocalizations.of(context)!.letterTypeMedical;
  }
}
