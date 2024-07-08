import 'package:flutter/material.dart';
import 'package:wayforce/new_services/global_constants.dart';

import '../../new utils/colors.dart';
import '../../new utils/utils.dart';
import '../login_screen.dart';
// import '../login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               // SizedBox(height: mediaQuery.size.height * 0.09),
                Center(
                    child:Image.asset(
                'assets/images/iclogo.png',
                width: mediaQuery.size.width * 0.45, 
                height: mediaQuery.size.height * 0.35,
              ),),
            //    SizedBox(height: mediaQuery.size.height * 0.06),
                Text(
                  'Choose Your Category',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Nunito',
                    fontSize: mediaQuery.size.width * 0.06,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.06,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          GlobalConstant.userType = "Manpower";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Container(
                          height: mediaQuery.size.height * 0.17,
                          width: mediaQuery.size.width * 0.55,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.blackShadow),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.blackShadow,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(2, 5)),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: mediaQuery.size.height * 0.02,
                              ),
                              const Icon(
                                Icons.album_outlined,
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Text(
                                'Manpower',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: mediaQuery.size.width * 0.06,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Text(
                                'For Job',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: mediaQuery.size.width * 0.06,
                                  color: Color.fromARGB(133, 56, 55, 55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * 0.04,
                      ),
                      InkWell(
                        onTap: () {
                          GlobalConstant.userType = "Employer";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Container(
                          height: mediaQuery.size.height * 0.17,
                          width: mediaQuery.size.width * 0.55,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.blackShadow),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.blackShadow,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(2, 5)),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: mediaQuery.size.height * 0.02,
                              ),
                              const Icon(
                                Icons.album_outlined,
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Text(
                                'Employer',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: mediaQuery.size.width * 0.06,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Text(
                                'I Need Manpower',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: mediaQuery.size.width * 0.06,
                                  color: Color.fromARGB(133, 56, 55, 55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
