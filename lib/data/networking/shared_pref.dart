import 'package:shared_preferences/shared_preferences.dart';

Future<void> setPrefUserId(String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("USER_PREF", user);
}

Future<String> getPrefUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("USER_PREF") ?? "no user";
}

setFirstData(bool first) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("FIRST", first);
}

Future<bool> getFirstData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("FIRST") ?? true;
}

getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_Token');
}

Future<bool> setAuthToken(val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("auth_Token", val);
}

Future<bool> setValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('isLogin', true);
}

Future<bool> previewScreenVisible() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('newUser', false);
}

getLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('location');
}

Future<bool> setLocation(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('location', val);
}

getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<bool> setEmail(String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('email', val);
}
