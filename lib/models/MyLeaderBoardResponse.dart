import 'package:fullmarks/models/UserResponse.dart';

class MyLeaderBoardResponse {
  int code;
  String message;
  Customer result;

  MyLeaderBoardResponse({this.code, this.message, this.result});

  MyLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result =
        json['result'] != null ? new Customer.fromJson(json['result']) : null;
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
