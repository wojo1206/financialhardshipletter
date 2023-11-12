import 'package:flutter/widgets.dart';

enum PERSON { first, third }

enum QUESTION {
  type,
  perspective,
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
  final bool hasOther;
  final focusNode = FocusNode();
  final List<String> values = [];
  final List<Suggestion> suggestions;
  final ScrollController scrollController = ScrollController();
  final TextEditingController otherController = TextEditingController();
  final String question;

  Set filters = <String>{};

  Question(this.enumQuestion, this.enumInput, this.question, this.suggestions,
      {this.hasOther = true});

  String getFirstValue() {
    return values.isEmpty ? '' : values.first;
  }

  // Includes
  String getValue() {
    var tmp = values;
    tmp.add(otherController.text);
    return tmp.join(', ');
  }
}

class Suggestion {
  final String suggestion;
  final bool isFollowUp;
  final String explain;

  Suggestion(this.suggestion, {this.isFollowUp = true, this.explain = ''});
}

class Assistant {
  static List<Question> _questionsAndSuggestions = [];
  static List<String> _tones = [];

  static List<Question> getQuestions(BuildContext context) {
    if (_questionsAndSuggestions.isEmpty) {
      _questionsAndSuggestions = Assistant.questionsAndSuggestions(context);
    }
    return _questionsAndSuggestions;
  }

  static List<String> getTones(BuildContext context) {
    if (_tones.isEmpty) {
      _tones = Assistant.tones(context);
    }
    return _tones;
  }

  static List<String> tones(BuildContext context) {
    return ['professional', 'friendly', 'kind', 'neutral', 'positive'];
  }

  static List<Question> questionsAndSuggestions(BuildContext context) {
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
      ),
      Question(
        QUESTION.perspective,
        INPUT.radio,
        'Choose you writing perspective:',
        [
          Suggestion('First Person'),
          Suggestion('Third Person'),
        ],
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
          Suggestion('Natural Disaster'),
          Suggestion('Severe Injury'),
          Suggestion('Severe Illness'),
        ],
      ),
      Question(
        QUESTION.lasting,
        INPUT.radio,
        'How long have you been facing this hardship?',
        [
          Suggestion('For the Past Six Months', isFollowUp: false),
          Suggestion('Since Last Year', isFollowUp: false),
        ],
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
      )
    ];
  }
}
