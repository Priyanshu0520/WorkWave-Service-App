
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../new utils/utils.dart';
import '../new_services/about_services.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

   late Future<String> aboutus;


  @override
  void initState() {
    super.initState();
    aboutus = AboutUsService().aboutus();
  }



  @override
@override
Widget build(BuildContext context) {
  var mediaQuery = MediaQuery.of(context);
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Text(
            "About Us",
            textAlign: TextAlign.center,
            style: SafeGoogleFont(
              'Inter',
              fontSize: mediaQuery.size.width * 0.06,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.200000003,
              color: const Color(0xff272729),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WayForce Heading
            Text(
              'Work Wave',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Inter',
                fontSize: 25,
                fontWeight: FontWeight.w700,
                height: 1.2125,
                color: const Color(0xff222222),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  // Use aboutUsContent instead of aboutUsData
                  FutureBuilder<String>(
        future: aboutus,
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
                ],
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    ),
  );

  }
}

