class CheckinResponse {
  Message message;

  CheckinResponse({this.message});

  CheckinResponse.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    return data;
  }
}

class Message {
  int otpSend;
  String phoneNumber;

  Message({this.otpSend, this.phoneNumber});

  Message.fromJson(Map<String, dynamic> json) {
    otpSend = json['otp_send'] ?? -1;
    phoneNumber = json['phoneNumber'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp_send'] = this.otpSend;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
