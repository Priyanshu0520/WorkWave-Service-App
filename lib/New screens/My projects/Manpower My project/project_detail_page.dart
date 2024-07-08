import 'package:flutter/material.dart';

import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../helpandsupport.dart';


class ManOrderdetails extends StatefulWidget {
 String date;
  String price;
  String paystatus;
  String location;
  String category;
  String emppic;
  String strttime;
  String endtime;
  String employername;
   ManOrderdetails({required this.strttime, required this.endtime,  required this.emppic, required this.category,required this.price,required this.employername,required this.paystatus,required this.date,required this.location ,Key? key,});
  @override
  State<ManOrderdetails> createState() => _ManOrderdetailsState();
}

class _ManOrderdetailsState extends State<ManOrderdetails> {
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
                          'Work done for \n${widget.employername} ',
                          textAlign: TextAlign.start,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.07,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: mediaQuery.size.width*0.10,),
                         CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.emppic??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU'),
                ),
                  
                        
              ],
            ),
            SizedBox(height: mediaQuery.size.
            height*0.02,),
                        Text(
                          'Date',
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
                            ),
                            SizedBox(width: mediaQuery.size.
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
                            ),
              ],
            ),
            SizedBox(height: mediaQuery.size.
            height*0.01,),
                                    Text(
                          'Booked Price',
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
}