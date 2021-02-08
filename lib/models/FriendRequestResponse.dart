class FriendRequestResponse {
  int code;
  String message;
  List<FriendRequestDetails> result;

  FriendRequestResponse({this.code, this.message, this.result});

  FriendRequestResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<FriendRequestDetails>();
      json['result'].forEach((v) {
        result.add(new FriendRequestDetails.fromJson(v));
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

class FriendRequestDetails {
  int id;
  int status;
  String createdAt;
  String updatedAt;
  int fromId;
  int toId;
  RequestFriendDetails from;
  RequestFriendDetails to;

  FriendRequestDetails({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.fromId,
    this.toId,
    this.from,
    this.to,
  });

  FriendRequestDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    status = json['status'] ?? -1;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    fromId = json['fromId'] ?? 0;
    toId = json['toId'] ?? 0;
    from = json['from'] != null
        ? new RequestFriendDetails.fromJson(json['from'])
        : null;
    to = json['to'] != null
        ? new RequestFriendDetails.fromJson(json['to'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['fromId'] = this.fromId;
    data['toId'] = this.toId;
    if (this.from != null) {
      data['from'] = this.from.toJson();
    }
    if (this.to != null) {
      data['to'] = this.to.toJson();
    }
    return data;
  }
}

class RequestFriendDetails {
  int id;
  String username;
  String userProfileImage;
  String thumbnail;

  RequestFriendDetails(
      {this.id, this.username, this.userProfileImage, this.thumbnail});

  RequestFriendDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    username = json['username'] ?? "";
    userProfileImage = json['userProfileImage'] ?? "";
    thumbnail = json['thumbnail'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['userProfileImage'] = this.userProfileImage;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
