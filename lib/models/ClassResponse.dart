class ClassResponse {
  int code;
  String message;
  List<ClassDetails> result;

  ClassResponse({this.code, this.message, this.result});

  ClassResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<ClassDetails>();
      json['result'].forEach((v) {
        result.add(new ClassDetails.fromJson(v));
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

class ClassDetails {
  int id;
  String name;
  String classImage;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;

  ClassDetails(
      {this.id,
      this.name,
      this.classImage,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  ClassDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    classImage = json['class_image'] ?? "";
    createdBy = json['createdBy'] ?? 0;
    updatedBy = json['updatedBy'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['class_image'] = this.classImage;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
