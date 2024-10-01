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

class ClassJust2 extends StatefulWidget {
  String id; bool st ;  bool re ; String na ; bool premium ;
  String session_id; bool rem ;  int sname ; int sname2 ;
  ClassJust2({super.key, required this.re, required this.na, required this.premium, required this.id, required this.sname, required this.sname2, required this.session_id, required this.st, required this.rem});

  @override
  State<ClassJust2> createState() => _ClassJust1State();
}

class _ClassJust1State extends State<ClassJust2> {
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
          title: Text('Report'),
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
      body: Column(
        children: [
          // Header row
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.black), // Add border to the table
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black), // Add border to the bottom of the row
                    ),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Class",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "DUE Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "Fee Set",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "Expected",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "No.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Data rows
          Expanded(
            child: StreamBuilder(
              stream: Fire.collection('School')
                  .doc(widget.id)
                  .collection('Session')
                  .doc(widget.session_id)
                  .collection("Class")
                  .snapshots(),
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
                            id: widget.id, pr : widget.premium,
                            sessionid: widget.session_id,
                            st: widget.st, name : widget.na,
                            rem: widget.rem,
                            sname: widget.sname.toString(),
                            prese: _switchValue);
                      },
                    );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Table(
              border: TableBorder.all(color: Colors.black), // Add border to the table
              columnWidths: {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black), // Add border to the bottom of the row
                    ),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Due ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          addCommas(widget.sname),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Table(
              border: TableBorder.all(color: Colors.black), // Add border to the table
              columnWidths: {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black), // Add border to the bottom of the row
                    ),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Expected ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          addCommas(widget.sname2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return "₹" + formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) +
          ',' +
          formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    return "₹" + formattedNumber ;
  }
}


class ChatUser extends StatefulWidget {
  SessionModel user;
  String id; bool pr ;
  String sname;
  bool prese;
  String sessionid; String name ;
  bool st;
  bool rem;
  ChatUser(
      {super.key,
        required this.user,
        required this.sname, required this.pr,
        required this.prese,
        required this.st, required this.name,
        required this.id,
        required this.sessionid,
        required this.rem});

  @override
  State<ChatUser> createState() => _ChatUserState();
}


class _ChatUserState extends State<ChatUser> {
  int j = 0, i = 0;
  void initState(){

    countTotalMfValue();
    as();
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap : (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>StudentsJust1( premium : widget.pr, sname : widget.sname, rem : widget.rem,id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
            Class : widget.user.Name, h: widget.st, st: widget.name ,
          )),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder.all(color: Colors.black), // Add border to the table
          columnWidths: {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black), // Add border to the bottom of the row
                ),
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Class : " + widget.user.Name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
      addCommas(widget.user.feet),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      "₹" + widget.user.Total_Fee,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child:
                    Center(
                      child: Text(
                  addCommas(widget.user.sset),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                    ),
                  ), TableCell(
                  child:
                  Center(
                    child: Text(
                      j.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return "₹" + formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) +
          ',' +
          formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    return "₹" + formattedNumber;
  }
}


