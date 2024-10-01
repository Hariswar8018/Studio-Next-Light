import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/Parents_Portal/home.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/upload/csv.dart';
import 'package:student_managment_app/upload/download.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/upload.dart';



class StPicP extends StatelessWidget {
  String id;
  String session_id;
  String class_id;
  bool b;
  bool newb;SchoolModel school;

  StPicP(
      {super.key,
        required this.id,
        required this.session_id,
        required this.class_id,
        required this.newb,required this.school,
        required this.b});

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Color(0xff50008e),
        title: Text('Students Data', style: TextStyle(color: Colors.white)),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
       newb?Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           InkWell(
             onTap: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) =>Download(id: id, session:session_id, classu:class_id, list: list, i: 1, school: school, newb: newb,),
                 ),
               );
             },
             child: Center(
               child: Container(
                 height:45,width:w/2-15,
                 decoration:BoxDecoration(
                   borderRadius:BorderRadius.circular(7),
                   color:Colors.blue,
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                       spreadRadius: 5, // The extent to which the shadow spreads
                       blurRadius: 7, // The blur radius of the shadow
                       offset: Offset(0, 3), // The position of the shadow
                     ),
                   ],
                 ),
                 child: Center(child: Text("Dowmload Parent Pass",style: TextStyle(
                     color: Colors.white,
                     fontFamily: "RobotoS",fontWeight: FontWeight.w800
                 ),)),
               ),
             ),
           ),
           InkWell(
             onTap: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) =>Download(id: id, session:session_id, classu:class_id, list: list, i: 1, school: school, newb: newb,),
                 ),
               );
             },
             child: Center(
               child: Container(
                 height:45,width:w/2-15,
                 decoration:BoxDecoration(
                   borderRadius:BorderRadius.circular(7),
                   color:Colors.blue,
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                       spreadRadius: 5, // The extent to which the shadow spreads
                       blurRadius: 7, // The blur radius of the shadow
                       offset: Offset(0, 3), // The position of the shadow
                     ),
                   ],
                 ),
                 child: Center(child: Text("Download Student ID",style: TextStyle(
                     color: Colors.white,
                     fontFamily: "RobotoS",fontWeight: FontWeight.w800
                 ),)),
               ),
             ),
           ),
         ],
       ): ( b?Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>Download(id: id, session:session_id, classu:class_id, list: list, i: 0, school: school, newb: newb,),
                  ),
                );
              },
              child: Center(
                child: Container(
                  height:45,width:w/2-15,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text("Dowmload QRs",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>Download(id: id, session:session_id, classu:class_id, list: list, i: 1, school: school, newb: newb,),
                  ),
                );
              },
              child: Center(
                child: Container(
                  height:45,width:w/2-15,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text("Download Pictures",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
          ],
        ):
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Csv( classi : class_id,
                          session : session_id,
                          school: id,),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 80)));
              },
              child: Center(
                child: Container(
                  height:45,width:w/2-15,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text("Upload CSV",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>Download(id: id, session:session_id, classu:class_id, list: list, i: 2, school: school, newb: newb,),
                  ),
                );
              },
              child: Center(
                child: Container(
                  height:45,width:w/2-15,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text("Download CSV",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
          ],
        )),
      ],
      body: StreamBuilder(

        stream: Fire.collection('School')
            .doc(id)
            .collection('Session')
            .doc(session_id)
            .collection("Class")
            .doc(class_id)
            .collection("Student").orderBy("Name",descending:false)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => StudentModel.fromJson(e.data()))
                  .toList() ??
                  [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                    c : class_id,
                    s : session_id,
                    school: id,
                    b : b,
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
  bool b ;
  String c;
  String s;
  String school;
  StudentModel user;

  ChatUser({super.key, required this.user, required this.school, required this.s ,required this.c, required this.b});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          user.Roll_number.toString() +
          "   " +
          user.Class +
          user.Section
      ),
      trailing:  user.ou=="Waiting"?Icon(
        Icons.hourglass_bottom,
        color: Colors.red,
        size: 20,
      ):user.state == "Confirm by Parent"
          ? Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green, // Set the border color to green
              width: 2.0, // Set the border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Confirmed by both"),
          ))
          : Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red, // Set the border color to green
              width: 2.0, // Set the border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(user.state),
          )),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}
