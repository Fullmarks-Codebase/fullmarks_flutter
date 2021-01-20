class NotificationCountResponse {
  int code;
  String message;
  int result;

  NotificationCountResponse({this.code, this.message, this.result});

  NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result = json['result'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
