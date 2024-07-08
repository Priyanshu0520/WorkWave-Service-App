import 'package:flutter/material.dart';
import 'package:wayforce/new_services/global_constants.dart';
import 'package:wayforce/new_services/login_api_service.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isVerifying = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Image.asset(
                'assets/images/iclogo.png',
                width: mediaQuery.size.width * 0.35, 
                height: mediaQuery.size.height * 0.25,
              ),
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Nunito',
                  fontSize: mediaQuery.size.width * 0.08,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.03,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (GlobalConstant.userType == "Manpower")
                      Container(
                         width: mediaQuery.size.width * 0.30,
                              height: mediaQuery.size.height * 0.04,
                              decoration: BoxDecoration(
                                color:
                                   AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                        child: Center(
                          child: Text(
                            'ManPower',
                            style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.035,
                                color: AppColors.black),
                          ),
                        ),
                      ),
                    if (GlobalConstant.userType == "Employer")
                      Container(
                         width: mediaQuery.size.width * 0.30,
                              height: mediaQuery.size.height * 0.04,
                              decoration: BoxDecoration(
                                color:
                                   AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                        child: Center(
                          child: Text(
                            'Employer',
                            style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.035,
                                color: AppColors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.02),
              SizedBox(
                width: mediaQuery.size.width * 0.80,
                child: Form(
                  // key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          controller: nameController,
                           maxLength: 10,
                          decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: AppColors.black),
                            labelText: 'Phone No.',
                            suffix: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.black,
                                    width: mediaQuery.size.width * 0.005),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (nameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            backgroundColor: AppColors.black,
                                            content: Text(
                                              "Enter Mobile Number",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )));
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    LoginAPIService().Login_Get_OTP(
                                        nameController.text, context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: isLoading == true
                                      ? const RefreshProgressIndicator()
                                      : const Text(
                                          'Get Otp',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          controller: otpController,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: AppColors.black),
                            labelText: 'OTP',
                          ),
                        ),
                      ),
                      (GlobalConstant.loginOTP != "")
                          ? SizedBox(
                              height: mediaQuery.size.height * 0.03,
                              child: Text(
                                  "OTP received : ${GlobalConstant.loginOTP}"))
                          : SizedBox(),
                      SizedBox(
                        height: mediaQuery.size.height * 0.05,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: TextButton(
                          onPressed: () {
                            LoginAPIService()
                                .loginRequest(nameController.text, otpController.text, context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: mediaQuery.size.width * 0.70,
                            height: mediaQuery.size.height * 0.055,
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Center(
                                child:
                                    //  _isLoging
                                    //     ? const CircularProgressIndicator()
                                    //     :
                                    Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Nunito',
                                    fontSize: mediaQuery.size.width * 0.05,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              style: SafeGoogleFont(
                                'Nunito',
                                fontSize: mediaQuery.size.width * 0.03,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Don't have an account ?",
                                ),
                                TextSpan(
                                  text: ' ',
                                  style: SafeGoogleFont(
                                    'Nunito',
                                    fontSize: mediaQuery.size.width * 0.03,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: 'SignUp',
                                  style: SafeGoogleFont(
                                    'Nunito',
                                    fontSize: mediaQuery.size.width * 0.041,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: AppColors.black,
                                    decorationColor: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * 0.06,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
