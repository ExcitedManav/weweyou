class SignInModel {
  bool? status;
  String? message;
  RecordData? recordData;

  SignInModel({this.status, this.message, this.recordData});

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      status: json['status'],
      message: json['message'],
      recordData:
          json['record'] != null ? RecordData.fromJson(json['record']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (data['record'] != null) {
      data['record'] = recordData!.toJson();
    }
    return data;
  }
}

class RecordData {
  int? id;
  String? firstName, lastName, email, fcmToken, authToken;

  RecordData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.fcmToken,
      this.authToken});

  factory RecordData.fromJson(Map<String, dynamic> json) {
    return RecordData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      fcmToken: json['fcm_token'],
      authToken: json['authtoken'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['fcm_token'] = fcmToken;
    _data['authtoken'] = authToken;

    return _data;
  }
}
