import 'package:fullmarks/models/UserResponse.dart';

class LeaderBoardResponse {
  int code;
  String message;
  List<Customer> result;

  LeaderBoardResponse({this.code, this.message, this.result});

  LeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<Customer>();
      json['result'].forEach((v) {
        result.add(new Customer.fromJson(v));
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
