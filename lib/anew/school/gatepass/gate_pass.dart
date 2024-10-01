import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:galli_text_to_speech/text_to_speech.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/aextra/session.dart';
import 'package:student_managment_app/anew/parents/home/gatepass/gatepass.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/gate_keeper/history.dart';
import 'package:student_managment_app/school_class/gate_keeper/home.dart';

import 'package:student_managment_app/school_class/gate_keeper/sky/signature.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hand_signature/signature.dart';

import '../../../model/gatehistory.dart';


class GateSchooory extends StatefulWidget {
  SchoolModel user;bool onlyout;
  GateSchooory({super.key,required this.user,required this.onlyout});

  @override
  State<GateSchooory> createState() => _GateSchoooryState();
}

class _GateSchoooryState extends State<GateSchooory> {
  List<GateKeeper> list = [];
  int inn=0,out=0;
  late Map<String, dynamic> userMap;
  void countTotalMfValu() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.id)
        .collection('Gate').doc("History").collection(g)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        inn = querySnapshot.docs.length;
      });
      print("Number of documents with  in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      inn= count;
    });
  }
  void countTotalMfValu1() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.id)
        .collection('Gate')
        .doc("History")
        .collection(g)
        .get()
        .then((querySnapshot) {
      // Iterate over each document
      for (var doc in querySnapshot.docs) {
        if (doc.data().containsKey('timeleave')) {
          try {
            // Parse 'timeleave' as an integer if it is a string
            int timeleaveMillis = int.parse(doc['timeleave']);
            DateTime.fromMillisecondsSinceEpoch(timeleaveMillis);
            count++;
          } catch (e) {
            print("Invalid timeleave value: ${doc['timeleave']}");
          }
        }
      }
      setState(() {
        out = count;
      });
      print("Number of valid documents with 'timeout': $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
  }

  TextEditingController ud = TextEditingController();

  bool todaytime=true;
  void initState(){
    countTotalMfValu();
    countTotalMfValu1();
  }
  final Fire = FirebaseFirestore.instance;
  List<DateTime?> _dates = [
    DateTime.now().add(const Duration(days: 1)),
  ];
  DateTime h=DateTime.now();
  DateTime now = DateTime.now();
  String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    List<GateKeeper> list =[];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff029A81),
        leading:InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ),
        title: Text("Gate History",style:TextStyle(color:Colors.white)),
        actions: [
          SizedBox(width: 45,),
        ],
      ),
      floatingActionButton:Row(
        children: [
          SizedBox(width: 30,),
          Container(
            height:50,
            width:210,
            child: Row(
              children: [
                Container(
                  height: 50,width: 105,color: Colors.green,
                  child: Row(
                    children: [
                      SizedBox(width: 6,),
                      Icon(Icons.transit_enterexit,color: Colors.white,),
                      Text("   "+inn.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
                Container(height: 50,width: 105,color: Colors.redAccent,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Icon(Icons.login,color: Colors.white,),
                      Text("   "+out.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>Uty(list: list,id: widget.user.id,)),
              );
            },
            child: Icon(Icons.download,color:Colors.black,),
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            backgroundColor: !todaytime?Colors.red.shade50:Colors.red.shade800,
            onPressed: () async {
              print(_dates);
              List<DateTime?>? results = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(),
                dialogSize: const Size(325, 400),
                value: _dates,
                borderRadius: BorderRadius.circular(15),
              );
              print(_dates);
              if(results!=null){
                String h1=(results[0]!.day.toString()+"-"+results[0]!.month.toString()+"-"+results[0]!.year.toString()).toString();
                print(h1);
                setState(() {
                  g=h1;
                  now=results[0]!;
                });
                countTotalMfValu1();
                countTotalMfValu();
              }
            },
            child: Icon(Icons.today,color: Colors.white,),
          ),
          SizedBox(width: 5,),
        ],
      ),
      body: StreamBuilder(
        stream: Fire.collection('School')
            .doc(widget.user.id).collection("Gate").doc("History")
            .collection(g)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;

              final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
              final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999).millisecondsSinceEpoch;
              list = data
                  ?.map((e) => GateKeeper.fromJson(e.data()))
                  .where((doc) {
                final id = int.tryParse(doc.timenow); // Parse the id to an integer
                if (id == null) return false; // Skip if id is invalid
                if (todaytime) {
                  return id >= startOfDay && id <= endOfDay;
                }
                return true; // No filter if `todaytime` is false
              }).toList() ?? [];
              if (list.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Icon(Icons.bedtime_off_outlined, size: 30, color: Colors.red)),
                    Center(child: Text("No History", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
                    Center(child: Text("No one had entered or left this School on $g", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                  ],
                );
              }

              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUse(user: list[index], schoolid: widget.user.id);
                },
              );
          }
        },
      ),
    );
  }
}

class Uty extends StatelessWidget {
  List<GateKeeper> list;String id;
  Uty({super.key,required this.list,required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff029A81),
        leading:InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ),
        title: Text("Download Attendance",style:TextStyle(color:Colors.white)),
        actions: [
          SizedBox(width: 45,),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            await downloadCollection(list);
            Send.message(context, "Saved Successful", true);
          },
          child: Container(
            height:45,width:MediaQuery.of(context).size.width-15,
            decoration:BoxDecoration(
              borderRadius:BorderRadius.circular(7),
              color:Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                  spreadRadius: 5, // The extent to which the shadow spreads
                  blurRadius: 7, // The blur radius of the shadow
                  offset: Offset(0, 3), // The position of the shadow
                ),
              ],
            ),
            child: Center(child: Text("Download",style: TextStyle(
                color: Colors.white,
                fontFamily: "RobotoS",fontWeight: FontWeight.w800
            ),)),
          ),
        ),
      ],
      body: ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.only(top: 10),
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ChatUse(user: list[index], schoolid:id);
        },
      ),
    );
  }
  Future downloadCollection(List<GateKeeper>? docs) async {
    docs = docs ?? [];
    List<List<dynamic>> rows = [];

    // Add CSV header
    rows.add([
      "Gate ID",
      "Parent Name",
      "Student Name",
      "Class",
      "Purpose",
      "Arrival Time",
      "Departure Time",
    ]);

    // Add data rows
    docs.forEach((record) {
      rows.add([
        record.id,
        record.parentname,
        record.studentname,
        record.classs,
        record.reason,
        c(record.timenow),
        c(record.timeleave),
      ]);
    });

    String csv = const ListToCsvConverter().convert(rows);

    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) return;

    // Get storage directory and save file
    final directory = await getExternalStorageDirectory();
    final filePath = "${directory!.path}/GateHistory_${DateTime.now().toIso8601String()}.csv";
    final file = File(filePath);

    await file.writeAsString(csv);

    // Provide user feedback
  }
  String c(String epochString) {
    try {
      // Parse the string into an integer
      int millisecondsSinceEpoch = int.parse(epochString);

      // Convert the milliseconds since epoch to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

      // Format the time as hh:mm a (AM/PM format)
      String formattedTime = DateFormat('hh:mm a').format(dateTime);

      return formattedTime;
    } catch (e) {
      return "NA";
    }
  }
}
