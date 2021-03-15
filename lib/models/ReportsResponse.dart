import 'package:fullmarks/models/QuestionsResponse.dart';

class ReportsResponse {
  int code;
  String message;
  ReportResult result;

  ReportsResponse({this.code, this.message, this.result});

  ReportsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result = json['result'] != null
        ? new ReportResult.fromJson(json['result'])
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

class ReportResult {
  ReportDetails submitReport;
  User user;

  ReportResult({this.submitReport, this.user});

  ReportResult.fromJson(Map<String, dynamic> json) {
    submitReport = json['submitReport'] != null
        ? new ReportDetails.fromJson(json['submitReport'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.submitReport != null) {
      data['submitReport'] = this.submitReport.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class ReportDetails {
  String correct;
  String incorrect;
  String skipped;
  String accuracy;
  String timeTaken;
  String avgTime;
  String totalMarks;
  List<ReportDetail> reportDetail;

  ReportDetails({
    this.correct,
    this.incorrect,
    this.skipped,
    this.accuracy,
    this.timeTaken,
    this.avgTime,
    this.totalMarks,
    this.reportDetail,
  });

  ReportDetails.fromJson(Map<String, dynamic> json) {
    correct = json['correct'].toString() ?? "";
    incorrect = json['incorrect'].toString() ?? "";
    skipped = json['skipped'].toString() ?? "";
    accuracy = json['accuracy'].toString() ?? "";
    timeTaken = json['time_taken'].toString() ?? "";
    avgTime = json['avg_time'].toString() ?? "";
    totalMarks = json['total_marks'].toString() ?? "";
    if (json['questions'] != null) {
      reportDetail = new List<ReportDetail>();
      json['questions'].forEach((v) {
        reportDetail.add(new ReportDetail.fromJson(v));
      });
    }
    if (json['reportDetail'] != null) {
      reportDetail = new List<ReportDetail>();
      json['reportDetail'].forEach((v) {
        reportDetail.add(new ReportDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    data['skipped'] = this.skipped;
    data['accuracy'] = this.accuracy;
    data['time_taken'] = this.timeTaken;
    data['avg_time'] = this.avgTime;
    data['total_marks'] = this.totalMarks;
    if (this.reportDetail != null) {
      data['reportDetail'] = this.reportDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportDetail {
  int id;
  String userAnswer;
  int timeTaken;
  String correctAnswer;
  String createdAt;
  String updatedAt;
  int userId;
  int classId;
  int subjectId;
  int topicId;
  int setId;
  int questionId;
  int reportId;
  QuestionDetails question;
  int mockReportMasterId;
  int mockId;

  ReportDetail(
      {this.id,
      this.userAnswer,
      this.timeTaken,
      this.correctAnswer,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.classId,
      this.subjectId,
      this.topicId,
      this.mockReportMasterId,
      this.mockId,
      this.setId,
      this.questionId,
      this.reportId,
      this.question});

  ReportDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userAnswer = json['user_answer'];
    timeTaken = json['time_taken'];
    correctAnswer = json['correct_answer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    classId = json['classId'];
    subjectId = json['subjectId'];
    topicId = json['topicId'];
    setId = json['setId'];
    questionId = json['questionId'];
    reportId = json['reportId'];
    mockReportMasterId = json['mockReportMasterId'];
    mockId = json['mockId'];
    question = json['question'] != null
        ? new QuestionDetails.fromJson(json['question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_answer'] = this.userAnswer;
    data['time_taken'] = this.timeTaken;
    data['correct_answer'] = this.correctAnswer;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['classId'] = this.classId;
    data['subjectId'] = this.subjectId;
    data['topicId'] = this.topicId;
    data['setId'] = this.setId;
    data['questionId'] = this.questionId;
    data['reportId'] = this.reportId;
    data['mockReportMasterId'] = this.mockReportMasterId;
    data['mockId'] = this.mockId;
    if (this.question != null) {
      data['question'] = this.question.toJson();
    }
    return data;
  }
}

class User {
  int id;

  User({this.id});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
