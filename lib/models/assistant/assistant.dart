import 'package:flutter/widgets.dart';

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

enum INPUT {
  radio,
  checkbox,
  text,
}

class Question {
  final QUESTION enumQuestion;
  final INPUT enumInput;
  final bool isSingleAnswer;
  final bool hasOther;
  final focusNode = FocusNode();
  final List<Suggestion> suggestions;
  final String question;

  Set filters = <String>{};

  Question(this.enumQuestion, this.enumInput, this.question, this.suggestions,
      {this.isSingleAnswer = true, this.hasOther = true});
}

class Suggestion {
  final String suggestion;
  final bool isFollowUp;
  final String explain;

  Suggestion(this.suggestion, {this.isFollowUp = true, this.explain = ""});
}

abstract class Assistant {
  late Gradient gradient;
  late Icon icon;

  String getLabel(BuildContext context);

  List<String> tones(BuildContext context) {
    return ['professional', 'friendly', 'kind', 'neutral', 'positive'];
  }

  List<Question> questionsAndSuggestions(BuildContext context) {
    return [
      Question(
        QUESTION.type,
        INPUT.radio,
        'Select your hardship area:',
        [
          Suggestion('Medical',
              explain:
                  'If your hardship is related to medical expenses, bills, or healthcare costs.'),
          Suggestion('Mortgage',
              explain:
                  'If your financial difficulties are connected to your home mortgage or rent.'),
          Suggestion('Credit Card',
              explain:
                  'If your hardship revolves around credit card debt and related financial struggles.'),
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.perpective,
        INPUT.radio,
        'Choose you writing perspective:',
        [
          Suggestion('First Person'),
          Suggestion('Third Person'),
        ],
        isSingleAnswer: true,
        hasOther: false,
      ),
      Question(
        QUESTION.reason,
        INPUT.checkbox,
        'What is the reason for your financial hardship?',
        [
          Suggestion('Job Loss'),
          Suggestion('Medical Expenses'),
          Suggestion('Unexpected Bills'),
          Suggestion('Divorce'),
          Suggestion('Natural disaster'),
          Suggestion('Severe Injury'),
          Suggestion('Severe Illness'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.lasting,
        INPUT.checkbox,
        'How long have you been facing this hardship?',
        [
          Suggestion('For the Past Six Months', isFollowUp: false),
          Suggestion('Since Last Year', isFollowUp: false),
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.specific,
        INPUT.checkbox,
        'What specific financial difficulties are you experiencing?',
        [
          Suggestion('Overdue Bills'),
          Suggestion('Mounting Debt'),
          Suggestion('Inability to Make Mortgage/Rent Payments'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.actionsTaken,
        INPUT.checkbox,
        'Have you taken any actions to address your hardship?',
        [
          Suggestion('Looking to Find a new Job'),
          Suggestion('Seeking Financial Assistance'),
          Suggestion('Negotiate with Creditors'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.supportingDocuments,
        INPUT.checkbox,
        'Do you have any supporting documents for your hardship?',
        [
          Suggestion('Medical Bills'),
          Suggestion('Job Termination Notice'),
          Suggestion('Health Condition Diagnosis'),
        ],
        isSingleAnswer: false,
      ),
      Question(
        QUESTION.highlightDetails,
        INPUT.text,
        'Are there any specific details or events related to your hardship that you want to highlight in the letter?',
        [
          Suggestion('Medical Diagnosis'),
          Suggestion('Job Termination Date'),
          Suggestion('Specific Incident')
        ],
        isSingleAnswer: true,
      ),
      Question(
        QUESTION.outcome,
        INPUT.radio,
        'Is there a specific outcome you hope to achieve through this hardship letter?',
        [
          Suggestion('Loan Modification'),
          Suggestion('Payment Extension'),
          Suggestion('Financial Assistance')
        ],
        isSingleAnswer: false,
      )
    ];
  }
}
