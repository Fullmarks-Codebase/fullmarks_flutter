import 'package:fullmarks/models/SubjectsResponse.dart';

import 'SetsResponse.dart';
import 'SubtopicResponse.dart';

class SetReportResponse {
  int code;
  String message;
  List<SetReportDetails> result;

  SetReportResponse({this.code, this.message, this.result});

  SetReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<SetReportDetails>();
      json['result'].forEach((v) {
        result.add(new SetReportDetails.fromJson(v));
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

class SetReportDetails {
  String correct;
  String incorrect;
  String timeTaken;
  SubjectDetails subject;
  SubtopicDetails topic;
  SetDetails setDetails;
  String accuracy;
  String avgTime;

  SetReportDetails({
    this.correct,
    this.incorrect,
    this.timeTaken,
    this.subject,
    this.topic,
    this.setDetails,
    this.accuracy,
    this.avgTime,
  });

  SetReportDetails.fromJson(Map<String, dynamic> json) {
    correct = json['correct'] ?? "";
    incorrect = json['incorrect'] ?? "";
    timeTaken = json['time_taken'] ?? "";
    subject = json['subject'] != null
        ? new SubjectDetails.fromJson(json['subject'])
        : null;
    topic = json['topic'] != null
        ? new SubtopicDetails.fromJson(json['topic'])
        : null;
    setDetails =
        json['set'] != null ? new SetDetails.fromJson(json['set']) : null;
    accuracy = json['accuracy'] ?? "";
    avgTime = json['avg_time'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    data['time_taken'] = this.timeTaken;
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    if (this.topic != null) {
      data['topic'] = this.topic.toJson();
    }
    if (this.setDetails != null) {
      data['set'] = this.setDetails.toJson();
    }
    data['accuracy'] = this.accuracy;
    data['avg_time'] = this.avgTime;
    return data;
  }
}
