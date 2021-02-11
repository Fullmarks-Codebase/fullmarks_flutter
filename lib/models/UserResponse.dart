import 'package:fullmarks/models/ClassResponse.dart';

class UserResponse {
  int code;
  String message;
  Customer result;

  UserResponse({this.code, this.message, this.result});

  UserResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
        json['result'] != null ? new Customer.fromJson(json['result']) : null;
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

class Customer {
  int id;
  String username;
  String phoneNumber;
  String email;
  String otp;
  String dob;
  String userProfileImage;
  String thumbnail;
  int gender;
  String createdAt;
  String updatedAt;
  String token;
  ClassDetails classGrades;
  String googleId;
  String facebookId;
  String phoneId;
  bool submitted;
  int score;
  int buddies;
  List<ReportMaster> reportMaster;

  Customer({
    this.id,
    this.username,
    this.phoneNumber,
    this.email,
    this.otp,
    this.dob,
    this.userProfileImage,
    this.thumbnail,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.classGrades,
    this.googleId,
    this.facebookId,
    this.phoneId,
    this.submitted,
    this.score,
    this.buddies,
    this.reportMaster,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    username = json['username'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
    email = json['email'] ?? "";
    otp = json['otp'] ?? "";
    dob = json['dob'] ?? "";
    userProfileImage = json['userProfileImage'] ?? "";
    thumbnail = json['thumbnail'] ?? "";
    gender = json['gender'] ?? -1;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    token = json['token'] ?? "";
    classGrades =
        json['class'] != null ? new ClassDetails.fromJson(json['class']) : null;
    googleId = json['googleId'] ?? "";
    facebookId = json['facebookId'] ?? "";
    phoneId = json['phoneId'] ?? "";
    submitted = json['submitted'] ?? false;
    score = json['score'] ?? 0;
    buddies = json['buddies'] ?? 0;
    if (json['reportMaster'] != null) {
      reportMaster = new List<ReportMaster>();
      json['reportMaster'].forEach((v) {
        reportMaster.add(new ReportMaster.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['otp'] = this.otp;
    data['dob'] = this.dob;
    data['userProfileImage'] = this.userProfileImage;
    data['thumbnail'] = this.thumbnail;
    data['gender'] = this.gender;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['token'] = this.token;
    if (this.classGrades != null) {
      data['class'] = this.classGrades.toJson();
    }
    data['googleId'] = this.googleId;
    data['facebookId'] = this.facebookId;
    data['phoneId'] = this.phoneId;
    data['submitted'] = this.submitted;
    data['score'] = this.score;
    data['buddies'] = this.buddies;
    if (this.reportMaster != null) {
      data['reportMaster'] = this.reportMaster.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportMaster {
  int rank;
  String points;
  int gamePlayed;

  ReportMaster({this.rank, this.points, this.gamePlayed});

  ReportMaster.fromJson(Map<String, dynamic> json) {
    rank = json['rank'] ?? 0;
    points = json['points'] ?? 0;
    gamePlayed = json['game_played'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['points'] = this.points;
    data['game_played'] = this.gamePlayed;
    return data;
  }
}
