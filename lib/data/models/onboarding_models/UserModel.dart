import '../../../ui/utils/constant.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.avatar,
    required this.roleId,
    required this.apitoken,
  });

  int? id;
  String? email, name, address, avatar, roleId, apitoken;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    address = json['address'];
    name = json['name'];
    avatar = json['avatar'] ?? imagePath;
    roleId = json['roleId'];
    apitoken = json['apitoken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['name'] = name;
    _data['address'] = address;
    _data['avatar'] = avatar;
    _data['role_id'] = roleId;
    _data['apitoken'] = apitoken;
    return _data;
  }
}

class ForgotPasswordModel {
  int? status;
  bool? success;
  String? message;

  ForgotPasswordModel({this.status, this.success, this.message});

  factory ForgotPasswordModel.formJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
        status: json['status'],
        success: json['success'],
        message: json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['status'] = status;
    _data['success'] = success;
    _data['message'] = message;
    return _data;
  }
}
