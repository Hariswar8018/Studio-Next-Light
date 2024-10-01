import 'package:flutter/material.dart';

import '../../../model/student_model.dart';

class StP extends StatelessWidget {
  StudentModel user; bool parent;
  StP({super.key,required this.parent,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.blue,
        title:Center(child: Text("Coming Soon",style:TextStyle(color:Colors.white))),
      ),
    );
  }
}
