import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayforce/new_services/global_constants.dart';
import 'package:wayforce/shared_pref_service.dart';
import 'New screens/Home/Employer_Home/emp_home.dart';
import 'New screens/bottomnav bars/emp_bottom_navbar_provider.dart';
import 'New screens/bottomnav bars/manp_bottom_navbar_provider.dart';
import 'New screens/login_screen.dart';
import 'New screens/onboardingScreen/new_splash_screen.dart';
import 'New screens/signup_screen.dart';
import 'New screens/user_provider.dart';
import 'new_services/employer_ongoing_services.dart';
import 'new_services/firebase/new_local_notification.dart';
import 'new_services/manpower_ongoing_services.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    print("...*********" + message.notification!.title.toString());
    var notificationTitle = message.notification?.title.toString();
    var notificationBody = message.notification?.body.toString();
    var notificationData = message.data['payload'].toString();

    var allfirebaseBackgroundNotificationData = {
      "notificationTitle": notificationTitle,
      "notificationBody": notificationBody,
      "notificationData": notificationData
    };
    SharedPreferencesHelper.setBackgroundNotificationData(jsonEncode(allfirebaseBackgroundNotificationData));

    if(notificationTitle!.contains('Lead for') && notificationBody != "Session Expired"){
      const String portName = 'way';
      ReceivePort receiver = ReceivePort();
      IsolateNameServer.registerPortWithName(receiver.sendPort, portName);
      receiver.listen((message) async {
        if (message == "stop") {
          await FlutterRingtonePlayer.stop(); 
        }
      });

      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: true, // Android only - API >= 28
        volume: 1, // Android only - API >= 28
        asAlarm: true, // Android only - all APIs
      );        
    }

  }

  Future<void> initNotifications() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Channel for Accepting Notifications',
        ),
      ],
      debug: true
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications()
      }
    });
  }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget _default = NewSplashScreen();

  await Firebase.initializeApp();
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
  );

  print(settings);
  var token = await messaging.getToken();
  print(token);
  if(token!=null){
    GlobalConstant.firebaseToken = token;
  }

  // firebase initialisation
  initNotifications();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message);    
    print(message.data['payload']);
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 10, 
    //     channelKey: 'basic_channel',
    //     title: message.notification?.title,
    //     body: message.notification?.body  
    //   ));
      var notificationTitle = message.notification?.title;
      var notificationBody = message.notification?.body;
      NewPushNotification().showNewNotification(globalNavigatorKey.currentContext, 
        notificationTitle, notificationBody, message.data['payload']);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
    print("...*********" + message.notification!.title.toString());
    var notificationTitle = message.notification?.title.toString();
    var notificationBody = message.notification?.body.toString();
    var notificationData = message.data['payload'].toString();
    
    NewPushNotification().showNewNotification(globalNavigatorKey.currentContext, 
      notificationTitle, notificationBody, message.data['payload']);
  });

    const String portName = 'way';
    ReceivePort receiver = ReceivePort();
    IsolateNameServer.registerPortWithName(receiver.sendPort, portName);
    receiver.listen((message) async {
      if (message == "stop") {
        await FlutterRingtonePlayer.stop(); 
      }
    });


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserProvider()),
      ChangeNotifierProvider.value(value: EmpBottomNavBarProvider()),
      ChangeNotifierProvider.value(value: ManBottomNavBarProvider()),
      ChangeNotifierProvider.value(value: EmpOngoingOrdersProvider()),
      ChangeNotifierProvider.value(value: ManOngoingOrdersProvider()),
      // ChangeNotifierProvider.value(value: TimerData()),

    ],
    child: MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
      '/': (context) => _default,
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/emphomepage':  (context)=> EmpHomePage()
      },
    ),
  ));
  
}
