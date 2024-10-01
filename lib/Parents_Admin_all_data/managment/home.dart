import 'package:flutter/material.dart';
import 'package:student_managment_app/model/usermodel.dart';

class ManagmentPPortal extends StatelessWidget {
  UserModel user;
  ManagmentPPortal({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("ManagmentP Portal"),
      ),
    );
  }
}
