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
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/upload/csv.dart';
import 'package:student_managment_app/upload/download.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/upload.dart';



class StudentsP extends StatelessWidget {
  String id;
  String session_id;
  String class_id;

  bool b;

  StudentsP(
      {super.key,
      required this.id,
      required this.session_id,
      required this.class_id,
      required this.b});

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xff50008e),
          title: Text('Students Data', style: TextStyle(color: Colors.white)),
        ),
         floatingActionButton: b ? FloatingActionButton(
          child:Icon(Icons.upload_file_rounded),
          onPressed : (){
            Navigator.push(
                context,
                PageTransition(
                    child: Csv( classi : class_id,
                      session : session_id,
                      school: id,),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 800)));
          }
        ): SizedBox(),
        persistentFooterButtons: [
          b
              ? SocialLoginButton(
                  backgroundColor: Color(0xff50008e),
                  height: 40,
                  text: 'EXPORT DATA NOW',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {

                  },
                )
              : SizedBox(height: 10),
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
      onLongPress: (){
        if(user.ou=="Waiting"||b){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete this ?'),
                content: Text('Do you really want to delete this Class including all Students'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(school).collection('Session').doc(s).collection('Class').doc(c).collection("Student");
                      await collection.doc(user.Registration_number).delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('This Student will be Deleted soon '),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes, Permanently Delete'),

                  ),
                  TextButton(
                    onPressed: () async {
                      CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(school).collection('Session').doc(s).collection('Class').doc(c).collection("Student");
                      await collection.doc(user.Registration_number).update({
                        "ou":"jghnhgb",
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('This Student is recovered '),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('No, Recover this Student'),

                  ),
                ],
              );
            },
          );
        }
      },
      onTap: () {
        if(b){
          Navigator.push(
              context,
              PageTransition(
                  child: StudentProfile(
                    user: user,
                    class_id: c,
                    session_id: s, str : " ",
                    school_id: school,
                    parent: false,
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 800)));
        }else{
          if(user.state == "Confirm by Parent"){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Student Data had been Confirmed by Both School and Parents. Thus, It can't be Edited Now"),
              ),
            );
          }else{
            Navigator.push(
                context,
                PageTransition(
                    child: Check(user: user, school_id: school, class_id: c, session_id: s,),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 800)));
          }
        }

      },
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


class Check extends StatelessWidget {
  final StudentModel user;
  final String school_id;
  final String class_id;
  final String session_id;

  Check({
    Key? key,
    required this.user,
    required this.school_id,
    required this.class_id,
    required this.session_id,
  }) : super(key: key);

  Widget dc(
      TextEditingController c,
      String label,
      String hint,
      bool number,
      ) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }

  final TextEditingController Admission = TextEditingController();
  final TextEditingController Registration = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text("Confirm You are a Parent",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff50008e),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.pic),
                radius: 40,
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
                    textAlign: TextAlign.center,
                    "Type his/her Registration number as well as Admission number to confirm")),
          ),
          dc(
            Registration,
            "Registration Number",
            "TN09863256",
            false,
          ),
          Center(
              child: Text("Or",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
          dc(
            Admission,
            "Admission Number",
            "AN000123",
            false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'I CONFIRM, I AM A PARENT',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                if (Registration.text == user.Registration_number ||
                    Admission.text == user.Admission_number) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('Parent', true);
                  prefs.setString("id", user.Registration_number);
                  prefs.setString("class", class_id);
                  prefs.setString("session", session_id);
                  prefs.setString("school", school_id);
                  if (scaffoldKey.currentState?.mounted ?? false) {

                    Navigator.push(
                      context,
                      PageTransition(
                        child: HomePa(),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400),
                      ),
                    );
                  }
                } else {
                  print('${user.Admission_number}');
                  if (scaffoldKey.currentState?.mounted ?? false) {

                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
