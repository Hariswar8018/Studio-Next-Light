import 'package:flutter/material.dart';

import '../../../model/student_model.dart';

class StE extends StatelessWidget {
  StudentModel user; bool parent;
  StE({super.key,required this.parent,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.blue,
        title:Center(child: Text("Grades",style:TextStyle(color:Colors.white))),
      ),
      body: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Center(child: Text("Nothing here!",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500))),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(textAlign:TextAlign.center,"This function will be activated after 1.0.8 Update. Do Wait until that Time",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
              ),
            ),
            SizedBox(height:40),
          ]
      ),
    );
  }
}
