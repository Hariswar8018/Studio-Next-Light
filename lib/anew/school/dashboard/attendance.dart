import 'package:flutter/material.dart';
import 'package:student_managment_app/aextra2/class.dart';
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

class SchoolA extends StatefulWidget {
  SchoolModel user;bool b;
  SchoolA({super.key,required this.user,required this.b});

  @override
  State<SchoolA> createState() => _SchoolAState();
}

class _SchoolAState extends State<SchoolA> {
  int i = 0;

  late String Dateiu;

  late String receive;
  bool smsend = false ;
  void initState() {
    DateTime date = DateTime.now();
    Dateiu = DateFormat('MMM, yyyy').format(date);
    countp1();
    countp();
    leavenow();
      String st = '${date.day}-${date.month}-${date.year}';
      countDocumentsWithPresent(widget.user.id, st);
      countp();
  }



  int prc = 0 ,prc1=0;
  int v=0;
  void countp() async {
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
          if (data.containsKey('pcount')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['pcount'];
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
        prc = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }

  void countp1() async {
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
          if (data.containsKey('pcount1')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['pcount1'];
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
        prc1 = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }

  int o = 0;
  void countDocumentsWithPresent(String id, String str) async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(id)
        .collection('Students')
        .where("Present", arrayContains: str)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with '$str' in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      i = count;
    });
  }

  Future<void> ah() async {
    String phoneNumber = '917000994158';
    String message = 'Hi, Studio Next Light! We are contacting you regarding Preium Service in your App';
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch WhatsApp');
    }
  }


  int em=0,emp=9,leave=0;

  void leavenow() async {
    int count = 0;
    DateTime date = DateTime.now();
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.id)
        .collection('Session').doc(widget.user.csession).collection("Leave")
        .get()
        .then((querySnapshot) async {
      count = querySnapshot.docs.length;
      setState(() async {
        leave = querySnapshot.docs.length;
      });
    }).catchError((error) {
      print("Error counting documents: $error");
    });
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff029A81),
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
        title: Center(child: Text("Student Attendance",style:TextStyle(color:Colors.white))),
        actions: [
          SizedBox(width: 45,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/school/6a722891e9c4d619362b66c545f9d0d2567543cb-853x480.gif",width: w),
            SizedBox(height: 14,),
            InkWell(
              onTap: (){
                if(widget.user.premium){
                  soop(context);
                  print(widget.user.Name);
                }else{
                  final snackBar = SnackBar(
                    content: Text('Oopss ! It\'s A premium Feature. Please Contact us to get Premium Service'),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Message Us',
                      onPressed: () async {
                        await ah();
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10),
                child: Container(
                  width: w-30,
                  height:90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: "ST"=="ST"?Colors.blue:Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(width: 5,),
                      Image.asset(height: 80,
                          "assets/images/school/7994392.gif"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scan to Mark Attendance',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Scan Student Card to mark Present',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('to Students Directly',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                        ],
                      ),
                      Spacer(),
                      "ST"=="ST"? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                        ),
                      ):SizedBox(),
                      SizedBox(width: 5,)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.school, size: 30),
              title: Text("Student\'s Attendance",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueAccent)),
              subtitle: Text("Total Student's Present / Absent"),
              trailing: InkWell(
                  onTap : (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassJust1(
                              id: widget.user.id, session_id: widget.user.csession,premium : widget.user.premium,
                              rem: false, sname:
                          'Refreshing Class',  r : false, name : widget.user.Name)),
                    );
                  },
                  child: Icon(Icons.refresh, color : Colors.black, size: 35,)),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassJust1(
                                  id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                                  rem: false, sname:
                              'Total Students', r : false, name : widget.user.Name)),
                        );
                      },
                      child: a(
                          context,
                          Icon(Icons.group, size: 57, color: Colors.white),
                          widget.user.totse.toString(),
                          "Total",
                          "Students",
                          Colors.lightBlue)),
                  GestureDetector(
                      onTap: () {
                        DateTime date = DateTime.now();
                        String st = '${date.day}-${date.month}-${date.year}';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Class_In_Out(
                                id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                                rem: false, sname:
                              'Total Present',  r : false, name : widget.user.Name, showonly: false,)),
                        );
                      },
                      child: a(
                          context,
                          Icon(Icons.person_add_alt_rounded,
                              size: 57, color: Colors.white),
                          prc.toString(),
                          "Total Present",
                          "( Check IN )",
                          Colors.teal))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          DateTime date = DateTime.now();
                          String st = '${date.day}-${date.month}-${date.year}';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassJust1(
                                    id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                                    rem: false, sname:
                                'Absentise Student',  r : false, name : widget.user.Name)),
                          );
                        },
                        child: a(
                            context,
                            Icon(Icons.person_remove_alt_1,
                                size: 57, color: Colors.white),
                            (widget.user.totse - prc).toString(),
                            "Total",
                            "Absent",
                            Colors.redAccent)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Class_In_Out(
                                  id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                                  rem: false, sname:
                                'Total Present',  r : false, name : widget.user.Name,showonly: false,)),
                          );
                        },
                        child: a(
                            context,
                            Icon(Icons.airplane_ticket_sharp,
                                size: 57, color: Colors.white),
                            prc1.toString(),
                            "Total Present",
                            "( Check Out )",
                            Colors.indigoAccent))
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LSee(user: widget.user)),
                          );
                        },
                        child: a(
                            context,
                            Icon(Icons.airplane_ticket_sharp,
                                size: 57, color: Colors.white),
                            leave.toString(),
                            "Applicable",
                            "Leave",
                            Color(0xffff9700))),
                    GestureDetector(
                        onTap: () {
                          DateTime date = DateTime.now();
                          String st = '${date.day}-${date.month}-${date.year}';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Class_In_Out(
                                  id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                                  rem: false, sname:
                                'Total Present',  r : false, name : widget.user.Name, showonly: true,)),
                          );
                        },
                        child: a(
                            context,
                            Icon(Icons.percent,
                                size: 57, color: Colors.white),
                            (prc-prc1).toString(),
                            "Student Check",
                            "Out Left",
                            Colors.indigo))
                  ],
                )),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassJust1(
                          id: widget.user.id, session_id: widget.user.csession, premium : widget.user.premium,
                          rem: true, sname:
                      'Mark Present & Absent', r : true, name : widget.user.Name)),
                );
              },
              child: asd(Icon(Icons.person_remove, color: Colors.red, size: 35),
                  "Mark Present / Absent", "Mark Absent to Absentise Students"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => fS( user : widget.user)),
                );
              },
              child: asd(Icon(Icons.account_box_sharp, color: Colors.indigo, size: 35),
                  "Leave Application", "Mark Students in Leave"),
            ),
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
  void soop(BuildContext context){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("What are the Student's doing ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 19)),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:[
                        FlutterSwitch(
                          showOnOff: true,
                          activeTextColor: Colors.black,
                          inactiveTextColor: Colors.blue,
                          value: smsend,
                          onToggle: (val) {
                            if(widget.user.smsend){
                              setState(() {
                                smsend = val;
                              });
                              Navigator.pop(context);
                              soop(context);
                            }else{
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("You don't have SMS Sending Premium Service"),
                                ),
                              );
                            }


                          },
                        ),
                        SizedBox(width: 12.0,),
                        Text('Send SMS : $smsend', style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0
                        ),)
                      ]
                  ),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QRViewExample(
                                          str: widget.user.Name,
                                          id: widget.user.id,sms:smsend,
                                          status: "In")),
                            );
                          },
                          child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(
                                  context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        "https://img.freepik.com/premium-vector/outside-building-boys-student-back-school_24911-48530.jpg"),
                                    Text("Check IN",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w700))
                                  ])),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QRViewExample(
                                          str: widget.user.Name,
                                          id: widget.user.id,sms: smsend,
                                          status: "Out")),
                            );
                          },
                          child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(
                                  context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        "https://static.vecteezy.com/system/resources/thumbnails/005/710/735/small_2x/cartoon-the-children-going-home-after-school-vector.jpg"),
                                    Text("Check OUT",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w700))
                                  ])),
                        )
                      ]),
                ],
              ),
            ),
          ),
        );
      },
    );
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
