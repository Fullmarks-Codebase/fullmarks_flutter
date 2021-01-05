class SubjectsResponse {
  int code;
  String message;
  List<SubjectDetails> result;

  SubjectsResponse({this.code, this.message, this.result});

  SubjectsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<SubjectDetails>();
      json['result'].forEach((v) {
        result.add(new SubjectDetails.fromJson(v));
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

class SubjectDetails {
  int id;
  String name;
  String detail;
  String image;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;

  SubjectDetails(
      {this.id,
      this.name,
      this.detail,
      this.image,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  SubjectDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    detail = json['detail'] ?? "";
    image = json['image'] ?? "";
    createdBy = json['createdBy'] ?? 0;
    updatedBy = json['updatedBy'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['image'] = this.image;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
