class MyFriendsResponse {
  int code;
  String message;
  List<MyFriendsDetails> result;

  MyFriendsResponse({this.code, this.message, this.result});

  MyFriendsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = new List<MyFriendsDetails>();
      json['result'].forEach((v) {
        result.add(new MyFriendsDetails.fromJson(v));
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

class MyFriendsDetails {
  String phoneNumber;
  String userProfileImage;
  String username;
  int id;
  String thumbnail;

  MyFriendsDetails(
      {this.phoneNumber,
      this.userProfileImage,
      this.username,
      this.id,
      this.thumbnail});

  MyFriendsDetails.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'] ?? "";
    userProfileImage = json['userProfileImage'] ?? "";
    username = json['username'] ?? "";
    id = json['id'] ?? 0;
    thumbnail = json['thumbnail'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['userProfileImage'] = this.userProfileImage;
    data['username'] = this.username;
    data['id'] = this.id;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
