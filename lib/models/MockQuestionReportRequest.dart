import 'package:flutter/material.dart';

class MockQuestionReportRequest {
  String mockId;
  String userId;
  String questionId;
  String userAnswer;
  String timeTaken;
  String correctAnswer;

  MockQuestionReportRequest({
    @required this.mockId,
    @required this.userId,
    @required this.questionId,
    @required this.userAnswer,
    @required this.timeTaken,
    @required this.correctAnswer,
  });

  MockQuestionReportRequest.fromJson(Map<String, dynamic> json) {
    mockId = json['mockId'];
    userId = json['userId'];
    questionId = json['questionId'];
    userAnswer = json['user_answer'];
    timeTaken = json['time_taken'];
    correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mockId'] = this.mockId;
    data['userId'] = this.userId;
    data['questionId'] = this.questionId;
    data['user_answer'] = this.userAnswer;
    data['time_taken'] = this.timeTaken;
    data['correct_answer'] = this.correctAnswer;
    return data;
  }
}
