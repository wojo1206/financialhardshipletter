import 'package:flutter/widgets.dart';

class Subject {
  String name = '';
  String address = '';
}

abstract class Assistable {
  late Subject subject;

  List<String> outcomes(BuildContext context);

  Assistable setSubject(Subject subject);
}
