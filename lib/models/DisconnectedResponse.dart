import 'UserResponse.dart';

class DisconnectedResponse {
  String message;
  Users users;

  DisconnectedResponse({this.message, this.users});

  DisconnectedResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.users != null) {
      data['users'] = this.users.toJson();
    }
    return data;
  }
}

class Users {
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

  Users(
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

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    socketId = json['socket_id'] ?? "";
    status = json['status'] ?? 0;
    room = json['room'] ?? 0;
    points = json['points'] ?? 0;
    completed = json['completed'] ?? 0;
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
