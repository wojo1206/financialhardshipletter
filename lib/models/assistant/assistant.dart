import 'package:flutter/widgets.dart';
import 'package:simpleiawriter/constants.dart';

enum PERSON { first, third }

class Subject {
  String name = '';
  String address = '';
  String contactInfo = '';
  PERSON person = PERSON.first;
}

abstract class Assistant {
  late Gradient gradient;
  late Icon icon;
  late HardshipLetterType letterType;

  String getLabel(BuildContext context);

  List<String> reasons(BuildContext context);

  List<String> outcomes(BuildContext context);

  List<String> tones(BuildContext context) {
    return ["friendly", "kind", "neutral", "positive"];
  }
}
