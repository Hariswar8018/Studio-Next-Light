import 'package:flutter/material.dart';
import 'package:student_managment_app/model/usermodel.dart';

class FinancePPortal extends StatelessWidget {
  UserModel user;
  FinancePPortal({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("FinanceP Portal"),
      ),
    );
  }
}
