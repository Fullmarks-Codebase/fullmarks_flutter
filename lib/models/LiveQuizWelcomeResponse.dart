import 'package:fullmarks/models/QuestionsResponse.dart';

import 'LiveQuizResponse.dart';

class LiveQuizWelcomeResponse {
  String message;
  String id;
  int participants;
  List<LiveQuizWelcomeDetails> questions;
  LiveQuizRoom room;

  LiveQuizWelcomeResponse(
      {this.message, this.id, this.participants, this.questions, this.room});

  LiveQuizWelcomeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    id = json['id'] ?? 0;
    participants = json['participants'] ?? -1;
    if (json['questions'] != null) {
      questions = new List<LiveQuizWelcomeDetails>();
      json['questions'].forEach((v) {
        questions.add(new LiveQuizWelcomeDetails.fromJson(v));
      });
    }
    room =
        json['room'] != null ? new LiveQuizRoom.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['id'] = this.id;
    data['participants'] = this.participants;
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    if (this.room != null) {
      data['room'] = this.room.toJson();
    }
    return data;
  }
}

class LiveQuizWelcomeDetails {
  QuestionDetails fixQuestion;
  QuestionDetails customQuestion;

  LiveQuizWelcomeDetails({this.fixQuestion, this.customQuestion});

  LiveQuizWelcomeDetails.fromJson(Map<String, dynamic> json) {
    fixQuestion = json['fix_question'] != null
        ? new QuestionDetails.fromJson(json['fix_question'])
        : null;
    customQuestion = json['custom_question'] != null
        ? new QuestionDetails.fromJson(json['custom_question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fixQuestion != null) {
      data['fix_question'] = this.fixQuestion.toJson();
    }
    if (this.customQuestion != null) {
      data['custom_question'] = this.customQuestion.toJson();
    }
    return data;
  }
}
