class UserResponse {
  Customer customer;

  UserResponse({this.customer});

  UserResponse.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  int id;
  String username;
  String phoneNumber;
  String email;
  String otp;
  String dob;
  String userProfileImage;
  String gender;
  String createdAt;
  String updatedAt;

  Customer(
      {this.id,
      this.username,
      this.phoneNumber,
      this.email,
      this.otp,
      this.dob,
      this.userProfileImage,
      this.gender,
      this.createdAt,
      this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    username = json['username'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
    email = json['email'] ?? "";
    otp = json['otp'] ?? "";
    dob = json['dob'] ?? "";
    userProfileImage = json['userProfileImage'] ?? "";
    gender = json['gender'] ?? "";
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['otp'] = this.otp;
    data['dob'] = this.dob;
    data['userProfileImage'] = this.userProfileImage;
    data['gender'] = this.gender;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
