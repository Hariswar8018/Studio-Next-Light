import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/after_login/session.dart';
import 'package:studio_next_light/after_login/students.dart';

class Class extends StatelessWidget {
  String id;
  String session_id;
  String Session;
  String School;
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;
  Class({super.key, required this.id, required this.session_id, required this.School, required this.Session,
  required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB});

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
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(id: id, session_id: session_id,),
                ),
              );
            },
            child: Icon(Icons.add)),
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
                      Session : Session , School : School,
                      EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
                      Other3B: Other3B, Other2B: Other2B, Other1B: Other1B,
                      MotherB: MotherB, DepB: DepB, BloodB: BloodB,
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
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;
  SessionModel user;
  String id ;
  String sessionid;
  String Session ;
  String School ;
  ChatUser({super.key, required this.user, required this.id, required this.sessionid, required this. Session, required this.School,
    required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.Name),
      onTap: () {
        Navigator.push(
        context, PageTransition(
       child: Students(id: id, session_id: sessionid, class_id: user.id, shop: user.status,
       Session : Session, Class : user.Name , School : School,
         EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
         Other3B: Other3B, Other2B: Other2B, Other1B: Other1B,
         MotherB: MotherB, DepB: DepB, BloodB: BloodB,
       ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
       ));
      },
      trailing: user.status == "Still Uploading" ? Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.black,
        size: 20,
      ) : Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green, // Set the border color to green
              width: 2.0, // Set the border width
            ),
          ), child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(user.status),
      )),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}

class Add extends StatelessWidget {
  String id;
  String session_id ;

  Add({super.key, required this.id, required this.session_id});

  final TextEditingController sessionNameController = TextEditingController();
  String s = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add Class"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: sessionNameController,
                decoration: InputDecoration(
                  labelText: 'Class Name with Section',
                  hintText: 'Class X ( A )',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please type your Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  /*setState(() {
                    s = value;
                  });*/
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Add Class Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(session_id).collection('Class');


                    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString(); // Replace with your own custom ID

                    await collection.doc(customDocumentId).set({
                      'Name': sessionNameController.text,
                      'id' : customDocumentId,
                      'status' : "Still Uploading",
                      // Add more fields as needed
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print('${e}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${e}'),
                      ),
                    );
                  }
                  ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,
    required this.status,
  });

  late final String Name;
  late final String id;
  late final String status;

  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    status = json['status'] ?? "Still Uploading";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['status'] = status;
    data['id'] = id ;
    return data;
  }
}
