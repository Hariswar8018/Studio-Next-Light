import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/aextra/students.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/aextra2/students.dart';
import 'package:student_managment_app/model/student_model.dart';

class ClassJust1 extends StatefulWidget {
  String id; bool r ; String name ; bool premium ;
  String session_id; bool rem;  String sname ;
  ClassJust1({super.key, required this.id, required this.r, required this.premium,  required this.name, required this.sname,required this.session_id,  required this.rem});

  @override
  State<ClassJust1> createState() => _ClassJust1State();
}

class _ClassJust1State extends State<ClassJust1> {
  List<SessionModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text(widget.sname),
        actions:[
          Switch(
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
        ]
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(widget.id).collection('Session').doc(widget.session_id).collection("Class").snapshots(),
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
                    user: list[index], id: widget.id, sessionid: widget.session_id, r : widget.r , name : widget.name,
                      rem : widget.rem, sname : widget.sname, prese : _switchValue, pr : widget.premium
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
  SessionModel user; bool pr ;
  String id ;  String sname ; bool prese ;
  String sessionid;  bool rem ; bool r ; String name ;
  ChatUser({super.key, required this.user,required this.sname, required this.pr,  required this.r, required this.name, required this.prese ,  required this.id, required this.sessionid,  required this.rem});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int i = 0 ; int j = 0 ;
  void initState(){
    countDocumentsWithPresent();
    countTotalMfValue();as();
    countDocumentsWithPresent1();
  }
  void countTotalMfValue() async {
    int count = 0;
    try {
     await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc( widget.sessionid)
          .collection('Class')
          .doc(widget.user.id)
          .collection('Student')
          .get().then((querySnapshot) {
       count = querySnapshot.docs.length;
       setState(() {
         j = querySnapshot.docs.length;
       });
     }) ;
    }catch (error) {
       print("Error counting total 'Mf' value: $error");
     }
    }

  void as() async {
  CollectionReference collection = FirebaseFirestore.instance.collection('School')
      .doc(widget.id).collection('Session')
      .doc(widget.sessionid).collection('Class');
  await collection.doc(widget.user.id).update({
    "pcount" : i,
  });
}
  void countDocumentsWithPresent() async {
    int count = 0;
    DateTime date = DateTime.now();
    String str = '${date.day}-${date.month}-${date.year}';
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.id)
        .collection('Session').doc(widget.sessionid).collection("Class").doc(
        widget.user.id).collection("Student")
        .where("Present", arrayContains: str)
        .get()
        .then((querySnapshot) async {
      count = querySnapshot.docs.length;
      setState(() async {
        i = querySnapshot.docs.length;
      });
      CollectionReference collection = FirebaseFirestore.instance.collection(
          'School')
          .doc(widget.id).collection('Session')
          .doc(widget.sessionid).collection('Class');
      await collection.doc(widget.user.id).update({
        "pcount": querySnapshot.docs.length,
      });
    }).catchError((error) {
      print("Error counting documents: $error");
    });
  }

  void countDocumentsWithPresent1() async {
    int count = 0;
    DateTime date = DateTime.now();
    String str = '${date.day}-${date.month}-${date.year}';

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc(widget.sessionid)
          .collection("Class")
          .doc(widget.user.id)
          .collection("Student")
          .where("Present1", arrayContains: str)
          .get();

      count = querySnapshot.docs.length;

      setState(() {
        ij = count;
      });

      CollectionReference collection = FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc(widget.sessionid)
          .collection('Class');

      await collection.doc(widget.user.id).update({
        "pcount1": count,
      });

    } catch (error) {
      print("Error counting documents: $error");
    }
  }
  int ij=0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Class : " + widget.user.Name),
      onTap: () async {
        print(widget.rem);
        if ( widget.rem ){
          print("Gone be");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>StudentsJust1(sname : widget.sname, rem : widget.rem,id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
               Class : widget.user.Name, h: widget.r, st: widget.name , premium : widget.pr
            )),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>StudentsJust1(sname : widget.sname, rem : widget.rem,id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
              Class : widget.user.Name, h: widget.r, st: widget.name , premium : widget.pr
            )),
          );
        }

      },
      trailing : RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            widget.prese? TextSpan(
              text: addCommas(i),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.blue, fontSize : 23),
            ):TextSpan(
              text: addCommas(j-i),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.red, fontSize : 23),
            ),
            TextSpan(
              text: ' / ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: addCommas(j),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.black, fontSize : 18),
            ),
          ],
        ),
      ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return  formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    formattedNumber =  formattedNumber ;
    return formattedNumber;
  }
}
