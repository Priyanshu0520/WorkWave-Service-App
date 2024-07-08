import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  Map userData = {};
  UserProvider();
  
  setUserData(Map data) async{
    userData = data; 
    // notifyListeners();
  }
  getUserData(){
    return userData;
  }
}
