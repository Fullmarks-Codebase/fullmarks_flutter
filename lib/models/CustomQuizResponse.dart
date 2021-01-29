class CustomQuizResponse {
  int code;
  String message;
  List<CustomQuizDetails> result;

  CustomQuizResponse({this.code, this.message, this.result});

  CustomQuizResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<CustomQuizDetails>();
      json['result'].forEach((v) {
        result.add(new CustomQuizDetails.fromJson(v));
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

class CustomQuizDetails {
  int id;
  String name;
  int createdBy;
  String createdAt;
  String updatedAt;
  int userId;
  int totalQuestion;

  CustomQuizDetails(
      {this.id,
      this.name,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.totalQuestion});

  CustomQuizDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    createdBy = json['createdBy'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    userId = json['userId'] ?? 0;
    totalQuestion = json['total_question'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['total_question'] = this.totalQuestion;
    return data;
  }
}
