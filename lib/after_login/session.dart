import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/after_login/class.dart';
import 'package:studio_next_light/after_login/session.dart';

class Session extends StatelessWidget {
  String id;
  String School ;
  bool EmailB;
    bool BloodB;
    bool DepB;
    bool MotherB;
    bool RegisB;
    bool Other1B;
    bool Other2B;
    bool Other3B;
    bool Other4B;
  Session({super.key, required this.id, required this.School,
    required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB
  });

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
          title: Text('Choose Your Session'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(id: id),
                ),
              );
            },
            child: Icon(Icons.add)),
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
                        ?.map((e) => SessionModel.fromJson(e.data()))
                        .toList() ??
                    [];
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index],
                      id : id,
                      School : School ,EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
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
  SessionModel user;
  String id ;
  String School ;
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;
  ChatUser({super.key, required this.user, required this.id, required this.School,
    required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.Name),
      onTap: () {

        Navigator.push(
        context, PageTransition(
       child: Class(id: id, session_id: user.id, Session : user.Name, School: School,
         EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
         Other3B: Other3B, Other2B: Other2B, Other1B: Other1B,
         MotherB: MotherB, DepB: DepB, BloodB: BloodB,
       ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
       ));
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

class Add extends StatelessWidget {
  String id;

  Add({super.key, required this.id});

  final TextEditingController sessionNameController = TextEditingController();
  String s = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add Session"),
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
                  labelText: 'Session Name',
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
                text: 'Add Session Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session');


                    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString(); // Replace with your own custom ID

                    await collection.doc(customDocumentId).set({
                      'Name': sessionNameController.text,
                      'id' : customDocumentId,
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
  });

  late final String Name;
  late final String id;

  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    return data;
  }
}
