import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/aextra/students.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/after_login/students.dart';
import 'package:student_managment_app/anew/school_service/click_photo/student.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';

class ClassPic extends StatelessWidget {
  String id; bool newb;SchoolModel school;
  String session_id; bool rem;  String sname ;
  ClassPic({super.key, required this.id, required this.sname,required this.session_id, required this.rem
    ,required this.newb,required this.school
  });

  List<SessionModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Choose Your Class'),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(id).collection('Session').doc(session_id).collection("Class").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => SessionModel.fromJson(e.data()))
                  .toList() ??
                  [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index], id: id, sessionid: session_id,
                    rem : rem, sname : sname, newb: newb, school: school,
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class ChatUser extends StatelessWidget {
  SessionModel user;
  String id ;  String sname ;
  String sessionid; bool rem ;
  bool newb;SchoolModel school;
  ChatUser({super.key, required this.user,required this.sname,  required this.id, required this.sessionid, required this.rem
    ,required this.newb,required this.school
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>StPicP(id: id, session_id:sessionid, class_id:user.id, b: rem, newb: newb, school: school,),
          ),
        );
      },
      title: Text("Class : " + user.Name),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }

  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return "₹" + formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    formattedNumber = "₹" + formattedNumber ;
    return formattedNumber;
  }
}
