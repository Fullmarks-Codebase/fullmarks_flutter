class MockTestResponse {
  int code;
  String message;
  List<MockTestDetails> result;

  MockTestResponse({this.code, this.message, this.result});

  MockTestResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<MockTestDetails>();
      json['result'].forEach((v) {
        result.add(new MockTestDetails.fromJson(v));
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

class MockTestDetails {
  int id;
  String name;
  int time;
  String createdAt;
  String updatedAt;
  int classId;
  int submitted;
  int questionCount;

  MockTestDetails(
      {this.id,
      this.name,
      this.time,
      this.createdAt,
      this.updatedAt,
      this.classId,
      this.submitted,
      this.questionCount});

  MockTestDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    time = json['time'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    classId = json['classId'] ?? 0;
    submitted = json['submitted'] ?? 0;
    questionCount = json['question_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.time;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['classId'] = this.classId;
    data['submitted'] = this.submitted;
    data['question_count'] = this.questionCount;
    return data;
  }
}
