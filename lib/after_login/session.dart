import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/after_login/session.dart';

class Session extends StatelessWidget {
  String id;
  String School ;
  bool EmailB;
  String csession ;
    bool BloodB;
    bool DepB;
    bool MotherB;
    bool RegisB;
    bool Other1B;
    bool Other2B;
    bool Other3B;
    bool Other4B;
  Session({super.key, required this.id, required this.School, required this.csession,
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
                        ?.map((e) => SessionModel.fromJson(e.data())).toList() ?? [];
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index],
                      id : id,
                      School : School, EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
                      Other3B: Other3B, Other2B: Other2B, Other1B: Other1B,
                      MotherB: MotherB, DepB: DepB, BloodB: BloodB, csession : csession,
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
  SessionModel user ; String csession ;
  String id ;
  String School ;
  bool EmailB ;
  bool BloodB ;
  bool DepB ;
  bool MotherB ;
  bool RegisB ;
  bool Other1B ;
  bool Other2B ;
  bool Other3B ;
  bool Other4B ;

  ChatUser({super.key , required this.user , required this.id , required this.School , required this.csession,
    required this.EmailB , required this.RegisB , required this.Other4B , required this.Other3B ,
    required this.Other2B , required this.Other1B , required this.MotherB , required this.DepB , required this.BloodB});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int i = 0 ;
  void initState(){
    countTotalMfValue("h");
  }

  void countTotalMfValue(String id) async {
    int totalMfValue = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc( widget.user.id)
          .collection('Class')
          .get();
      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('total')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['total'];
            if (mfValue is int) {
              totalMfValue += mfValue;
            } else if (mfValue is double) {
              totalMfValue += mfValue.toInt();
            }
          }
        }
      });

      setState(() {
        i = totalMfValue;
      });
      if ( widget.user.feet != totalMfValue ){
        CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session');
        await collection.doc(widget.user.id).update({
          "feet" : totalMfValue,
        });

      }
      if ( widget.csession == widget.user.id){
        CollectionReference collectionn = FirebaseFirestore.instance.collection('School');
        await collectionn.doc(widget.id).update({
          "totse" : totalMfValue,
        });
      }


      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(widget.user.Name),
          SizedBox(width : 8),
          widget.csession == widget.user.id ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                border: Border.all(
                  color: Colors.red, // Set border color here
                  width: 2, // Set border width here
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text("Current Session", style : TextStyle(color : Colors.red, fontSize: 12)),
              )) : SizedBox(width : 1),
        ],
      ),
      onLongPress: (){
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this ?'),
            content: Text('Do you really want to delete this Sesssion including all Students'),
            actions: [
              TextButton(
                onPressed: () async {
                  CollectionReference collection1 = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session');
                  await collection1.doc(widget.user.id).update({
                    "ou":"Under Admin Approval for Delete",
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Success ! This Session will be Deleted once SuperAdmin confirms it'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),

              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async  {
                  CollectionReference collection1 = FirebaseFirestore.instance.collection('School');
                  await collection1.doc(widget.id).update({
                    "cse" : widget.user.id,
                  }) ;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('This Session is now CURRENT SESSION'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Make Current Session'),
              ),
            ],
          );
        },
      );
    },
      onTap: () async {
        if(widget.user.ou=="Under Admin Approval for Delete"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Class Will be Deleted Soon'),
                content: Text('Admin will delete this Session Manually ! Thanks for Patience'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Close the dialog
                      CollectionReference collection1 = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session');
                      await collection1.doc(widget.user.id).update({
                        "ou":"Delete",
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Success ! This Session is Live again'),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('No, Recover Session Now'),
                  ),
                ],
              );
            },
          );
        }else{
          Navigator.push(
              context, PageTransition(
              child: Class(id: widget.id, session_id: widget.user.id, Session : widget.user.Name, School: widget.School,
                EmailB: widget.EmailB, RegisB: widget.RegisB, Other4B: widget.Other4B,
                Other3B: widget.Other3B, Other2B: widget.Other2B, Other1B: widget.Other1B,
                MotherB: widget.MotherB, DepB: widget.DepB, BloodB: widget.BloodB,
              ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
          ));
          if ( widget.csession == "" || widget.csession == " "){
            CollectionReference collection1 = FirebaseFirestore.instance.collection('School');
            await collection1.doc(widget.id).update({
              "cse" : widget.user.id,
            }) ;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('This Session is now CURRENT SESSION'),
              ),
            );
          }
        }


      },
      trailing: widget.user.ou=="Under Admin Approval for Delete"?Icon(
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
                      'id' : customDocumentId ,
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
    required this.feet,
  });

  late final String Name;
  late final String id;
  late final int feet ;
  late final String ou;

  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    ou=json['ou']??"No";
    feet = json['feet'] ?? 6 ;
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['id'] = id ;
    data['feet'] = feet ;
    return data;
  }
}
