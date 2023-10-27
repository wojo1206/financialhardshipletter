import 'package:flutter/widgets.dart';

enum PERSON { FIRST, THIRD }

class Subject {
  String name = '';
  String address = '';
  String contactInfo = '';
  PERSON person = PERSON.FIRST;
}

abstract class Assistant {
  String base = '';

  Subject subject = Subject();

  List<String> tones(BuildContext context) {
    return ["friendly", "kind", "neutral", "positive"];
  }

  List<String> reasons(BuildContext context);

  List<String> outcomes(BuildContext context);
}
