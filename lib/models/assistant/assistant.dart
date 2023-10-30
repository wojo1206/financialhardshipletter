import 'package:flutter/widgets.dart';

enum PERSON { first, third }

class Subject {
  String name = '';
  String address = '';
  String contactInfo = '';
  PERSON person = PERSON.first;
}

abstract class Assistant {
  late BuildContext context;
  late List<Color> colors;
  late String label;

  List<String> tones(BuildContext context) {
    return ["friendly", "kind", "neutral", "positive"];
  }

  List<String> reasons();

  List<String> outcomes();

  Assistant(BuildContext context) {
    context = context;
  }
}
