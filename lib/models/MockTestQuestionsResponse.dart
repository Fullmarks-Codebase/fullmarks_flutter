import 'package:fullmarks/models/QuestionsResponse.dart';

class MockTestQuestionsResponse {
  int code;
  String message;
  List<QuestionDetails> result;

  MockTestQuestionsResponse({this.code, this.message, this.result});

  MockTestQuestionsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<QuestionDetails>();
      json['result'].forEach((v) {
        result.add(new QuestionDetails.fromJson(v));
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
