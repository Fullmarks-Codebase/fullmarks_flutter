import 'package:fullmarks/models/UserResponse.dart';

class RandomQuizParticipantsResponse {
  List<RandomQuizParticipantsDetails> users;

  RandomQuizParticipantsResponse({this.users});

  RandomQuizParticipantsResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<RandomQuizParticipantsDetails>();
      json['users'].forEach((v) {
        users.add(new RandomQuizParticipantsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RandomQuizParticipantsDetails {
  int id;
  String socketId;
  int status;
  int room;
  int points;
  int completed;
  String createdAt;
  String updatedAt;
  int userId;
  int subjectId;
  int classId;
  Customer user;

  RandomQuizParticipantsDetails(
      {this.id,
      this.socketId,
      this.status,
      this.room,
      this.points,
      this.completed,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.subjectId,
      this.classId,
      this.user});

  RandomQuizParticipantsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    socketId = json['socket_id'] ?? "";
    status = json['status'] ?? 0;
    room = json['room'] ?? 0;
    points = json['points'] ?? 0;
    completed = json['completed'] ?? 90;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    userId = json['userId'] ?? 0;
    subjectId = json['subjectId'] ?? 0;
    classId = json['classId'] ?? 0;
    user = json['user'] != null ? new Customer.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['socket_id'] = this.socketId;
    data['status'] = this.status;
    data['room'] = this.room;
    data['points'] = this.points;
    data['completed'] = this.completed;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['subjectId'] = this.subjectId;
    data['classId'] = this.classId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
