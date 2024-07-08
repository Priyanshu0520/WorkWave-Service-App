// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wayforce/new%20utils/colors.dart';

import '../new_services/term_condition_services.dart';

class TermsAndPrivacyPage extends StatefulWidget {
 
  @override
  State<TermsAndPrivacyPage> createState() => _TermsAndPrivacyPageState();
}

class _TermsAndPrivacyPageState extends State<TermsAndPrivacyPage> {
late Future<String> termsAndConditions;
late Future<String> privacypolicy;
  @override
  void initState() {
    super.initState();
    termsAndConditions = ApiService().getTermsAndConditions();
    privacypolicy = ApiService().privacyandpolicy();
  }

  @override
  Widget build(BuildContext context) {
   
    

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Terms and Privacy'),
          bottom: TabBar(
            
            labelColor: AppColors.black,
            indicatorColor: AppColors.black,
            dividerColor: AppColors.black,
            tabs: [
              Tab(text: 'Terms and Conditions'),
              Tab(text: 'Privacy Policy'),
            ],
          ),
        ),
        body: TabBarView(
          
          children: [
            // Terms and Conditions Page
            FutureBuilder<String>(
        future: termsAndConditions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Html(data: snapshot.data ?? ''),
            );
          }
        },
      ),
       FutureBuilder<String>(
        future: privacypolicy,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Html(data: snapshot.data ?? ''),
            );
          }
        },
      ),
            
            // Privacy Policy Page
           // buildPage2(),
          ],
        ),
      ),
    );
  }
}