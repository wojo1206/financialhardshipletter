import 'package:flutter/widgets.dart';
import 'package:simpleiawriter/constants.dart';

enum PERSON { first, third }

class QuestionAndSuggestions {
  final String question;
  final List<String> suggestions;

  final focusNode = FocusNode();

  QuestionAndSuggestions(this.question, this.suggestions);
}

abstract class Assistant {
  late Gradient gradient;
  late Icon icon;
  late HardshipLetterType letterType;

  String getLabel(BuildContext context);

  List<String> reasons(BuildContext context);

  List<String> outcomes(BuildContext context);

  List<String> tones(BuildContext context) {
    return ['professional', 'friendly', 'kind', 'neutral', 'positive'];
  }

  List<QuestionAndSuggestions> questionsAndSuggestions(BuildContext context) {
    return [
      QuestionAndSuggestions('What is the reason for your hardship?', [
        'job loss',
        'medical expenses',
        'unexpected bills',
        'divorce',
        'natural disaster',
        'severe injury',
        'severe illness',
      ]),
      QuestionAndSuggestions('How long have you been facing this hardship?', [
        'for the past six months',
        'since last year',
      ]),
      QuestionAndSuggestions(
          'What specific financial difficulties are you experiencing?', [
        'overdue bills',
        'mounting debt',
        'inability to make mortgage/rent payments',
      ]),
      QuestionAndSuggestions(
          'Have you taken any actions to address your hardship?', [
        'looking to find a new job',
        'seeking financial assistance',
        'negotiate with creditors',
      ]),
      QuestionAndSuggestions(
          'Do you have any supporting documents for your hardship (e.g., medical bills, termination notice)?',
          []),
      QuestionAndSuggestions(
          'Are there any specific details or events related to your hardship that you want to highlight in the letter?',
          ['medical diagnosis', 'job termination date', 'specific incident']),
      QuestionAndSuggestions(
          'Is there a specific outcome you hope to achieve through this hardship letter?',
          ['loan modification', 'payment extension', 'financial assistance'])
    ];
  }
}
