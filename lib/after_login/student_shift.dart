import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/after_login/students.dart';
import 'package:student_managment_app/model/student_model.dart';

class Class1 extends StatelessWidget {
  String id;
  String session_id;
  String class_id ;
  StudentModel uder ;
  Class1({super.key, required this.id, required this.session_id,  required this.class_id,
     required this.uder });

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
        title: Text('Shift to another Class'),
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
                    uder : uder, class_id : class_id
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
  StudentModel uder ;
  String id ; String class_id ;
  String sessionid;
  ChatUser({super.key, required this.user, required this.id, required this.sessionid, required this.uder, required this.class_id,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.Name),
      onTap: () async {
        StudentModel uhj = uder ;
        CollectionReference news = FirebaseFirestore.instance.collection(
            'School').doc(id).collection('Session').doc(sessionid)
            .collection('Class').doc(user.id)
            .collection("Student");
        await news.doc(uder.Admission_number).set(uhj.toJson());


        CollectionReference old = FirebaseFirestore.instance.collection(
            'School').doc(id).collection('Session').doc(sessionid)
            .collection('Class').doc(class_id)
            .collection("Student");
        await old.doc(uder.Admission_number).delete();
        Navigator.pop(context);
      },
      trailing :  Text(user.total.toString(), style : TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}


class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,
    required this.status,
    required this.total ,
  });

  late final String Name;
  late final String id;
  late final String status;
  late final int total ;

  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    status = json['status'] ?? "Still Uploading";
    total = json['total'] ?? 0 ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['status'] = status;
    data['id'] = id ;
    data['total'] = total ;
    return data;
  }
}

