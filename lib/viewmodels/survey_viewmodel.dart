import 'package:flutter/material.dart';
import '../models/survey_question.dart';
import '../services/survey_loader.dart';

class SurveyViewModel extends ChangeNotifier {
  final SurveyLoader loader;

  SurveyViewModel(this.loader);

  List<SurveyQuestion> questions = [];
  final Map<int, int> answers = {};

  Future<void> loadQuestions() async {
    questions = await loader.loadQuestion();
    notifyListeners();
  }

  void setAnswer(int questionId, int value) {
    answers[questionId] = value;
    notifyListeners();
  }

  bool get allAnswered => answers.length == questions.length;

  /// Genera el cuerpo del email con todas las respuestas
  String buildEmailBody() {
    String body = "=== Evaluación STUDYTRACK ===\n\n";
    for (var question in questions) {
      body +=
          "• ${question.question}\n  Respuesta: ${answers[question.id]} / ${question.max}\n\n";
    }
    final total = answers.values.fold(0, (a, b) => a + b);
    final maxTotal = questions.fold(0, (acc, q) => acc + q.max);
    body += "Puntuación total: $total / $maxTotal\n";
    return body;
  }
}
