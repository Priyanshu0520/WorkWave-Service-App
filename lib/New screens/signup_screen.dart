import 'package:flutter/material.dart';
import 'package:wayforce/new_services/global_constants.dart';
import 'package:wayforce/new_services/signup_api_service.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import 'login_screen.dart';
import 'ter_condition_policy_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  bool isVerifying = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Image.asset(
                'assets/images/iclogo.png',
                width: mediaQuery.size.width * 0.35, 
                height: mediaQuery.size.height * 0.25,
              ),
              Text(
                'Sign Up',
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
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                            controller: nameController,
                            decoration: InputDecoration(
                              
                              labelStyle:
                                  const TextStyle(color: AppColors.black),
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
                                          .showSnackBar( SnackBar(
                                              backgroundColor: AppColors.black,
                                              content: Text(
                                                "Enter Mobile Number",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )));
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      SignupAPIService().signup_get_OTP_ID(
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                        (GlobalConstant.signupOTP != "")
                            ? SizedBox(
                                height: mediaQuery.size.height * 0.03,
                                child: Text(
                                    "OTP received : ${GlobalConstant.signupOTP}"))
                            : SizedBox(),
                         SizedBox(
                          height: mediaQuery.size.height *0.02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              
                              shape:CircleBorder(),
                            activeColor: AppColors.white,
                              checkColor: AppColors.green,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  TermsAndPrivacyPage()));

                              },
                              child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                  style: SafeGoogleFont(
                                    'Nunito',
                                    fontSize: mediaQuery.size.width * 0.025,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                  children: [
                                   TextSpan(
                                      text: "I agree with the ",
                                      style: SafeGoogleFont(
                                        'Nunito',
                                        fontSize: mediaQuery.size.width * 0.027,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: SafeGoogleFont(
                                        'Nunito',
                                        fontSize: mediaQuery.size.width * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const TextSpan(text: ''),
                                    TextSpan(
                                      text: 'Term & Condition',
                                      style: SafeGoogleFont(
                                        'Nunito',
                                       fontSize: mediaQuery.size.width * 0.025,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: AppColors.black,
                                        decorationColor: AppColors.black,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: "  and  ",
                                    ),
                                    TextSpan(
                                      text: ' Privacy Policy ',
                                      style: SafeGoogleFont(
                                        'Nunito',
                                        fontSize: mediaQuery.size.width * 0.025,
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
                          ],
                        ),
                        SizedBox(
                          height: mediaQuery.size.height *0.02,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: TextButton(
                            onPressed: isChecked
                                ? () {
                                    FocusScope.of(context).unfocus();
                                    SignupAPIService().signup_verify_OTP(
                                        otpController.text, context);
                                  }
                                : null, // Disable the button if checkbox is not checked
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: mediaQuery.size.width * 0.70,
                              height: mediaQuery.size.height * 0.055,
                              decoration: BoxDecoration(
                                color:
                                    isChecked ? AppColors.black : AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Center(
                                  child: Text(
                                    'Proceed',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Nunito',
                                      fontSize: mediaQuery.size.width * 0.05,
                                      fontWeight: FontWeight.w700,
                                      color: isChecked
                                          ? AppColors.white
                                          : AppColors.black,
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
                                      builder: (context) => LoginScreen()));
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
                                TextSpan(
                                    text: "Already have an account ?",
                                    style: SafeGoogleFont(
                                      'Nunito',
                                      fontSize: mediaQuery.size.width * 0.035,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: SafeGoogleFont(
                                      'Nunito',
                                      fontSize: mediaQuery.size.width * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: 'Login',
                                    style: SafeGoogleFont(
                                      'Nunito',
                                      fontSize: mediaQuery.size.width * 0.042,
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
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
