import 'package:flutter/widgets.dart';
import 'package:simpleiawriter/constants.dart';

enum PERSON { first, third }

enum QUESTION {
  type,
  perpective,
  reason,
  lasting,
  specific,
  actionsTaken,
  supportingDocuments,
  highlightDetails,
  outcome,
}

class Question {
  final QUESTION questionEnum;
  final bool isSingleAnswer;
  final focusNode = FocusNode();
  final List<Suggestion> suggestions;
  final String question;

  Set filters = <String>{};

  Question(this.questionEnum, this.question, this.suggestions,
      {this.isSingleAnswer = true});
}

class Suggestion {
  final String suggestion;
  final bool isFollowUp;

  Suggestion(this.suggestion, {this.isFollowUp = true});
}

abstract class Assistant {
  late Gradient gradient;
  late Icon icon;
  late HardshipLetterType letterType;

  String getLabel(BuildContext context);

  List<String> tones(BuildContext context) {
    return ['professional', 'friendly', 'kind', 'neutral', 'positive'];
  }

  List<Question> questionsAndSuggestions(BuildContext context) {
    return [
      Question(
        QUESTION.type,
        'Select your hardship area:',
        [
          Suggestion('medical'),
          Suggestion('mortgage'),
          Suggestion('credit card'),
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.perpective,
        'Choose you writing perspective:',
        [
          Suggestion('first person'),
          Suggestion('third person'),
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.reason,
        'What is the reason for your financial hardship?',
        [
          Suggestion('job loss'),
          Suggestion('medical expenses'),
          Suggestion('unexpected bills'),
          Suggestion('divorce'),
          Suggestion('natural disaster'),
          Suggestion('severe injury'),
          Suggestion('severe illness'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.lasting,
        'How long have you been facing this hardship?',
        [
          Suggestion('for the past six months', isFollowUp: false),
          Suggestion('since last year', isFollowUp: false),
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.specific,
        'What specific financial difficulties are you experiencing?',
        [
          Suggestion('overdue bills'),
          Suggestion('mounting debt'),
          Suggestion('inability to make mortgage/rent payments'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.actionsTaken,
        'Have you taken any actions to address your hardship?',
        [
          Suggestion('looking to find a new job'),
          Suggestion('seeking financial assistance'),
          Suggestion('negotiate with creditors'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.supportingDocuments,
        'Do you have any supporting documents for your hardship?',
        [
          Suggestion('medical bills'),
          Suggestion('job termination notice'),
          Suggestion('health condition diagnosis'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.highlightDetails,
        'Are there any specific details or events related to your hardship that you want to highlight in the letter?',
        [
          Suggestion('medical diagnosis'),
          Suggestion('job termination date'),
          Suggestion('specific incident')
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.outcome,
        'Is there a specific outcome you hope to achieve through this hardship letter?',
        [
          Suggestion('loan modification'),
          Suggestion('payment extension'),
          Suggestion('financial assistance')
        ],
        isSingleAnswer: false,
      )
    ];
  }
}
