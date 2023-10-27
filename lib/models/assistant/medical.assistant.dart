import 'package:flutter/src/widgets/framework.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

class MedicalAssistant extends Assistant {
  @override
  List<String> outcomes(BuildContext context) {
    return ['debt forgiveness', 'debt settlement'];
  }

  @override
  List<String> reasons(BuildContext context) {
    return [
      'severe injury',
      'severe illness',
      'death of a family member',
      'layoff',
      'loss of insurance'
    ];
  }
}
