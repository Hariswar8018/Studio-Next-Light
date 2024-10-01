import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/aextra2/Attendance/class_in_out.dart';
import 'package:student_managment_app/aextra2/classi.dart';
import 'package:student_managment_app/aextra/marksheet.dart';
import 'package:student_managment_app/afeeeeeee/all_employee.dart';
import 'package:student_managment_app/afeeeeeee/declare_holiday.dart';
import 'package:student_managment_app/afeeeeeee/absent.dart';
import 'package:student_managment_app/afeeeeeee/fee.dart';
import 'package:student_managment_app/attendance/make_leave.dart';
import 'package:student_managment_app/attendance/sc.dart';
import 'package:student_managment_app/attendance/sc2.dart';
import 'package:student_managment_app/attendance/students.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/aextra/session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:student_managment_app/aextra2/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';


class SchoolF extends StatefulWidget {
  SchoolModel user;bool b;
  SchoolF({super.key,required this.user,required this.b});

  @override
  State<SchoolF> createState() => _SchoolFState();
}

class _SchoolFState extends State<SchoolF> {
  int monthly  = 0 ;
  int yearly = 0 ;
  late String Dateiu;
  int full = 0 ;
  void initState() {
    DateTime date = DateTime.now();
    Dateiu = DateFormat('MMM, yyyy').format(date);
    String st = '${date.day}-${date.month}-${date.year}';
    countTotalMfValue();
    countTotalMfValu();
    countTotalMfValue1();
  }
  void countTotalMfValu() async {
    int totalMfValue = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
          .collection('Session')
          .doc(widget.user.csession).collection("Class").get();
      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('feet')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['feet'];
            if (mfValue is int) {
              totalMfValue += mfValue;
              v+=1;
            } else if (mfValue is double) {
              totalMfValue += mfValue.toInt();
            }else{
              totalMfValue += int.parse(mfValue) ;
            }
          }
        }
      });
      setState(() {
        full = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }
  int v=0;
  void countTotalMfValue() async {
    int totalMfValue = 0;
    DateTime now = DateTime.now();
    int Mo = now.month;
    int Ye = now.year;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
          .collection('Fee')
          .doc(Ye.toString()).collection("Month").doc(Mo.toString()).collection("Day").get();

      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('Total_Fee')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['Total_Fee'];
            if (mfValue is int) {
              totalMfValue += mfValue;
            } else if (mfValue is double) {
              totalMfValue += mfValue.toInt();
            }else{
              totalMfValue += int.parse(mfValue) ;
            }
          }
        }
      });
      setState(() {
        monthly = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }

  void countTotalMfValue1() async {
    int totalMfValue = 0;
    DateTime now = DateTime.now();
    int Mo = now.month;
    int Ye = now.year;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
          .collection('Fee')
          .doc(Ye.toString()).collection("Month").get();

      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('Fee')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['Fee'];
            if (mfValue is int) {
              totalMfValue += mfValue;
            } else if (mfValue is double) {
              totalMfValue += mfValue.toInt();
            }else{
              totalMfValue += int.parse(mfValue) ;
            }
          }
        }
      });
      setState(() {
        yearly = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4489C7),
        leading: widget.b?InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ):SizedBox(),
        title: Center(child: Text("Finance Report",style:TextStyle(color:Colors.white))),
        actions: [
          SizedBox(width: 45,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Fee(id: widget.user.id, user: widget.user, b : false)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: ac(
                              context,
                              Icon(Icons.credit_card_off,
                                  size: 57, color: Colors.white),
                              "₹ " + sd(o),
                              "This Session",
                              "Expected",
                              Colors.lightGreen)),
                      GestureDetector(
                          onTap: () {},
                          child: ac(
                              context,
                              Icon(Icons.credit_card,
                                  size: 57, color: Colors.white),
                              "₹ " + sd(full),
                              "This Session",
                              "Due",
                              Colors.indigo))
                    ],
                  )),
              ) ,
            SizedBox(height: 10),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Fee(id: widget.user.id, user: widget.user, b : false)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: ac(
                              context,
                              Icon(Icons.calendar_today,
                                  size: 57, color: Colors.white),
                              "₹ " + sd(monthly),
                              "This Month",
                              "Paid",
                              Colors.orange)),
                      GestureDetector(
                          onTap: () {},
                          child: ac(
                              context,
                              Icon(Icons.perm_contact_calendar,
                                  size: 57, color: Colors.white),
                              "₹ " + sd(yearly),
                              "This Year",
                              "Paid",
                              Colors.red))
                    ],
                  )),
              ) ,
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddFee(user: widget.user)),
                  );
                },
                child: asd(
                    Icon(Icons.call_received,
                        color: Colors.blueAccent, size: 35),
                    "Add Entry",
                    "Add Entry when A fee is Paid")) ,
           InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Fee(id: widget.user.id, user: widget.user, b : false)),
                  );
                },
                child: asd(
                    Icon(Icons.dashboard, color: Colors.blueAccent, size: 35), "Show Entries", "Show All Entries Month Wise")),
           InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassJust2(
                          id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                          rem: true, sname:
                        full, st: true, sname2: o, re: false, na: widget.user.Name,)),
                  );
                },
                child: asd(
                    Icon(Icons.panorama_vertical_select,
                        color: Colors.blueAccent, size: 35),
                    "Report",
                    "Submit Report monthwise")),
           InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SessionJust(id: widget.user.id, student: false, reminder: true, sname : widget.user.Name)),
                  );
                },
                child: asd(
                    Icon(Icons.alarm_add, color: Colors.blueAccent, size: 35),
                    "Reminder",
                    "Send Reminder of unpaid payments")),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Fee(id: widget.user.id, user: widget.user, b : true)),
                  );
                },
                child: asd(
                    Icon(Icons.receipt_long,
                        color: Colors.blueAccent, size: 35),
                    "Send / Download Receipt",
                    "Send / Download Receipt to Childrens")),
          ],
        ),
      ),
    );
  }
  String sd(int n) {
    if (n> 1000000000 ){
      double p = n / 100000 ;
      n = p.toInt();
      return addCommas(n, " A");
    } else if(n > 10000000) {
      double p = n / 100000 ;
      n = p.toInt();
      return addCommas(n, " C");
    } else if (n > 99999) {
      double p = n / 1000 ;
      n = p.toInt();
      // If number is greater than 99,999, use addCommas function with suffix "K"
      return addCommas(n, " L");
    } else {
      // If number is less than or equal to 999, just return the number itself
      return addCommas(n, "");
    }
  }

  String addCommas(int number, String sd) {
    String formattedNumber = number.toString();
    if(sd == ""){
      if (formattedNumber.length <= 3) {
        return  formattedNumber ; // If number is less than or equal to 3 digits, no need for commas
      }
      int index = formattedNumber.length - 3;
      while (index > 0) {
        formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
        index -= 2; // Move to previous comma position (every two digits)
      }
      formattedNumber =  formattedNumber  ;
    }else{
      if (formattedNumber.length <= 2) {
        return  formattedNumber + sd; // If number is less than or equal to 3 digits, no need for commas
      }
      int index = formattedNumber.length - 2;
      while (index > 0) {
        formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
        index -= 2; // Move to previous comma position (every two digits)
      }
      formattedNumber =  formattedNumber + sd ;
    }
    return formattedNumber;
  }


  Widget asd(Widget d, String s1, String s2) {
    return ListTile(
      leading: d,
      title: Text(s1,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.blueAccent)),
      subtitle: Text(s2),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueAccent),
    );
  }
  int o = 0;
  Widget a(context, Icon ah, String number, String st1, String st2, Color c) {
    return Container(
        color: c,
        width: MediaQuery.of(context).size.width / 2 - 10,
        height: MediaQuery.of(context).size.width / 2 - 40,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ah,
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 5),
                    child: Text(number,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ],
              ),
              Text(
                st1,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                textAlign: TextAlign.left,
              ),
              Text(
                st2,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ));
  }

  Widget ac(context, Icon ah, String number, String st1, String st2, Color c) {
    return Container(
        color: c,
        width: MediaQuery.of(context).size.width / 2 - 10,
        height: MediaQuery.of(context).size.width / 2 - 40,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ah,
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 5),
                    child: Text(number,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ],
              ),
              Text(
                st1,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                textAlign: TextAlign.left,
              ),
              Text(
                st2,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ));
  }
}
