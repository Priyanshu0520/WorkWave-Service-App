
import 'package:flutter/material.dart';

class GlobalConstant {
  static var signupOTP = "";
  static var loginOTP = "";
  static var authToken = "";
  static var userID = "";
  static var userType = "";
  static var userphone = "";
  static var userName = "";

  static var instantprice = "" ;
  static var instantHireLat ="";
  static var instantHireLong = "" ;
  static var instantHirePlace = "";
  static var instantHireWork = "";
  static var instantHireCategory = "";
  static var instantHireWorkingHrs = "";
  static var instantHireOrderId = "";
  static var instantHireOtp ="";

  static var firebaseToken = "";

  late BuildContext context;

  static bool notificationPopupDisplayed = false; 

  static var firebaseBackgroundMsgTitle = "";
  static var firebaseBackgroundMsgBody = "";
  static var firebaseBackgroundMsgData = "";

  static var distanceBetweenOrderAndManpower = "";

  void clear() {
    signupOTP = "";
    loginOTP = "";
    authToken = "";
    userID = "";
    userType = "";
    userphone = "";
    userName = "";

    instantHireLat ="" ;
    instantHireLong = "" ;
    instantHirePlace = "";
    instantHireWork = "";
    instantHireCategory = "";
    instantHireWorkingHrs = "";
    instantHireOrderId = "";

    firebaseToken = "";

    notificationPopupDisplayed = false; 

    firebaseBackgroundMsgTitle = "";
    firebaseBackgroundMsgBody = "";
    firebaseBackgroundMsgData = "";

    distanceBetweenOrderAndManpower = "";
  }

}
