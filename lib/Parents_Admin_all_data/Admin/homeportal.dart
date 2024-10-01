import 'package:flutter/material.dart';
import 'package:student_managment_app/model/usermodel.dart';

class AdminPortal extends StatelessWidget {
  UserModel user;
  AdminPortal({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Admin Portal"),
      ),
    );
  }
}
