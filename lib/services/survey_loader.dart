import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/survey_question.dart';


class SurveyLoader {

  Future<List<SurveyQuestion>> loadQuestion() async{

    final jsonString = 
      await rootBundle.loadString(
        'assets/questions.json',
        );

    final List<dynamic> jsonData =
      json.decode(jsonString);
    
    return jsonData.map((item) => SurveyQuestion.fromJson(item),
    ).toList();
  }
}