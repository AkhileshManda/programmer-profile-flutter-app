import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate; //expiry date of token
  String? _userId;
  Timer? _authTimer;
  String? username;
  String? userEmail;
  
  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null && 
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null)
      return _token;
    else
      return null;
  }

  Future<void> login(String? email, String? password) async {
    final url = Uri.parse('');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }));
    print(response.statusCode);
    final extractedData = json.decode(response.body);
   
    if (response.statusCode >= 400) {
      print('inside throwing');
      throw HttpException(extractedData['error_message']);
    }
    var timestamp = (extractedData['expire_at']);
    DateTime date = DateTime.parse(timestamp);
    
    _token = extractedData['key'];
    _expiryDate = date;
    _userId = extractedData['pk'].toString();
    
    //handling autologin from here
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate!.toIso8601String(),
    });
    prefs.setString('userData', userData);
    await getUser();
    _autoLogout();
    
    notifyListeners();
  }

  Future<void> register(
      String? email, String? username, String? password) async {
    final url = Uri.parse('https://itsrandom.cf/api/v1/register/');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Token {token}',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }));

    print("printing request: ");
    // print(response.statusCode);
    // print(json.decode(response.body));
    final extractedData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(extractedData['error_message']);
    }
    // print(extractedData['expire_at']);
    var timestamp = extractedData['expire_at'];
    DateTime date = DateTime.parse(timestamp);
    // print(date);
    _token = extractedData['key'];
    _expiryDate = date;
    _userId = extractedData['pk'].toString();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate!.toIso8601String(),
    });
    prefs.setString('userData', userData);
    await getUser();
    _autoLogout();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print('trying auto login..');
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData') as String)
        as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _expiryDate = expiryDate;
    await getUser();
    _autoLogout();
    notifyListeners();
    return true;
  }

  void logout() async {
    print('logging out..');
    _token = null;
    _userId = null;
    _expiryDate = null;
    userEmail = null;
    username = null;
    if (_authTimer != null) {
      //because if we loggin back immediately then old timer will continue
      // hence we need to first destroy old timer
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds ?? 1;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> getUser() async {
    final url = Uri.parse('');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${_token}',
      },
    );
    final extractedData = json.decode(response.body);
    username = extractedData['username'];
    userEmail = extractedData['email'];
  }
}