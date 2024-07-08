import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wayforce/New%20screens/bottomnav%20bars/emp_bottom_navbar_provider.dart';
import 'package:wayforce/new%20utils/colors.dart';
import 'package:wayforce/new%20utils/const.dart';
import 'package:wayforce/new_services/global_constants.dart';

class EmpPaymentSucce extends StatefulWidget {
  String? manpowerid;
   EmpPaymentSucce({ this.manpowerid , super.key});

  @override
  State<EmpPaymentSucce> createState() => _EmpPaymentSucceState();
}

class _EmpPaymentSucceState extends State<EmpPaymentSucce> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://www.shutterstock.com/image-vector/quick-easy-loan-fast-money-600nw-1857833833.jpg',
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Payment Success"),
            SizedBox(
              height: 40,
            ),
            Center(
              child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black, // Set the background color to black
  ),
  onPressed: () async {
    await clearAllFunction();
    ismanMapPage = false;
    ismanOtpPage = false;
    isEmpDedectPage = false;
    isEmpMapPage = false;
    isEmpOtpPage = false;

    // Show the RatingFeedbackPage as a dialog
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      content: Container(
       // decoration: BoxDecoration(color: AppColors.white),
        height: MediaQuery.of(context).size.height * 0.5, 
        width: MediaQuery.of(context).size.height * 0.7,// Set the desired height
        child: SingleChildScrollView(
          child: RatingFeedbackPage(manpowerid: widget.manpowerid),
        ),
      ),
    );
  },
)

.then((_) {
      // Navigate to the home page after submitting the rating
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmpNavTab()),
      );
    });
  },
  child: Text('Go To Home Page', style: TextStyle(color: AppColors.white)),
),

            ),
          ],
        ),
      ),
    );
  }
}

class RatingFeedbackPage extends StatefulWidget {

  @override
    final String? manpowerid;

  RatingFeedbackPage({required this.manpowerid, Key? key}) : super(key: key);

  _RatingFeedbackPageState createState() => _RatingFeedbackPageState();
}

class _RatingFeedbackPageState extends State<RatingFeedbackPage> {
  int selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  void sendFeedbackToBackend() async {
    final givenBy = GlobalConstant.userID;
    final givenTo = widget.manpowerid;
    final rating = selectedRating;
    final comments = _feedbackController.text;

    final url = Uri.parse('https://workwave-backend.vercel.app//api/v1/review/');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body = jsonEncode({
      'givenBy': givenBy,
      'givenTo': givenTo,
      'rating': rating.toString(),
      'comments': comments,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Feedback sent successfully!');
        // Handle navigation or any other action upon successful feedback submission
      } else {
        print('Failed to send feedback: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error cases if needed
      }
    } catch (e) {
      print('Error sending feedback: $e');
      // Handle error cases if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Rate your experience',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
                child: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  size: 33.0,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _feedbackController,
            decoration: InputDecoration(
              hintText: 'Enter your feedback...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Call the function to send feedback to the backend
              sendFeedbackToBackend();
              Navigator.pop(context); // Close the bottom sheet
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EmpNavTab()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Set the background color to black
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

    @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}



