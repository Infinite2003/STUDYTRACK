
class SurveyQuestion{

  final int id;
  final String question;
  final int min;
  final int max;

  SurveyQuestion({

    required this.id,
    required this.question,
    required this.min,
    required this.max,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json){

    return SurveyQuestion(
      id: json["id"], 
      question: json["question"], 
      min: json["min"], 
      max: json["max"],
      );
  }
}