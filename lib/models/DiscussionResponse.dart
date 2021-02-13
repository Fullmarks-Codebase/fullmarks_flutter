import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';

class DiscussionResponse {
  int code;
  String message;
  List<DiscussionDetails> result;

  DiscussionResponse({this.code, this.message, this.result});

  DiscussionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<DiscussionDetails>();
      json['result'].forEach((v) {
        result.add(new DiscussionDetails.fromJson(v));
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

class DiscussionDetails {
  int id;
  String question;
  String questionImage;
  int likes;
  int comments;
  String createdAt;
  String updatedAt;
  int subjectId;
  int userId;
  String posted;
  int liked;
  int save;
  Customer user;
  SubjectDetails subject;

  DiscussionDetails(
      {this.id,
      this.question,
      this.questionImage,
      this.likes,
      this.comments,
      this.createdAt,
      this.updatedAt,
      this.subjectId,
      this.userId,
      this.posted,
      this.liked,
      this.save,
      this.user,
      this.subject});

  DiscussionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionImage = json['question_image'];
    likes = json['likes'];
    comments = json['comments'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    subjectId = json['subjectId'];
    userId = json['userId'];
    posted = json['posted'];
    liked = json['liked'];
    save = json['save'];
    user = json['user'] != null ? new Customer.fromJson(json['user']) : null;
    subject = json['subject'] != null
        ? new SubjectDetails.fromJson(json['subject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['question'] = this.question ?? "";
    data['question_image'] = this.questionImage ?? "";
    data['likes'] = this.likes ?? 0;
    data['comments'] = this.comments ?? 0;
    data['createdAt'] = this.createdAt ?? "";
    data['updatedAt'] = this.updatedAt ?? "";
    data['subjectId'] = this.subjectId ?? 0;
    data['userId'] = this.userId ?? 0;
    data['posted'] = this.posted ?? "";
    data['liked'] = this.liked ?? 0;
    data['save'] = this.save ?? 0;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    return data;
  }
}
