import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? username;
  String? userEmail;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    return _token;
  }

  void logout() async {
    //print('logging out..');
    _token = null;
    // userEmail = null;
    // username = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("id");
    notifyListeners();
  }
}
