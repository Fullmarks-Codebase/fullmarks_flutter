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
  Customer user;

  LiveQuizUsersDetails({this.user});

  LiveQuizUsersDetails.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new Customer.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
