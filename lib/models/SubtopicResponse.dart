class SubtopicResponse {
  int code;
  String message;
  List<SubtopicDetails> result;

  SubtopicResponse({this.code, this.message, this.result});

  SubtopicResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<SubtopicDetails>();
      json['result'].forEach((v) {
        result.add(new SubtopicDetails.fromJson(v));
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

class SubtopicDetails {
  int id;
  String name;
  String detail;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;
  int subjectId;
  String completed;

  SubtopicDetails({
    this.id,
    this.name,
    this.detail,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.completed,
    this.subjectId,
  });

  SubtopicDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    detail = json['detail'] ?? "";
    createdBy = json['createdBy'] ?? 0;
    updatedBy = json['updatedBy'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    subjectId = json['subjectId'] ?? 0;
    completed = json['completed'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['subjectId'] = this.subjectId;
    data['completed'] = this.completed;
    return data;
  }
}
