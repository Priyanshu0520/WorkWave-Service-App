import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wayforce/New%20screens/onboardingScreen/onboardingscreen.dart';
import 'package:wayforce/new%20utils/colors.dart';
import 'package:wayforce/shared_pref_service.dart';

import '../../new_services/global_constants.dart';
import '../bottomnav bars/emp_bottom_navbar_provider.dart';
import '../bottomnav bars/manp_bottom_navbar_provider.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0,  end: 4).animate(_controller);

    _controller.repeat(reverse: true); 

    Future.delayed(const Duration(seconds: 2), () async {
      var allUserData = await SharedPreferencesHelper.getUserData();
      // GlobalConstant().context = context;
      if (allUserData != null && allUserData.length > 0) {
        var savedUserData = jsonDecode(allUserData);
        GlobalConstant.authToken = savedUserData['authToken'];
        GlobalConstant.userID = savedUserData['userID'];
        GlobalConstant.userName = savedUserData['userName'];
        GlobalConstant.userType = savedUserData['userType'];
        GlobalConstant.userphone = savedUserData['userphone'];
        if (savedUserData['userType'] == "Manpower") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ManNavTab()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => EmpNavTab()));
        }
      } else {
        
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //SizedBox(height: mediaQuery.size.height * 0.03),
               Image.asset(
                'assets/images/iclogo.png',
                width: mediaQuery.size.width * 0.55, 
                height: mediaQuery.size.height * 0.55,
              ),
                    
                    
              //SizedBox(height: mediaQuery.size.height * 0.06),
              
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Instant Jobs',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 79, 9),
                    fontSize: mediaQuery.size.width * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
