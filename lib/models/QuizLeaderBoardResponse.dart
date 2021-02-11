import 'package:fullmarks/models/UserResponse.dart';

class QuizLeaderBoardResponse {
  int code;
  String message;
  List<QuizLeaderBoardDetails> result;

  QuizLeaderBoardResponse({this.code, this.message, this.result});

  QuizLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<QuizLeaderBoardDetails>();
      json['result'].forEach((v) {
        result.add(new QuizLeaderBoardDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizLeaderBoardDetails {
  int correct;
  int incorrect;
  int timeTaken;
  String avgTime;
  int accuracy;
  int totalMarks;
  int points;
  int rank;
  Customer user;

  QuizLeaderBoardDetails(
      {this.correct,
      this.incorrect,
      this.timeTaken,
      this.avgTime,
      this.accuracy,
      this.totalMarks,
      this.points,
      this.rank,
      this.user});

  QuizLeaderBoardDetails.fromJson(Map<String, dynamic> json) {
    correct = json['correct'] ?? 0;
    incorrect = json['incorrect'] ?? 0;
    timeTaken = json['time_taken'] ?? 0;
    avgTime = json['avg_time'] ?? "";
    accuracy = json['accuracy'] ?? 0;
    totalMarks = json['total_marks'] ?? 0;
    points = json['points'] ?? 0;
    rank = json['rank'] ?? 0;
    user = json['user'] != null ? new Customer.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    data['time_taken'] = this.timeTaken;
    data['avg_time'] = this.avgTime;
    data['accuracy'] = this.accuracy;
    data['total_marks'] = this.totalMarks;
    data['points'] = this.points;
    data['rank'] = this.rank;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
