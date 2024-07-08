import 'package:flutter/material.dart';



class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Help and Support'),
      ),
      body: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Text("Phone Number - ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text("9560349335"),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Text("Email - ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('wayforcehelp@gmail.com'),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

}
