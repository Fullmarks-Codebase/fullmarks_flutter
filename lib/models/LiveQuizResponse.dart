import 'package:fullmarks/models/QuestionsResponse.dart';

class LiveQuizResponse {
  int code;
  String message;
  LiveQuizDetails result;

  LiveQuizResponse({this.code, this.message, this.result});

  LiveQuizResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result = json['result'] != null
        ? new LiveQuizDetails.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class LiveQuizDetails {
  LiveQuizRoom room;
  List<QuestionDetails> questions;

  LiveQuizDetails({this.room, this.questions});

  LiveQuizDetails.fromJson(Map<String, dynamic> json) {
    room =
        json['room'] != null ? new LiveQuizRoom.fromJson(json['room']) : null;
    if (json['questions'] != null) {
      questions = new List<QuestionDetails>();
      json['questions'].forEach((v) {
        questions.add(new QuestionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.room != null) {
      data['room'] = this.room.toJson();
    }
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiveQuizRoom {
  int id;
  int userId;
  String room;
  String updatedAt;
  String createdAt;
  String timeLimit;

  LiveQuizRoom({
    this.id,
    this.timeLimit,
    this.userId,
    this.room,
    this.updatedAt,
    this.createdAt,
  });

  LiveQuizRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeLimit = json['timeLimit'].toString();
    userId = json['userId'];
    room = json['room'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timeLimit'] = this.timeLimit;
    data['userId'] = this.userId;
    data['room'] = this.room;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
