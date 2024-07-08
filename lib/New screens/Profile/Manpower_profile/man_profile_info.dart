import 'package:flutter/material.dart';
import '../../../new utils/utils.dart';

import '../../../new_services/UserInfo/man_info_services.dart';

class ManProfileInfo extends StatefulWidget {
  const ManProfileInfo({Key? key}) : super(key: key);

  @override
  State<ManProfileInfo> createState() => _ManProfileInfoState();
}

class _ManProfileInfoState extends State<ManProfileInfo> {
  ManpowerUserService _manpowerUserService = ManpowerUserService();
  Map<String, dynamic>? manpowerUserData;

  @override
  void initState() {
    super.initState();
    fetchManpowerUserData();
  }

  Future<void> fetchManpowerUserData() async {
    try {
      final Map<String, dynamic>? data =
          await _manpowerUserService.fetchManpowerUserData();

      if (data != null) {
        setState(() {
          manpowerUserData = data;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${manpowerUserData?['address']?['addressLine1'] ?? ''}, ${manpowerUserData?['address']?['addressLine2'] ?? ''}\n${manpowerUserData?['address']?['block'] ?? ''}\n${manpowerUserData?['address']?['city'] ?? ''}\n${manpowerUserData?['address']?['state'] ?? ''}\n${manpowerUserData?['address']?['pinCode'] ?? ''},\n${manpowerUserData?['address']?['country'] ?? ''}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 95),
          child: Text(
            'Profile',
            style: SafeGoogleFont(
              'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.200000003,
              color: const Color(0xff272729),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildInfoBox('Name', manpowerUserData?['name'] ?? ''),
                _buildInfoBox('Number', manpowerUserData?['mobile'] ?? ''),
                _buildInfoBox('Category', manpowerUserData?['category']['name'] ?? ''),
                _buildAddressContainer(),
                _buildInfoBox('Age', manpowerUserData?['age'].toString() ?? ''),
                _buildInfoBox('Gender', manpowerUserData?['gender'] ?? ''),
                _buildInfoBox('Experience', manpowerUserData?['experience'].toString() ?? ''),
                _buildInfoBox('Min Salary', manpowerUserData?['minSalary'].toString() ?? ''),
              
                _buildInfoBox('Speaking Lang', manpowerUserData?['speakingLanguage'] ?? ''),
                _buildInfoBox('Bio', manpowerUserData?['bio'] ?? ''),
                _buildInfoBox('Aadhaar', manpowerUserData?['aadharNumber'] ?? ''),
                _buildInfoBox('Pancard',  manpowerUserData?['panCardNumber'] ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, dynamic value) {
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
              value.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Your ManpowerUserService class remains unchanged
