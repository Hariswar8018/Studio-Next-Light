import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/admin/Student_Data_Update.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/student_shift.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/storage.dart';
import 'package:intl/intl.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentsJust extends StatelessWidget {
  String id;
  String session_id;
  String class_id;
  String Class;
  String Session;
  bool rem ;  String sname ;

  StudentsJust({
    super.key,
    required this.id, required this.sname,
    required this.session_id,
    required this.class_id,
    required this.Session,
    required this.rem,
    required this.Class,
  });

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Students Data'),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School')
            .doc(id)
            .collection('Session')
            .doc(session_id)
            .collection("Class")
            .doc(class_id)
            .collection("Student")
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => StudentModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                    id: id,
                    session_id: session_id,
                    class_id: class_id,
                    rem: rem,
                    length: list.length, sname : sname
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class ChatUser extends StatefulWidget {
  StudentModel user;
  int length;

  String id;
  bool rem;

  String session_id;
String sname ;
  String class_id;

  ChatUser({
    super.key,
    required this.user,
    required this.rem,  required this.sname,
    required this.length,
    required this.id,
    required this.session_id,
    required this.class_id,
  });

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  void initState(){
    as();
  }
  void as() async {
    if( widget.user.Classn != widget.class_id ){
      try{
        CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id)
            .collection('Session').doc(widget.session_id).collection('Class')
            .doc(widget.class_id)
            .collection("Student");
        await collection.doc(widget.user.Registration_number).update({
          'Classn' : widget.class_id,
        });
      }catch(e){
        CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id)
            .collection('Session').doc(widget.session_id).collection('Class')
            .doc(widget.class_id)
            .collection("Student");
        await collection.doc(widget.user.Admission_number).update({
          'Classn' : widget.class_id,
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.pic),
      ),
      title:
          Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle:widget.sname=="NA"?Text("Father Name :"+widget.user.Father_Name): Text("Roll no : " +
          widget.user.Roll_number.toString() ),
      onLongPress: () {
        Navigator.push(
            context,
            PageTransition(
                child: Class1(
                  uder: widget.user,
                  class_id: widget.class_id,
                  session_id: widget.session_id,
                  id: widget.id,
                ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 800)));
      },
      onTap: () {
        if (widget.rem) {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.white,
                height: 210,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text("Send Reminder to Student ",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 19)),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => Global.As( widget.user,  false,  widget.sname),
                                child: Card(
                                  child: Container(
                                      color: Colors.white,
                                      width:
                                          MediaQuery.of(context).size.width / 3 -
                                              30,
                                      height:
                                          MediaQuery.of(context).size.width / 3 -
                                              30,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                                height: 70,
                                                "https://kwiqreply.io/img/edtech/edtechbanner.png"),
                                            SizedBox(height : 8),
                                            Text("Whatsapp",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700))
                                          ])),
                                ),
                              ),
                              InkWell(
                                onTap: () => Global.As( widget.user,  true,  widget.sname),
                                child: Card(
                                  child: Container(
                                      color: Colors.white,
                                      width:
                                      MediaQuery.of(context).size.width / 3 -
                                          30,
                                      height:
                                      MediaQuery.of(context).size.width / 3 -
                                          30,
                                      child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                                height: 70,
                                                "https://kwiqreply.io/img/edtech/edtechbanner.png"),
                                            SizedBox(height : 8),
                                            Text("(Hindi)",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700))
                                          ])),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  final snackBar = SnackBar(
                                    content: Text('This function is Not Activated Yet for Free Users !'),
                                    duration: Duration(seconds: 3), // Optional, default is 4 seconds
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                },
                                child: Card(
                                  child: Container(
                                      color: Colors.white,
                                      width:
                                          MediaQuery.of(context).size.width / 3 -
                                              30,
                                      height:
                                          MediaQuery.of(context).size.width / 3 -
                                              30,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                                height: 70,
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA4HKvxzFx5Ir2-bNji2sEGzamBOj8-_YZYRNIiyOIcr1vl9LvCDpG_oAcqBLPtD6NSsU&usqp=CAU"),
                                            SizedBox(height : 8),Text("SMS",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700))
                                          ])),
                                ),
                              )
                            ]),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          print(widget.user.Name);
        } else {
          Navigator.pop(context, widget.user);
        }
      },
      trailing: widget.sname=="NA"?Text(widget.user.Roll_number.toString(),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)):Text("₹" + addCommas(widget.user.Myfee),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19)),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }

  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) +
          ',' +
          formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    return formattedNumber;
  }


}
