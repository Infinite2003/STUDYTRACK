import 'package:flutter/material.dart';

import '../models/survey_question.dart';
import '../services/survey_loader.dart';

class SurveyViewModel extends ChangeNotifier {

  final SurveyLoader loader;

  SurveyViewModel(this.loader);

  List<SurveyQuestion> questions = [];

  final Map<int, int> answers = {};

  Future<void> loadQuestions() async {

    questions =
        await loader.loadQuestion();

    notifyListeners();
  }

  void setAnswer(
    int questionId,
    int value,
  ) {

    answers[questionId] = value;

    notifyListeners();
  }

  bool get allAnswered {

    return answers.length ==
        questions.length;
  }
}