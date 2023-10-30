import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simpleiawriter/models/assistant/assistant.dart';

class MedicalAssistant extends Assistant {
  MedicalAssistant(super.context);

  @override
  List<Color> get colors => const [
        Color(0xff1f005c),
        Color(0xff5b0060),
        Color(0xff870160),
        Color(0xffac255e),
        Color(0xffca485c),
        Color(0xffe16b5c),
        Color(0xfff39060),
        Color(0xffffb56b),
      ];

  @override
  String get label => 'medical';

  @override
  List<String> outcomes() {
    return ['debt forgiveness', 'debt settlement'];
  }

  @override
  List<String> reasons() {
    return [
      'severe injury',
      'severe illness',
      'death of a family member',
      'layoff',
      'loss of insurance'
    ];
  }
}
