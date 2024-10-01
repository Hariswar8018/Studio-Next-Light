import 'package:flutter/material.dart';

import '../../model/usermodel.dart';

class HomeDorp extends StatelessWidget {
  UserModel user;
  HomeDorp({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Text("Coming Soon !")
      )
    );
  }
}
