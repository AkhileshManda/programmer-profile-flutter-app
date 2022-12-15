import 'package:flutter/material.dart';
import 'package:programmerprofile/home/controller/apis.dart';

import '../../auth/model/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  User? get user => _user;

  UserProvider(

  );

  //heatmap
  Map<DateTime, int>? _heatMapData;
  Map<DateTime, int>? get heatMapData => _heatMapData;

  //Codeforces Data
  Map<String, List<dynamic>>? _cfdata;
  Map<String, List<dynamic>>? get cfdata => _cfdata;

  //Github Data
  Map<String, dynamic>? _githubData;
  Map<String, dynamic>? get githubData => _githubData;

  //Leetcode Data
  Map<String,dynamic>? _leetcodeData;
  Map<String,dynamic>? get leetcodeData => _leetcodeData;

  Future<void> getUserData()async{
    _user = await APIs().getUser();
    notifyListeners();
  }

  void updateUserProfilePicture(String newurl){
    _user?.profilePicture = newurl;
    notifyListeners();
  }

  void updateUserBio(String newBio){
    _user?.description = newBio;
    notifyListeners();
  }

  Future<void>  getCFData()async{
    // print("Getting CFData...");
    _cfdata = await APIs().getCFGraphData();
    notifyListeners();
    // print("SET data");
  }

  Future<void> getGithubData() async{
    _githubData = await APIs().getGithubData();
    notifyListeners();
  }

  Future<void> getLeetCodeData() async{
    _leetcodeData = await APIs().getLeetCodeData();
    notifyListeners();
  } 

  Future<void> getHeatMapData() async{
    _heatMapData = await APIs().getHeatMapData();
    notifyListeners();
  }
}