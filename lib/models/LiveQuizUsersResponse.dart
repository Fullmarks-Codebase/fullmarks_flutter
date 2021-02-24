import 'package:fullmarks/models/UserResponse.dart';

class LiveQuizUsersResponse {
  List<LiveQuizUsersDetails> users;
  int participants;

  LiveQuizUsersResponse({this.users, this.participants});

  LiveQuizUsersResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<LiveQuizUsersDetails>();
      json['users'].forEach((v) {
        users.add(new LiveQuizUsersDetails.fromJson(v));
      });
    }
    participants = json['participants'] ?? -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['participants'] = this.participants;
    return data;
  }
}

class LiveQuizUsersDetails {
  int id;
  int score;
  String socketId;
  bool submitted;
  Customer user;

  LiveQuizUsersDetails(
      {this.id, this.score, this.socketId, this.submitted, this.user});

  LiveQuizUsersDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    score = json['score'] ?? 0;
    socketId = json['socket_id'] ?? "";
    submitted = json['submitted'] ?? false;
    user = json['user'] != null ? new Customer.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['score'] = this.score;
    data['socket_id'] = this.socketId;
    data['submitted'] = this.submitted;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
