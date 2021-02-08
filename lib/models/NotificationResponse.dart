class NotificationResponse {
  int code;
  String message;
  List<NotificationDetails> result;

  NotificationResponse({this.code, this.message, this.result});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<NotificationDetails>();
      json['result'].forEach((v) {
        result.add(new NotificationDetails.fromJson(v));
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

class NotificationDetails {
  int id;
  String title;
  String body;
  bool status;
  String createdAt;
  String updatedAt;
  int userId;
  int room;

  NotificationDetails(
      {this.id,
      this.title,
      this.body,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.room,
      this.userId});

  NotificationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    body = json['body'] ?? "";
    status = json['status'] ?? false;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    userId = json['userId'] ?? 0;
    room = json['room'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['room'] = this.room;
    return data;
  }
}
