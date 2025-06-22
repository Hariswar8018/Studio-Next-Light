import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
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
                  builder: (context) => Add(id: id, upgrade: false, sessionid: '',),
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
              title: Text('Advance Function ?'),
              content: Text('Use this Function for CRITICAL PROBLEMS '),
              actions: [
                InkWell(
                  onTap: currentsession,
                  child: Container(
                    width: MediaQuery.of(context).size.width-40,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                    child: Center(child: Text("Make Current Session")),
                  ),
                ),SizedBox(height: 10,),
                InkWell(
                  onTap: upgrade,
                  child: Container(
                    width: MediaQuery.of(context).size.width-40,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade200,
                    ),
                    child: Center(child: Text("Upgrade Session")),
                  ),
                ),SizedBox(height: 10,),
                InkWell(
                  onTap: delete,
                  child: Container(
                    width: MediaQuery.of(context).size.width-40,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red.shade200,
                    ),
                    child: Center(child: Text("Delete Session")),
                  ),
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
              ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
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

  void delete(){
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this ?'),
          content: Text('Do you really want to delete this Sesssion including all Students.\n IT\'S PERAMANENT DELETE'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  CollectionReference collection1 = FirebaseFirestore.instance
                      .collection('School').doc(widget.id).collection(
                      'Session');
                  await collection1.doc(widget.user.id).update({
                    "ou": "Under Admin Approval for Delete",
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Success ! This Session will be Deleted once SuperAdmin confirms it'),
                    ),
                  );
                }catch(e){
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                    ),
                  );
                }
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
          ],
        );
      },
    );
  }
  void upgrade(){
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upgrade ?'),
          content: Text('Is Safer .....Student and Teachers could still use Previous Login Details. No Critical change !'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Add(id: widget.id, upgrade: true, sessionid: widget.user.id,),
                    ),
                  );
                }catch(e){
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                    ),
                  );
                }
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
          ],
        );
      },
    );
  }
  void currentsession(){
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make this Session as Current Session ?'),
          content: Text('Do you really want to make this as Current Session ! This may be Critical. All studennts and teachers registered in before Current Session can\'t able to Login nor Scan , and other problems'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  CollectionReference collection1 = FirebaseFirestore.instance.collection('School');
                  await collection1.doc(widget.id).update({
                    "cse" : widget.user.id,
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Success ! This Session is Current Session'),
                    ),
                  );
                }catch(e){
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                    ),
                  );
                }
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
          ],
        );
      },
    );
  }
}

class Add extends StatelessWidget {
  String id;
  bool upgrade ; String sessionid;
  Add({super.key, required this.id,required this.upgrade,required this.sessionid});

  final TextEditingController sessionNameController = TextEditingController();
  String s = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(upgrade?"Upgrade Session":"Add Session"),
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
                  labelText: 'New Session Name',
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
                text: upgrade?"Upgrade Session":'Add Session Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  if(upgrade){
                    try{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session');
                    await collection.doc(sessionid).set({
                      'Name': sessionNameController.text,
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
                    return ;
                  }
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session');
                    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString(); // Replace with your own custom ID
                    await collection.doc(customDocumentId).set({
                      'Name': sessionNameController.text,
                      'id' : customDocumentId ,
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
