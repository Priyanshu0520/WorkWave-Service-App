import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wayforce/new_services/signup_api_service.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../new_services/category_services.dart';
import '../../new_services/global_constants.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
 
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> genderOptions = ['Male', 'Female'];
  List<String> jobtype = ['Full time', 'Part time'];
 TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController experiance = TextEditingController();
  TextEditingController minsalary = TextEditingController();
  TextEditingController maxsalary = TextEditingController();
  TextEditingController jobtypecontroller = TextEditingController();
 
  List<String> categoryNames = [];
  List<String> categoryid = [];
  var selectedCategory;
  String? selectedState;
  String? selectedcity;
 @override
  void initState() {
    super.initState();
     loadCategories();

  }
  File? profilePic;
File? panCard;
File? aadharCard;

Future<void> _pickProfilePic() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  if (image != null) {
    setState(() {
      profilePic = File(image.path);
    });
  }
}

Future<void> _pickPanCard() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  if (image != null) {
    setState(() {
      panCard = File(image.path);
    });
  }
}

Future<void> _pickAadharCard() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  if (image != null) {
    setState(() {
      aadharCard = File(image.path);
    });
  }
}


  List<String> states = [
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  List<String> cities = [];
  

  Future<void> loadCategories() async {
    await CategoryService.fetchCategories();
    setState(() {
      categoryNames = CategoryService.getCategoryNames();
      categoryid =CategoryService.getCategoryId();
      print('catttttttttt');
    });
  }
  @override
  

  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: mediaQuery.size.width * 0.1,
                  right: mediaQuery.size.width * 0.1),
              child: Form(
                 key: _formKey,
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.07,
                    ),
                    Center(
                      child: Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Nunito',
                          fontSize: mediaQuery.size.width * 0.08,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                     SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ), SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
               
               Center(child:   profilePic == null
                     ? CircleAvatar(
                         radius: mediaQuery.size.width * 0.11,
                         backgroundColor: Colors.grey[300], // Placeholder background color
                         child: Icon(
                           Icons.person,
                           size: mediaQuery.size.width * 0.2, // Adjust the icon size as needed
                           color: Colors.grey[600], // Placeholder icon color
                         ),
                       )
                     : CircleAvatar(
                         radius: mediaQuery.size.width * 0.11,
                         backgroundImage: FileImage(profilePic!),
                       ), ) ,
                       
                        SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ), SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),  Center(
                child: GestureDetector(
                  onTap: _pickProfilePic,
                  child: Container(
                    
                    width: mediaQuery.size.width*0.28,
                    height: mediaQuery.size.height*0.04,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.lightgrey
                    ),
                    child: Center(child: Text('Add Profile Pic',style: TextStyle(fontWeight: FontWeight.w600),)))),
                            ),
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: nameController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: AppColors.black),
                          labelText: 'Name'),
                    ),
                
                    DropdownButtonFormField<String>(
                      value: genderOptions.contains(genderController!.text)
                          ? genderController!.text
                          : null,
                      onChanged: (String? value) {
                        setState(() {
                          genderController!.text = value!;
                        });
                      },
                      items: genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: AppColors.black),
                          labelText: 'Gender'),
                    ),
                    if (GlobalConstant.userType == "Manpower")
                      DropdownButtonFormField<String>(
                        value: jobtype.contains(jobtypecontroller!.text)
                            ? jobtypecontroller!.text
                            : null,
                        onChanged: (String? value) {
                          setState(() {
                            jobtypecontroller!.text = value!;
                          });
                        },
                        items: jobtype.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: AppColors.black),
                            labelText: 'Job Type'),
                      ),
                   
                   TextField(
                controller: dobController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Select DOB',
                  hintStyle: TextStyle(
                    
                    fontWeight: FontWeight.w400,
                    fontSize: mediaQuery.size.width*0.04,
                    color: AppColors.black),
                  iconColor: AppColors.black,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                            ),
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: mobileController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: AppColors.black),
                          labelText: 'Mobile'),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.01,
                    ),
                    if (GlobalConstant.userType == "Manpower")
                    DropdownButtonFormField<Category>(
                  items: CategoryService.categories.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Category? value) {
                    setState(() {
                      selectedCategory = value?.id; // Set selectedCategory to category id
                    });
                  },
                  value: selectedCategory != null
                      ? CategoryService.categories.firstWhere((category) => category.id == selectedCategory, orElse: () => null!)
                      : null, // Set the initial selected value
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: AppColors.black),
                    labelText: 'Category',
                  ),
                  validator: (value) {
                    if (value == null || value.id.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                    if (GlobalConstant.userType == "Employer")
                      TextFormField(
                        cursorColor: AppColors.black,
                        controller: emailController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: AppColors.black),
                            labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    if (GlobalConstant.userType == "Manpower")
                      TextFormField(
                        cursorColor: AppColors.black,
                        controller: minsalary,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: AppColors.black),
                            labelText: 'Min Salry'),
                        keyboardType: TextInputType.number,
                      ),
                    if (GlobalConstant.userType == "Manpower")
                      // TextFormField(
                      //   cursorColor: AppColors.black,
                      //   controller: maxsalary,
                      //   decoration: InputDecoration(
                      //       labelStyle: TextStyle(color: AppColors.black),
                      //       labelText: 'Max Salary'),
                      //   keyboardType: TextInputType.number,
                      // ),
                    if (GlobalConstant.userType == "Manpower")
                      TextFormField(
                        cursorColor: AppColors.black,
                        controller: experiance,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: AppColors.black),
                            labelText: 'Experiance'),
                        keyboardType: TextInputType.number,
                      ),
                
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: addressLine1Controller,
                      decoration: InputDecoration(
                        labelText: 'Address Line 1',
                        labelStyle: TextStyle(color: AppColors.black),
                      ),
                    ),
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: addressLine2Controller,
                      decoration: InputDecoration(
                        labelText: 'Address Line 2',
                        labelStyle: TextStyle(color: AppColors.black),
                      ),
                    ),
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: blockController,
                      decoration: InputDecoration(
                        labelText: 'Block',
                        labelStyle: TextStyle(color: AppColors.black),
                      ),
                    ),
                     DropdownButton<String>(
                      value: selectedState,
                      hint: Text('Select State',style:TextStyle(color: AppColors.black, fontWeight: FontWeight.w400)),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedState = newValue;
                          selectedcity = null;
                          cities.clear();
                          if (selectedState != null) {
                            fetchCities(selectedState!);
                          }
                        });
                      },
                      items: states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      underline: Container(),
                    ),
                    DropdownButton<String>(
                      value: selectedcity,
                      hint: Text('Select City',style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w400),),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedcity = newValue;
                
                          if (selectedcity != null &&
                              !cities.contains(selectedcity)) {
                            selectedcity = null;
                          }
                        });
                      },
                      items: cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      underline: Container(),
                    ),
                   
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: pinCodeController,
                      decoration: InputDecoration(
                        labelText: 'Pin Code',
                        labelStyle: TextStyle(color: AppColors.black),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                   
                    // TextFormField(
                    //   cursorColor: AppColors.black,
                    //   controller: panController,
                    //   decoration: InputDecoration(
                    //     labelText: 'PAN Number',
                    //     labelStyle: TextStyle(color: AppColors.black),
                    //   ),
                    // ),
                    TextFormField(
                      cursorColor: AppColors.black,
                      controller: aadharController,
                      decoration: InputDecoration(
                        labelText: 'Aadhaar Number',
                        labelStyle: TextStyle(color: AppColors.black),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    Center(
                      child: Row(children: [
                           GestureDetector(
                        onTap: _pickAadharCard,
                        child: aadharCard == null
                            ? Column(
                              children: [
                                CircleAvatar(
                                    radius: mediaQuery.size.width * 0.11,
                                    backgroundColor: Colors.grey[300], // Placeholder background color
                                    child: Icon(
                                      Icons.document_scanner,
                                      size: mediaQuery.size.width * 0.2, // Adjust the icon size as needed
                                      color: Colors.grey[600], // Placeholder icon color
                                    ),
                                  ),
                                  Text('Select Aadhaar Card')
                              ],
                            )
                            :CircleAvatar(
          radius: mediaQuery.size.width * 0.11,
          backgroundImage: FileImage(aadharCard!),
        ),
                      ),
                       SizedBox(
                      width: mediaQuery.size.width * 0.15,
                    ),
                      
        //                   GestureDetector(
        //                 onTap: _pickPanCard,
        //                 child: panCard == null
        //                     ? Column(
        //                       children: [
        //                         CircleAvatar(
        //                             radius: mediaQuery.size.width * 0.11,
        //                             backgroundColor: Colors.grey[300], // Placeholder background color
        //                             child: Icon(
        //                               Icons.document_scanner,
        //                               size: mediaQuery.size.width * 0.2, // Adjust the icon size as needed
        //                               color: Colors.grey[600], // Placeholder icon color
        //                             ),
        //                           ),
        //                           Text('Select Pan card')
        //                       ],
        //                     )
        //                     : CircleAvatar(
        //   radius: mediaQuery.size.width * 0.11,
        //   backgroundImage: FileImage(panCard!),
        // ),
        //               ),
                      ],),
                    ),
                     SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
              TextFormField(
                      cursorColor: AppColors.black,
                      controller: bioController,
                      decoration: InputDecoration(
                        labelText: 'About Yourself',
                        labelStyle: TextStyle(color: AppColors.black),
                      ),
                      maxLines: 2,
                    ),
                    // NAme
                    SizedBox(
                      height: mediaQuery.size.height * 0.03,
                    ),
                
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
  SignupAPIService().registerUser(
    nameController.text,
                                  
                                  mobileController.text,
                                  
                                  selectedCategory?? null,
                                  genderController.text,
                                  dobController.text,
                                  int.tryParse(ageController.text ) ?? 0,
                                  emailController.text,
                                  addressLine1Controller.text,
                                  addressLine2Controller.text,
                                  blockController.text,
                                  pinCodeController.text,
                                  selectedcity!,
                                  selectedState!,
                                  bioController.text,
                                  aadharController.text,
                                //  panController.text,
                                  minsalary.text??"",
                                 
                                 int.tryParse(experiance!.text) ?? 0,
                                 profilePic!,
                                  aadharCard!,
                                  // panCard!,
                                 context
                                  
                                  
  );}},
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
                                  child: Text(
                                    'Register',
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
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  

    
   Future<void> _selectDate(BuildContext context) async {
     late DateTime selectedDate =DateTime.now();
  //DateTimePickerLocale locale = DateTimePickerLocale.en_us;
  DateTime picked = await showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(color: AppColors.lightgrey),
        height: 200,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDate = newDate ?? DateTime.now(); // Set to current date if newDate is null
              dobController!.text = DateFormat('yyyy-MM-dd').format(selectedDate);

              // Calculate age
              DateTime currentDate = DateTime.now();
              Duration difference = currentDate.difference(selectedDate);
              int age = (difference.inDays / 365).floor();

              // Update ageController
              print(age.toString());
              print(dobController!.text);
              ageController!.text = age.toString();
            });
          },
          initialDateTime: selectedDate ?? DateTime.now(), // Set to current date if 
           minimumDate: DateTime(1950),
           maximumDate: DateTime.now(),
        ),
      );
    },
  );

  
}

  Future<void> fetchCities(String stateName) async {
    try {
      final response = await http.get(Uri.parse(
          'https://workwave-backend.vercel.app/api/v1/city/get/getCitiesByStateName/$stateName'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['message'] == "Cities found in the specified state") {
          final List<dynamic> data = jsonResponse['data'];
          setState(() {
            cities = data
                .map<String>((city) => city['selectcity'].toString())
                .toList();
          });
        } else {
          // Handle API response indicating failure
          print('Failed to fetch cities: ${jsonResponse['message']}');
        }
      } else {
        // Handle HTTP error
        print('Failed to load cities');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
    }
  }
}