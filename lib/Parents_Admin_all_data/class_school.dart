import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/student_data.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/after_login/students.dart';

class ClassP extends StatelessWidget {
  String id;
  String session_id;
  bool b ;

  ClassP({super.key, required this.id, required this.session_id, required this.b});

  List<SessionModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xff50008e),
          title: Text('Choose Student Class', style : TextStyle(color : Colors.white)),
        ),

        body: StreamBuilder(
          stream: Fire.collection('School').doc(id).collection('Session').doc(session_id).collection("Class").snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
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
                  padding: EdgeInsets.only(bottom : 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index], id: id, sessionid: session_id,
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
  SessionModel user;
  String id ;
  String sessionid;
  bool b;
  ChatUser({super.key, required this.user, required this.id, required this.sessionid, required this.b});

  @override
  Widget build(BuildContext context) {
    return Container(
      color : user.status == "Still Uploading" ? Colors.white : Colors.blue.shade50 ,
      child: ListTile(
        title: Text("Class : "+user.Name+" ( "+user.section+" )"),
        onTap: () {
          if(b){
            Navigator.push(
                context, PageTransition(
                child: StudentsP(id: id, session_id: sessionid, class_id: user.id, b : b), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
            ));
          }else{
              Navigator.push(
                  context, PageTransition(
                  child: StudentsP(id: id, session_id: sessionid, class_id: user.id, b : b), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
              ));
          }
        },
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
                        CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(sessionid).collection('Class');
                        await collection.doc(user.id).delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('This Class will be Deleted soon '),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('Yes, Permanently Delete'),

                    ),
                    TextButton(
                      onPressed: () async {
                        CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(sessionid).collection('Class');
                        await collection.doc(user.id).update({
                          "ou":"bxvcb",
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('This Class Recovered '),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('No, Recover Class'),

                    ),
                  ],
                );
              },
            );
          }
        },
        trailing: user.ou=="Waiting"?Icon(
          Icons.hourglass_bottom,
          color: Colors.red,
          size: 20,
        ):user.status == "Still Uploading" ? Icon(
          Icons.arrow_forward_ios_sharp,
          color: Colors.black,
          size: 20,
        ) :  InkWell(
          onLongPress: (){
            if(b){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Change Order ?'),
                    content: Text('Change the Order Status Now?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // Close the dialog
                          CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(sessionid).collection('Class');
                          await collection.doc(user.id).update({
                            'status' : "In Progress",
                            // Add more fields as needed
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Order will be marked In Progress"),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('ID CARD in Progress'),
                      ),
                      TextButton(
                        onPressed: () async {
                          CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(sessionid).collection('Class');
                          await collection.doc(user.id).update({
                            'status' : "ID CARD Done",
                            // Add more fields as needed
                          });
                          // Close the dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Order will be marked ID Card Done"),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('ID CARD Done'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Close the dialog
                          CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(sessionid).collection('Class');
                          await collection.doc(user.id).update({
                            'status' : "ID CARD Shipped",
                            // Add more fields as needed
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Order will be marked ID Card Shipped"),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('ID CARD shipped'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green, // Set the border color to green
                  width: 2.0, // Set the border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(user.status),
              )),
        ) ,
        splashColor: Colors.orange.shade300,
        tileColor: Colors.grey.shade50,
      ),
    );
  }
}

class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,required this.sset,
    required this.feet,
    required this.status,
    required this.total ,
    required this.Total_Fee,
    required this.MTF,
    required this.Ad_Fee,
    required this.DevF,
    required this.ExamF,
    required this.TutionF,
    required this.MonthlyF,
    required this.LetF,
    required this.TransportF,
    required this.ID_Card_Fee,
    required this.section,
  });

  late final String Name;
  late final int feet;
  late final String id;
  late final String section ;
  late final String status;
  late final int total ;
  late final String Total_Fee;
  late final String MTF;
  late final String Ad_Fee;
  late final String DevF;
  late final String ExamF;
  late final String TutionF;
  late final int pcount ;
  late final String MonthlyF;
  late final String LetF;
  late final String TransportF;
  late final String ID_Card_Fee;
  late final int sset ;
  late final String ou;
  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    ou=json['ou']??"h";
    sset = json['sset'] ?? 0;
    pcount = json['pcount'] ?? 0;
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    status = json['status'] ?? "Still Uploading";
    total = json['total'] ?? 0 ;
    Total_Fee = json['Total_Fee'] ?? "";
    MTF = json['MTF'] ?? "";
    feet = json['feet'] ?? 0 ;
    Ad_Fee = json['Ad_Fee'] ?? "";
    DevF = json['DevF'] ?? "";
    ExamF = json['ExamF'] ?? "";
    section = json["S"] ?? "A";
    TutionF = json['TutionF'] ?? "";
    MonthlyF = json['MonthlyF'] ?? "";
    LetF = json['LetF'] ?? "";
    TransportF = json['TransportF'] ?? "";
    ID_Card_Fee = json['ID_Card_Fee'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['S'] = section ;
    data['status'] = status;
    data['id'] = id ;
    data['feet'] = feet ;
    data['Total_Fee'] = Total_Fee;
    data['MTF'] = MTF;
    data['Ad_Fee'] = Ad_Fee;
    data['DevF'] = DevF;
    data['ExamF'] = ExamF;
    data['TutionF'] = TutionF;
    data['sset'] = sset ;
    data['MonthlyF'] = MonthlyF;
    data['LetF'] = LetF;
    data['TransportF'] = TransportF;
    data['ID_Card_Fee'] = ID_Card_Fee;
    data['total'] = total ;
    return data;
  }
}
