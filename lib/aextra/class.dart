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
import 'package:student_managment_app/after_login/students.dart';
import 'package:student_managment_app/model/student_model.dart';

class ClassJust extends StatelessWidget {
  String id; bool st ;
  String session_id; bool rem;  String sname ;
  String Session;
  ClassJust({super.key, required this.id, required this.sname,required this.session_id, required this.Session, required this.st, required this.rem});

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
                    Session : Session , st : st, rem : rem, sname : sname,
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
  SessionModel user;
  String id ;  String sname ;
  String sessionid; bool st ; bool rem ;
  String Session ;
  ChatUser({super.key, required this.user,required this.sname, required this.st , required this.id, required this.sessionid, required this. Session, required this.rem});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int i = 0 ;
  void initState(){
    countTotalMfValue("j") ;
  }

  void countTotalMfValue(String id) async {
    int totalMfValue = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc( widget.sessionid)
          .collection('Class')
          .doc(widget.user.id)
          .collection('Student')
          .get();
      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('Mf')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['Mf'];
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

      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }

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
            MaterialPageRoute(builder: (context) =>StudentsJust(sname : widget.sname, rem : widget.rem,id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
              Session : widget.Session, Class : widget.user.Name ,
            )),
          );
        }else{
          print("Here");
          if (widget.st){
            print("OOOo");
            StudentModel u = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>StudentsJust(sname : widget.sname, rem : widget.rem, id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
                Session : widget.Session, Class : widget.user.Name ,
              )),
            );
            Navigator.pop(context, u);
          }else{
            print("This getting");
            Navigator.pop(context, widget.user);
          }
        }

      },
      trailing :  widget.sname=="NA"?SizedBox():Text( addCommas(i),  style : TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return "₹" + formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    formattedNumber = "₹" + formattedNumber ;
    return formattedNumber;
  }
}
