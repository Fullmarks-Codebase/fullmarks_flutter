class CommonResponse {
  int code;
  String message;

  CommonResponse({this.code, this.message});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 403;
    message = json['message'] ?? "Something went wrong";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
