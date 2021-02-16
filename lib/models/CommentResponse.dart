import 'UserResponse.dart';

class CommentResponse {
  int code;
  String message;
  List<CommentDetails> result;

  CommentResponse({this.code, this.message, this.result});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<CommentDetails>();
      json['result'].forEach((v) {
        result.add(new CommentDetails.fromJson(v));
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

class CommentDetails {
  int id;
  String comment;
  String commentImage;
  int likes;
  String createdAt;
  String updatedAt;
  int postId;
  int userId;
  String posted;
  int liked;
  Customer user;

  CommentDetails(
      {this.id,
      this.comment,
      this.commentImage,
      this.likes,
      this.createdAt,
      this.updatedAt,
      this.postId,
      this.userId,
      this.posted,
      this.liked,
      this.user});

  CommentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    comment = json['comment'] ?? "";
    commentImage = json['comment_image'] ?? "";
    likes = json['likes'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    postId = json['postId'] ?? 0;
    userId = json['userId'] ?? 0;
    posted = json['posted'] ?? "";
    liked = json['liked'] ?? 0;
    user = json['user'] != null ? new Customer.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['comment_image'] = this.commentImage;
    data['likes'] = this.likes;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['postId'] = this.postId;
    data['userId'] = this.userId;
    data['posted'] = this.posted;
    data['liked'] = this.liked;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
