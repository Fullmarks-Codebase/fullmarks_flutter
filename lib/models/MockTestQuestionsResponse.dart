import 'package:fullmarks/models/MockTestResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';

class MockTestQuestionsResponse {
  int code;
  String message;
  MockTestQuestionDetails result;

  MockTestQuestionsResponse({this.code, this.message, this.result});

  MockTestQuestionsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    result = json['result'] != null
        ? new MockTestQuestionDetails.fromJson(json['result'])
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

class MockTestQuestionDetails {
  List<QuestionDetails> questions;
  MockTestDetails mock;

  MockTestQuestionDetails({this.questions, this.mock});

  MockTestQuestionDetails.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = new List<QuestionDetails>();
      json['questions'].forEach((v) {
        questions.add(new QuestionDetails.fromJson(v));
      });
    }
    mock = json['mock'] != null
        ? new MockTestDetails.fromJson(json['mock'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    if (this.mock != null) {
      data['mock'] = this.mock.toJson();
    }
    return data;
  }
}
