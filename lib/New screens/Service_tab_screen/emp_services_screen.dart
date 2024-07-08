import 'package:flutter/material.dart';

class EmpServices extends StatefulWidget {
  const EmpServices({super.key});

  @override
  State<EmpServices> createState() => _EmpServicesState();
}

class _EmpServicesState extends State<EmpServices> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Center(child:const  Text('Coming soon',style: TextStyle(fontSize: 22),)),
    );
  }
}