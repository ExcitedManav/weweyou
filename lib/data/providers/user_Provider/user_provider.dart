import 'package:flutter/material.dart';

import '../../models/onboarding_models/UserModel.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? userData;
  void setUserData(UserModel user) {
    userData = user;
    notifyListeners();
  }
}
