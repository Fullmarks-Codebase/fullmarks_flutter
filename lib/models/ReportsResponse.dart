class ReportsResponse {
  int code;
  String message;
  ReportDetails result;

  ReportsResponse({this.code, this.message, this.result});

  ReportsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result = json['result'] != null
        ? new ReportDetails.fromJson(json['result'])
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

class ReportDetails {
  String correct;
  String incorrect;
  String accuracy;
  String timeTaken;
  String avgTime;
  String totalMarks;

  ReportDetails(
      {this.correct,
      this.incorrect,
      this.accuracy,
      this.timeTaken,
      this.avgTime,
      this.totalMarks});

  ReportDetails.fromJson(Map<String, dynamic> json) {
    correct = json['correct'].toString() ?? "";
    incorrect = json['incorrect'].toString() ?? "";
    accuracy = json['accuracy'].toString() ?? "";
    timeTaken = json['time_taken'].toString() ?? "";
    avgTime = json['avg_time'].toString() ?? "";
    totalMarks = json['total_marks'].toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    data['accuracy'] = this.accuracy;
    data['time_taken'] = this.timeTaken;
    data['avg_time'] = this.avgTime;
    data['total_marks'] = this.totalMarks;
    return data;
  }
}
