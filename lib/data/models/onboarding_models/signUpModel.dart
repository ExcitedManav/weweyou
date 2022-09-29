class SignUpModel {
  String? firstName,
      lastName,
      email,
      password,
      language,
      currency,
      fcmToken,
      type;

  SignUpModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.language,
    this.currency,
    this.fcmToken,
    this.type,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    SignUpModel(
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        password: json['password'],
        language: json['language'],
        currency: json['currency'],
        fcmToken: json['fcm_token'],
        type: json['web_mobile_type']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['password'] = password;
    _data['language'] = language;
    _data['currency'] = currency;
    _data['fcm_token'] = fcmToken;
    _data['web_mobile_type'] = type;
    return _data;
  }
}

class ResendConfirmationMailModel {
  bool? status;
  String? message;
  String? email;

  ResendConfirmationMailModel({this.status, this.message, this.email});

  ResendConfirmationMailModel.fromJson(Map<String, dynamic> json) {
    ResendConfirmationMailModel(
        message: json['message'], status: json['status'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['email'] = email;
    return data;
  }
}
