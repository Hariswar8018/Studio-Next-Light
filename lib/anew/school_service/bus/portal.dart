import 'package:flutter/material.dart';
import 'package:student_managment_app/model/usermodel.dart';

class BusPortal extends StatelessWidget {
  UserModel user;
   BusPortal({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Bus Portal"),
      ),
    );
  }
}
