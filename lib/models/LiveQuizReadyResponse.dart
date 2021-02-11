class LiveQuizReadyResponse {
  int participants;
  String message;

  LiveQuizReadyResponse({this.participants, this.message});

  LiveQuizReadyResponse.fromJson(Map<String, dynamic> json) {
    participants = json['participants'] ?? -1;
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['participants'] = this.participants;
    data['message'] = this.message;
    return data;
  }
}
