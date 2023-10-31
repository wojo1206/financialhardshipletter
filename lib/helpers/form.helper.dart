import 'package:flutter/material.dart';

import 'package:simpleiawriter/models/assistant/assistant.dart';
import 'package:simpleiawriter/models/assistant/credit-card.assistant.dart';
import 'package:simpleiawriter/models/assistant/medical.assistant.dart';
import 'package:simpleiawriter/models/assistant/mortgage.assistant.dart';

class FormHelper {
  static List<Assistant>? assistants;

  static List<Assistant>? getAssistants() {
    if (assistants != null) {
      return assistants;
    }

    assistants = [
      MedicalAssistant(),
      CreditCardAssistant(),
      MortgageAssistant(),
    ];

    return assistants;
  }

  static Widget wrapperBody(BuildContext context, Widget child) {
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

  static Widget wrapperBodyNoScroll(BuildContext context, Widget child) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
      ),
    );
  }
}
