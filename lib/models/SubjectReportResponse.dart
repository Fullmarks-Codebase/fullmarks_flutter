import 'package:fullmarks/models/SubjectsResponse.dart';

class SubjectReportResponse {
  int code;
  String message;
  List<SubjectReportDetails> result;

  SubjectReportResponse({this.code, this.message, this.result});

  SubjectReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<SubjectReportDetails>();
      json['result'].forEach((v) {
        result.add(new SubjectReportDetails.fromJson(v));
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

class SubjectReportDetails {
  int classId;
  String correct;
  String incorrect;
  String skipped;
  String timeTaken;
  SubjectDetails subject;
  String accuracy;
  String avgTime;

  SubjectReportDetails(
      {this.classId,
      this.correct,
      this.incorrect,
      this.skipped,
      this.timeTaken,
      this.subject,
      this.accuracy,
      this.avgTime});

  SubjectReportDetails.fromJson(Map<String, dynamic> json) {
    classId = json['classId'] ?? 0;
    correct = json['correct'] ?? "";
    incorrect = json['incorrect'] ?? "";
    skipped = json['skipped'] ?? "";
    timeTaken = json['time_taken'] ?? "";
    subject = json['subject'] != null
        ? new SubjectDetails.fromJson(json['subject'])
        : null;
    accuracy = json['accuracy'] ?? "";
    avgTime = json['avg_time'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classId'] = this.classId;
    data['correct'] = this.correct;
    data['skipped'] = this.skipped;
    data['incorrect'] = this.incorrect;
    data['time_taken'] = this.timeTaken;
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    data['accuracy'] = this.accuracy;
    data['avg_time'] = this.avgTime;
    return data;
  }
}
