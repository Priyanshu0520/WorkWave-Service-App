import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../helpandsupport.dart';


class EmpOrderdetails extends StatefulWidget {
  String date;
  String price;
  String paystatus;
  String location;
  String category;
  String manpowername;
  String ?manpowerpic;
    String strttime;
  String endtime;
   EmpOrderdetails({required this.strttime, required this.endtime,  this.manpowerpic, required this.category,required this.price,required this.manpowername,required this.paystatus,required this.date,required this.location ,Key? key,});

  @override
  State<EmpOrderdetails> createState() => _EmpOrderdetailsState();
}

class _EmpOrderdetailsState extends State<EmpOrderdetails> {
  @override
  Widget build(BuildContext context) {
     var mediaQuery = MediaQuery.of(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text(
                      'Order Detail',
                      textAlign: TextAlign.start,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: mediaQuery.size.width * 0.05,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
      ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Row(
              children: [
                Text(
                          'Work done with \n${widget.manpowername} ',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.07,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: mediaQuery.size.width*0.20,),
                         CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                  widget.manpowerpic??    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU'),
                ),
                  
                        
              ],
            ),
            SizedBox(height: mediaQuery.size.
            height*0.02,),
            Text(
                          'Date ',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                        
                          SizedBox(height: mediaQuery.size.
            height*0.01,),
            Text(
                          '${widget.date}',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                         SizedBox(height: mediaQuery.size.
            height*0.01,),
                          Text(
                          'Time',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                          SizedBox(height: mediaQuery.size.
            height*0.01,),
            
            
            Row(
              children: [
                Text(
                              'From : ',
                              textAlign: TextAlign.start,
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: mediaQuery.size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                Text(
                              '${widget.strttime}',
                              textAlign: TextAlign.start,
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: mediaQuery.size.width * 0.04,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ), SizedBox(width: mediaQuery.size.
            width*0.11,),
                            Text(
                              'To : ',
                              textAlign: TextAlign.start,
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: mediaQuery.size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              '${widget.endtime}',
                              textAlign: TextAlign.start,
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: mediaQuery.size.width * 0.04,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),]),
                        SizedBox(height: mediaQuery.size.
            height*0.01,),
                        Text(
                          'Booked Price ',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                          SizedBox(height: mediaQuery.size.
            height*0.01,),
                                    Text(
                          '₹${widget.price}',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                          SizedBox(height: mediaQuery.size.
            height*0.02,),
            Text(
                          'Payment Status',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                          SizedBox(height: mediaQuery.size.
            height*0.01,),
            Text(
                          '${widget.paystatus}',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                                    SizedBox(height: mediaQuery.size.
            height*0.02,),
            Text(
                          'Location',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                                    SizedBox(height: mediaQuery.size.
            height*0.01,),
            Text(
                          '${widget.location}',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                          SizedBox(height: mediaQuery.size.
            height*0.02,),
            Text(
                          'Category',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                          SizedBox(height: mediaQuery.size.
            height*0.01,),
            Text(
                          '${widget.category}',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                        Divider(),
                          SizedBox(height: mediaQuery.size.
            height*0.02,),
//               ElevatedButton(
                
//   onPressed: () => _generatePDF(context),
//   child: Text('Invoice as PDF', style: SafeGoogleFont(
//                             'Inter',
//                             fontSize: mediaQuery.size.width * 0.05,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.black,
//                           ),),
// ),
            Text(
                          'Help',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                         ListTile(
              leading: const Icon(Icons.help),
              title: Text(
                'Get help',
                 style: SafeGoogleFont(
                  'Roboto',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelpAndSupportPage()));
              },
            ),

          ],
        ),
      ),
    ),
    ));
  }
Future<void> _generatePDF(BuildContext context) async {
  final pdf = pw.Document();

  // Load the custom font
  // final fontData = await rootBundle.load("assets/fonts/your_custom_font.ttf");
  // final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Order Invoice', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Text('Order ID: ${widget.date}', style: pw.TextStyle(font:pw.Font())), // Use the custom font
            pw.Text('Customer Name: popop', style: pw.TextStyle(font: pw.Font())), // Use the custom font
            pw.Text('Total Price: \₹${widget.price}', style: pw.TextStyle(font: pw.Font())), // Indian Rupee symbol, Use the custom font
            pw.Text('Payment Status: ${widget.paystatus}', style: pw.TextStyle(font: pw.Font())), // Use the custom font
            pw.Text('Location: ${widget.location}', style: pw.TextStyle(font: pw.Font())), // Use the custom font
            pw.Text('Category: ${widget.category}', style: pw.TextStyle(font: pw.Font())), // Use the custom font
          ],
        ),
      ),
    ),
  );

  final String dir = (await getExternalStorageDirectory())!.path;
  final String path = '$dir/order_invoice.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Invoice downloaded successfully')),
  );
}


}