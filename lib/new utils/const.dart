import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isBusy = false;

bool isManMapPage = false;
bool isManOtpPage = false;

//--
bool isEmpDetectPage = false;
bool isEmpMapPage = false;
bool isEmpOtpPage = false;

RxBool manStartWork = false.obs;
RxBool manExtantTime = false.obs;
RxBool manAcceptPayment = false.obs;

class SPkey {
  //for emp
  static const String orderManId = 'IN_ORD_manID';
  static const String orderOTP = 'IN_ORD_OTP';
  static const String orderWorkingTime = 'IN_ORD_WorkingTime';
  static const String orderId = 'IN_ORD_id';

  //for manPower
  static const String orderEmpId = 'IN_ORD_empID';

  static const String orderOnGoing = "IN_ORD_going";

  static const String orderStartDateTime = "IN_ORD_startDate";
  static const String orderEndDateTime = "IN_ORD_endDate";

  static const String orderBillresponce = "IN_ORD_billResponce";
  static const String orderWorkDuration = "IN_ORD_workDuration";
}

Future clearAllFunction() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.remove(SPkey.orderManId);
  prefs.remove(SPkey.orderOTP);
  prefs.remove(SPkey.orderWorkingTime);
  prefs.remove(SPkey.orderId);
  prefs.remove(SPkey.orderEmpId);
  prefs.remove(SPkey.orderOnGoing);
  prefs.remove(SPkey.orderStartDateTime);
  prefs.remove(SPkey.orderEndDateTime);
  prefs.remove(SPkey.orderBillresponce);
  prefs.remove(SPkey.orderWorkDuration);

  isBusy = false;
  // ismanMapPage = false;
  // ismanOtpPage = false;
  // isEmpDedectPage = false;
  // isEmpMapPage = false;
  // isEmpOtpPage = false;
  manStartWork.value = false;
  manExtantTime.value = false;
  manAcceptPayment.value = false;
}
