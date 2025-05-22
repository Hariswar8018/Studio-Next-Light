import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_clock/one_clock.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/aextra2/Attendance/class_in_out.dart';
import 'package:student_managment_app/classroom_universal/academis/home/see_all_employee.dart';
import 'package:student_managment_app/classroom_universal/logs/all_students.dart';
import 'package:student_managment_app/classroom_universal/notice.dart';
import 'package:student_managment_app/classroom_universal/parents_meeting.dart';
import 'package:student_managment_app/classroom_universal/sticky.dart';
import 'package:student_managment_app/classroom_universal/timetable.dart';
import 'package:student_managment_app/helpline/help.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';

import '../../classroom_universal/chatgpt.dart';
import 'student_data/all_see_st.dart';
import 'dart:math';

class Classh extends StatefulWidget {

  Classh({required this.user,required this.c });
  SchoolModel user;UserModel c;

  @override
  State<Classh> createState() => _ClasshState();
}

class _ClasshState extends State<Classh> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String getRandomQuote() {
    final quotes = [
      "Teaching is the art of lighting a fire, not filling a bucket.",
      "Every question asked in class is a step toward growth.",
      "A teacher plants seeds of knowledge that grow forever.",
      "The classroom is a laboratory where future dreams are tested.",
      "Every student holds a hidden spark; a teacher's job is to ignite it.",
      "Great teachers don't just teach lessons; they inspire journeys.",
      "Learning is a two-way street, and teachers are the ultimate guides.",
      "The best classroom moments aren't graded—they're cherished.",
      "Teaching is shaping minds while crafting hearts for a brighter tomorrow."
    ];

    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
  String getRandomImage() {
    final quotes = [
      "assets/a1.jpg",
      "assets/a2.jpg",
      "assets/a3.jpg"
    ];
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer:Global.buildDrawer(context),
        key: _scaffoldKey,
        appBar: AppBar(
          leading: CircleAvatar(backgroundImage: NetworkImage(widget.user.Pic_link)),
          title: Text("Class Teacher Portal"),
          actions: [
            IconButton(onPressed: (){
              _scaffoldKey.currentState?.openDrawer();
            }, icon: Icon(Icons.more_vert_outlined))
          ],
        ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-20,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                  border:Border.all(
                    color: Colors.black
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(getRandomImage()),fit: BoxFit.cover)
                      ),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Good Morning Teacher",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),),
                        Container(
                            width: w-150,
                            child: Text(getRandomQuote(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("    Dashboard",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  print(widget.c.toJson());
                                  print(widget.user.toJson());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Studentsn(
                                          showonly: true, id: widget.user.id, session_id: widget.user.csession, premium: widget.user.premium,
                                          sname: widget.c.school, rem: false, class_id: widget.c.classid,
                                          h: false, st: '', Class: '',)),
                                  );
                                },
                                child: q(context,"assets/student-svgrepo-com.svg","Students")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticeMeeting(clas: widget.c.classid, school: widget.user.id, session: widget.user.csession, teacher: true, id: '', type: type_class.homework,)),
                                  );
                                },
                                child: q(context,"assets/homework-svgrepo-com.svg","Homework")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Timetablee(clas: widget.c.classid, school: widget.user.id, session: widget.user.csession, teacher: true, id: '',)),
                                  );
                                },
                                child: q(context,"assets/schedule-svgrepo-com.svg","Timetable")),
                            InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: Sticky(id: widget.user.id, clas:  widget.c.classid, school: widget.user.id, session:  widget.user.csession, teacher: true,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/parents/note-svgrepo-com.svg","Notes")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-20,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade800,
                      Colors.lightBlue.shade500,
                      Colors.blue.shade800,
                      Colors.lightBlue.shade500,
                      Colors.lightBlue.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.3, 0.5, 0.7, 0.9], // Adjust the stops to control the gradient transition
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(widget.user.Pic),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_city,size: 17,color:Colors.white),
                            SizedBox(width: 3,),
                            Text("On Campus : "+widget.user.Address,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/35,color: Colors.white),),
                          ],
                        ),
                        SizedBox(height:7),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.wb_cloudy,color: Colors.white,size: 50,),
                            SizedBox(width:7),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(capitalizeFirstLetterOfEachWord(widget.user.weather),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: w/25),),
                                Text("Temp : ${widget.user.temp.toInt()} °C       Humidity : ${widget.user.humidity} g/V",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: w/45),),
                                Text("Wind : ${widget.user.wind} km/hr       Pressure : ${widget.user.pressure} Pa" ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: w/45),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 6,),
                        Container(
                          height: 10,
                          child: DigitalClock(
                              showSeconds: true,
                              isLive:true,textScaleFactor: 0.8,digitalClockTextColor: Colors.white,
                              datetime: DateTime.now()),
                        ),
                        SizedBox(height:7),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("    Student Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  print(widget.c.toJson());
                                  print(widget.user.toJson());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Studentsn(
                                          showonly: true, id: widget.user.id, session_id: widget.user.csession, premium: widget.user.premium,
                                          sname: widget.c.school, rem: false, class_id: widget.c.classid,
                                          h: false, st: '', Class: '',)),
                                  );
                                },
                                child: q(context,"assets/student-svgrepo-com.svg","Students")),
                            InkWell(
                                onTap: (){
                                  //AIzaSyDJGQ3-DoQ5YgFk_fQqk0d3LcfCQcRw0V0
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage1()),
                                  );
                                },
                                child: qy(context,"assets/images/school/cruise-ship-svgrepo-com.svg","Ask Tiara")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticeMeeting(
                                          clas: widget.c.classid, school: widget.user.id, session: widget.user.csession,
                                          teacher: true, id: "", type: type_class.homework,)),
                                  );
                                },
                                child: q(context,"assets/homework-svgrepo-com.svg","Homework")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticeMeeting(
                                          clas: widget.c.classid, school: widget.user.id, session: widget.user.csession,
                                          teacher: true, id: '', type: type_class.meeting,)),
                                  );
                                },
                                child: q(context,"assets/family-svgrepo-com.svg","Parents Meeting")),
                          ],
                        ),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticeMeeting(
                                          clas: widget.c.classid, school: widget.user.id, session: widget.user.csession,
                                          teacher: true, id: '', type: type_class.notice,)),
                                  );
                                },
                                child: q(context,"assets/images/school/law-book-law-svgrepo-com.svg","Notices")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => All_My_Teachers(
                                          school: widget.user.id, admi: true, classid: widget.c.classid,
                                          )),
                                  );
                                },
                                child: q(context,"assets/teacher-light-skin-tone-svgrepo-com.svg","Teachers")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoticeMeeting(
                                          clas: widget.c.classid, school: widget.user.id, session: widget.user.csession,
                                          teacher: true, id: '', type: type_class.proposal,)),
                                  );
                                },
                                child: q(context,"assets/research-svgrepo-com.svg","Proposals")),
                            InkWell(
                                onTap: (){
                                  print(widget.c.toJson());
                                  print(widget.user.toJson());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Studentsn(
                                            showonly: true, id: widget.user.id, session_id: widget.user.csession, premium: widget.user.premium,
                                            sname: widget.c.school, rem: false, class_id: widget.c.classid,
                                            h: false, st: '', Class: '',parents_verify:true)),
                                  );
                                },
                                child: q(context,"assets/images/school/profile-user-svgrepo-com.svg","Verification")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("    Security Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Studentsn(
                                          showonly: false, id: widget.user.id, session_id: widget.user.csession, premium: widget.user.premium,
                                          sname: widget.c.school, rem: false, class_id: widget.c.classid,
                                          h: false, st: '', Class: '',)),
                                  );
                                },
                                child: q(context,"assets/pin-code-svgrepo-com.svg","Student Code")),
                            InkWell(
                                onTap: (){
                                  print(widget.c.toJson());
                                  print(widget.user.toJson());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Studentsn(
                                          showonly: true, id: widget.user.id, session_id: widget.user.csession, premium: widget.user.premium,
                                          sname: widget.c.school, rem: false, class_id: widget.c.classid,
                                          h: false, st: '', Class: '',parents_verify:true)),
                                  );
                                },
                                child: q(context,"assets/images/school/profile-user-svgrepo-com.svg","Parent Verify")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Logs(
                                          showonly: true, id: widget.user.id, session_id: widget.user.csession, premium: widget.user.premium,
                                          sname: widget.c.school, rem: false, class_id: widget.c.classid,
                                          h: false, st: '', Class: '', type: logtype.LoginSecurity,)),
                                  );
                                },
                                child: q(context,"assets/images/school/attendance-svgrepo-com.svg","Security")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Emergency()),
                                  );
                                },
                                child: q(context,"assets/police-car-light-svgrepo-com.svg","Emergency")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      )
    );
  }
  String capitalizeFirstLetterOfEachWord(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word; // Handle empty strings or spaces
      }
    }).join(' ');
  }
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return Column(
      children: [
        Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: d-50,
              ),
            )),
        SizedBox(height: 7),
        Text(str, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
      ],
    );
  }
  Widget qy(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return Column(
      children: [
        Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage("assets/tiara.png"),
                fit: BoxFit.contain
              )
            )),
        SizedBox(height: 7),
        Text(str, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
      ],
    );
  }
}

