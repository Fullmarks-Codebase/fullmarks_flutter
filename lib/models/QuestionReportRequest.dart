import 'package:flutter/material.dart';

class QuestionReportAnswers {
  String userId;
  String questionId;
  String userAnswer;
  String timeTaken;
  String correctAnswer;

  QuestionReportAnswers({
    @required this.userId,
    @required this.questionId,
    @required this.userAnswer,
    @required this.timeTaken,
    @required this.correctAnswer,
  });

  QuestionReportAnswers.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    questionId = json['questionId'];
    userAnswer = json['user_answer'];
    timeTaken = json['time_taken'];
    correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['questionId'] = this.questionId;
    data['user_answer'] = this.userAnswer;
    data['time_taken'] = this.timeTaken;
    data['correct_answer'] = this.correctAnswer;
    return data;
  }
}
