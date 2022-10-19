import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:programmerprofile/auth/controller/api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? username;
  String? userEmail;

  final EndPoint _point = EndPoint();
  
  bool get isAuth {
    return _token != null;
  }

  String? get token {
      return _token;
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
    
    //TODO: CHANGE VALUES
    _token = extractedData['key'];
    //_expiryDate = date;
    _userId = extractedData['pk'].toString();
    
    //handling autologin from here
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
    });
    prefs.setString("token", _token ?? "null");
    prefs.setString('userData', userData);
    await getUser();
       
    notifyListeners();
  }

  Future<void> register(String? email, String? username, String? password) async {
    final url = Uri.parse('');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
    
    _token = extractedData['key'];
    //_expiryDate = date;
    //TODO: CHANGE THIS
    _userId = extractedData['pk'].toString();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
    });
    prefs.setString('token', _token ?? "null");
    prefs.setString('userData', userData);
    await getUser();
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
    
    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    await getUser();
    notifyListeners();
    return true;
  }

  
  
  
  
  void logout() async {
    print('logging out..');
    _token = null;
    _userId = null;
    userEmail = null;
    username = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
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