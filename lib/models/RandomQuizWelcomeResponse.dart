import 'package:fullmarks/models/QuestionsResponse.dart';

class RandomQuizWelcomeResponse {
  String message;
  int participants;
  int room;
  int roomId;
  List<QuestionDetails> questions;

  RandomQuizWelcomeResponse({
    this.message,
    this.participants,
    this.room,
    this.roomId,
    this.questions,
  });

  RandomQuizWelcomeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    participants = json['participants'] ?? -1;
    room = json['room'] ?? 0;
    roomId = json['roomId'] ?? 0;
    if (json['questions'] != null) {
      questions = new List<QuestionDetails>();
      json['questions'].forEach((v) {
        questions.add(new QuestionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['participants'] = this.participants;
    data['room'] = this.room;
    data['roomId'] = this.roomId;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
