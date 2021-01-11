class SetsResponse {
  int code;
  String message;
  List<SetDetails> result;

  SetsResponse({this.code, this.message, this.result});

  SetsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<SetDetails>();
      json['result'].forEach((v) {
        result.add(new SetDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code ?? 0;
    data['message'] = this.message ?? "";
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SetDetails {
  int id;
  String name;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;
  int topicId;
  int subjectId;
  int classId;
  bool submitted;

  SetDetails({
    this.id,
    this.name,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.topicId,
    this.subjectId,
    this.submitted,
    this.classId,
  });

  SetDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    createdBy = json['createdBy'] ?? 0;
    updatedBy = json['updatedBy'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    topicId = json['topicId'] ?? 0;
    subjectId = json['subjectId'] ?? 0;
    classId = json['classId'] ?? 0;
    submitted = json['submitted'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['topicId'] = this.topicId;
    data['subjectId'] = this.subjectId;
    data['classId'] = this.classId;
    data['submitted'] = this.submitted;
    return data;
  }
}
