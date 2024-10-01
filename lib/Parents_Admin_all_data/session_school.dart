import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/class_school.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/after_login/session.dart';

class SessionP extends StatelessWidget {
  String id;
  bool b ;
  SessionP({super.key, required this.id, required this.b});

  List<SessionModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xff50008e),
          title: Text('Choose Student Session', style : TextStyle(color : Colors.white)),
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
bool b;
  ChatUser({super.key, required this.user, required this.id, required this.b});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Session : "+user.Name),
      onLongPress: (){
        if(b){
          Navigator.push(
              context, PageTransition(
              child: HG(id: id, session_id: user.id,vb:user.ou=="Under Admin Approval for Delete",name:user.Name), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
          ));
        }
      },
      onTap: () {
        Navigator.push(
            context, PageTransition(
            child: ClassP(id: id, session_id: user.id, b : b), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
        ));
      },
      trailing:  user.ou=="Under Admin Approval for Delete"?Icon(
        Icons.hourglass_bottom,
        color: Colors.red,
        size: 20,
      ):Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.black,
        size: 20,
      ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}

class HG extends StatelessWidget {
  String id;bool vb;
  String session_id;String name;
  HG({super.key, required this.id, required this.session_id,required this.vb,required this.name});

  final TextEditingController Admission = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text("Upgrade Session",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
        body: Column(
          children: [
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      "Type the Next Session Name to upgrade All Students to that New Session")),
            ),
            d(
              Admission,
              "Session Name",
              vb?name:"Session 42",
              false,
            ),
            vb?SizedBox():Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'I CONFIRM THE NEW SESSION',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session');

                  await collection.doc(session_id).update({
                    'Name' : Admission.text,
                    // Add more fields as needed
                  });
                  // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Success ! All Students and Class would be added to this Session only"),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
           vb? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor: Colors.red,
                height: 40,
                text: 'I CONFIRM DELETE IT',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session');
                 //
                  print(name);
                  print(Admission.text);
                  print(session_id);
                  if(Admission.text==name){
                    print(name);
                    print(Admission.text);
                    print(session_id);
                    await collection.doc(session_id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Success ! Deleted"),
                      ),
                    );
                    Navigator.of(context).pop();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Type Session Name to confirm"),
                      ),
                    );
                  }
                  // Close the dialog

                },
              ),
            ):SizedBox(),
            vb? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor: Colors.blue,
                height: 40,
                text: 'RECOVER THE ENTIRE CLASS',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session');
                  await collection.doc(session_id).update({
                    "ou":"gjkjhjh"
                  });
                  // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Success ! Recovered !"),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ):SizedBox(),
          ],
        ));
  }
  Widget d(
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
}


class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,
  });

  late final String Name;
  late final String id;
  late String ou;

  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    ou=json['ou']??"";
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    return data;
  }
}
