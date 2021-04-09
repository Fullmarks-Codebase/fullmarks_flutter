import 'package:fullmarks/models/SubjectsResponse.dart';

import 'ClassResponse.dart';

class QuestionsResponse {
  int code;
  String message;
  List<QuestionDetails> result;

  QuestionsResponse({this.code, this.message, this.result});

  QuestionsResponse.fromJson(Map<String, dynamic> json) {
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

class QuestionDetails {
  int id;
  String question;
  String questionImage;
  String ansOne;
  String ansOneImage;
  bool ansOneStatus;
  String ansTwo;
  String ansTwoImage;
  bool ansTwoStatus;
  String ansThree;
  String ansThreeImage;
  bool ansThreeStatus;
  String ansFour;
  String ansFourImage;
  bool ansFourStatus;
  int createdBy;
  int updatedBy;
  int difficultyLevel;
  String createdAt;
  String updatedAt;
  int topicId;
  int subjectId;
  int setId;
  int classId;
  int selectedAnswer;
  int timeTaken;
  int customMasterId;
  int time;
  int mockId;
  ClassDetails classGrades;
  SubjectDetails subject;
  CustomMaster customMaster;

  QuestionDetails({
    this.id,
    this.question,
    this.questionImage,
    this.ansOne,
    this.ansOneImage,
    this.ansOneStatus,
    this.ansTwo,
    this.ansTwoImage,
    this.ansTwoStatus,
    this.ansThree,
    this.ansThreeImage,
    this.ansThreeStatus,
    this.ansFour,
    this.ansFourImage,
    this.ansFourStatus,
    this.createdBy,
    this.updatedBy,
    this.difficultyLevel,
    this.createdAt,
    this.updatedAt,
    this.topicId,
    this.subjectId,
    this.setId,
    this.classId,
    this.selectedAnswer,
    this.timeTaken,
    this.time,
    this.customMasterId,
    this.mockId,
    this.classGrades,
    this.subject,
    this.customMaster,
  });

  QuestionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    question = json['question'] ?? "";
    questionImage = json['question_image'] ?? "";
    ansOne = json['ans_one'] ?? "";
    ansOneImage = json['ans_one_image'] ?? "";
    ansOneStatus = json['ans_one_status'] ?? false;
    ansTwo = json['ans_two'] ?? "";
    ansTwoImage = json['ans_two_image'] ?? "";
    ansTwoStatus = json['ans_two_status'] ?? false;
    ansThree = json['ans_three'] ?? "";
    ansThreeImage = json['ans_three_image'] ?? "";
    ansThreeStatus = json['ans_three_status'] ?? false;
    ansFour = json['ans_four'] ?? "";
    ansFourImage = json['ans_four_image'] ?? "";
    ansFourStatus = json['ans_four_status'] ?? false;
    createdBy = json['createdBy'] ?? 0;
    updatedBy = json['updatedBy'] ?? 0;
    difficultyLevel = json['difficulty_level'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    topicId = json['topicId'] ?? 0;
    subjectId = json['subjectId'] ?? 0;
    setId = json['setId'] ?? 0;
    classId = json['classId'] ?? 0;
    selectedAnswer = json['selectedAnswer'] ?? -1;
    timeTaken = json['timeTaken'] ?? 0;
    time = json['time'] ?? 0;
    customMasterId = json['customMasterId'] ?? 0;
    mockId = json['mockId'];
    try {
      classGrades = json['class'] != null
          ? new ClassDetails.fromJson(json['class'])
          : null;
    } catch (e) {}
    try {
      subject = json['subject'] != null
          ? new SubjectDetails.fromJson(json['subject'])
          : null;
    } catch (e) {}
    try {
      customMaster = json['customMaster'] != null
          ? new CustomMaster.fromJson(json['customMaster'])
          : null;
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['question_image'] = this.questionImage;
    data['ans_one'] = this.ansOne;
    data['ans_one_image'] = this.ansOneImage;
    data['ans_one_status'] = this.ansOneStatus;
    data['ans_two'] = this.ansTwo;
    data['ans_two_image'] = this.ansTwoImage;
    data['ans_two_status'] = this.ansTwoStatus;
    data['ans_three'] = this.ansThree;
    data['ans_three_image'] = this.ansThreeImage;
    data['ans_three_status'] = this.ansThreeStatus;
    data['ans_four'] = this.ansFour;
    data['ans_four_image'] = this.ansFourImage;
    data['ans_four_status'] = this.ansFourStatus;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['difficulty_level'] = this.difficultyLevel;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['topicId'] = this.topicId;
    data['subjectId'] = this.subjectId;
    data['setId'] = this.setId;
    data['classId'] = this.classId;
    data['selectedAnswer'] = this.selectedAnswer;
    data['timeTaken'] = this.timeTaken;
    data['time'] = this.time;
    data['customMasterId'] = this.customMasterId;
    data['mockId'] = this.mockId;
    if (this.classGrades != null) {
      data['class'] = this.classGrades.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject.toJson();
    }
    if (this.customMaster != null) {
      data['customMaster'] = this.customMaster.toJson();
    }
    return data;
  }
}

class CustomMaster {
  int id;
  String name;
  int createdBy;
  String createdAt;
  String updatedAt;
  int classId;
  int userId;
  ClassDetails classDetails;

  CustomMaster({
    this.id,
    this.name,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.classId,
    this.userId,
    this.classDetails,
  });

  CustomMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    classId = json['classId'];
    userId = json['userId'];
    classDetails =
        json['class'] != null ? new ClassDetails.fromJson(json['class']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['name'] = this.name ?? "";
    data['createdBy'] = this.createdBy ?? 0;
    data['createdAt'] = this.createdAt ?? "";
    data['updatedAt'] = this.updatedAt ?? "";
    data['classId'] = this.classId ?? 0;
    data['userId'] = this.userId ?? 0;
    if (this.classDetails != null) {
      data['class'] = this.classDetails.toJson();
    }
    return data;
  }
}
