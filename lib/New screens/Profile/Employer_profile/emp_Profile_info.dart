import 'package:flutter/material.dart';
import 'package:wayforce/New%20screens/Profile/Employer_profile/profile_info_edit.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/UserInfo/emp_info_services.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  EmployerUserService _employerUserService = EmployerUserService();
  Map<String, dynamic>? employerUserData;
  @override
  void initState() {
    super.initState();
    fetchEmployerUserData();
  }

  Future<void> fetchEmployerUserData() async {
    try {
     final Map<String, dynamic>? data =
          await _employerUserService.fetchEmployerUserData();

      if (data != null) {
        setState(() {
          employerUserData = data;
        });
      } else {
        print('Received null data from the API');
        // Handle the case when data is null, if needed
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding:  EdgeInsets.only(left: mediaQuery.size.width*0.24),
            child: Text(
              ' Profile',
              style: SafeGoogleFont(
                'Inter',
                fontSize: mediaQuery.size.width*0.052,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.200000003,
                color: const Color(0xff272729),
              ),
            ),
          ),
        actions: [
        InkWell(
          onTap: (){
            // Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const EmpProfileEdit()));
          },
            child: Padding(
              padding:  EdgeInsets.only(right:mediaQuery.size.width*0.05 ),
              child: Icon(Icons.edit, size: mediaQuery.size.width*0.06,),
            ),
          )
        ],
        ),
        body: SingleChildScrollView(
                  child: Container(
          child: Column(children: [
        // SizedBox(height:mediaQuery.size.height*0.04, ),
        _buildInfoBox('Name', employerUserData?['name'] ?? ''),
        _buildInfoBox('Number', employerUserData?['mobile'] ?? ''),
        _buildInfoBox('Email', employerUserData?['email'] ?? ''),
             _buildAddressContainer(),
        _buildInfoBox('Age', employerUserData?['age'].toString() ?? ''),
        _buildInfoBox('Gender', employerUserData?['gender'] ?? ''),
        _buildInfoBox('Bio', employerUserData?['bio'] ?? ''),
        _buildInfoBox('Aadhaar', employerUserData?['aadharNumber'] ?? ''),
                  
                  ])),
                ));
  }
  
Widget _buildAddressContainer() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
            Text(
              '${employerUserData?['address']?['addressLine1'] ?? ''}, ${employerUserData?['address']?['addressLine2'] ?? ''}\n${employerUserData?['address']?['block'] ?? ''}\n${employerUserData?['address']?['city'] ?? ''}\n${employerUserData?['address']?['state'] ?? ''}\n${employerUserData?['address']?['pinCode'] ?? ''},\n${employerUserData?['address']?['country'] ?? ''}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
        
        ],
      ),
    ),
  );
}

}

Widget _buildInfoBox(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(9.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

