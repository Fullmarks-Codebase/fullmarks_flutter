import 'ClassResponse.dart';

class GuestUserResponse {
  int code;
  String message;
  GuestUserDetails result;

  GuestUserResponse({this.code, this.message, this.result});

  GuestUserResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result = json['result'] != null
        ? new GuestUserDetails.fromJson(json['result'])
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

class GuestUserDetails {
  int id;
  String imei;
  int played;
  ClassDetails classGrades;
  String createdAt;
  String updatedAt;

  GuestUserDetails({
    this.id,
    this.imei,
    this.played,
    this.classGrades,
    this.createdAt,
    this.updatedAt,
  });

  GuestUserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    imei = json['imei'] ?? "";
    played = json['played'] ?? -1;
    classGrades =
        json['class'] != null ? new ClassDetails.fromJson(json['class']) : null;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imei'] = this.imei;
    data['played'] = this.played;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.classGrades != null) {
      data['class'] = this.classGrades.toJson();
    }
    return data;
  }
}
