import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/after_login/class.dart' as d;
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/aextra/class.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/anew/school_service/click_photo/class.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';

class SessionPicJust extends StatelessWidget {
  String id;bool reminder ; bool newb;SchoolModel school;
  SessionPicJust({super.key, required this.id, required this.reminder,required this.newb,required this.school});

  List<SessionModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Choose Session'),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(id).collection('Session').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => SessionModel.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                    id : id, reminder : reminder, newb: newb, school: school,
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
  SessionModel user ;SchoolModel school;
  String id ;bool reminder ; bool newb;
  ChatUser({super.key , required this.user , required this.id,  required this.reminder,required this.newb ,required this.school});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.Name),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>ClassPic(id:id, rem: reminder, sname: user.Name, session_id: user.id, school: school, newb: newb,),
          ),
        );
      },
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.black,
        size: 20,
      ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}
