import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:one_clock/one_clock.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/after_login/calender.dart';
import 'package:student_managment_app/anew/parents/home/classroom/notice.dart';
import 'package:student_managment_app/anew/parents/home/gatepass/gatepass.dart';
import 'package:student_managment_app/anew/parents/home/sta.dart';
import 'package:student_managment_app/classroom_universal/chat.dart';
import 'package:student_managment_app/classroom_universal/chatgpt.dart';
import 'package:student_managment_app/classroom_universal/notice.dart';
import 'package:student_managment_app/classroom_universal/parents_meeting.dart';
import 'package:student_managment_app/classroom_universal/sticky.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';

import '../../../model/student_model.dart';
import '../../../school_class/bus/check_all_bus.dart';

class StHome extends StatelessWidget {
  StudentModel user; bool parent;SchoolModel sch;
   StHome({super.key,required this.parent,required this.user,required this.sch});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String getDateEntry() {
    String today = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    for (var entry in user.dict1) {
      if (entry.containsKey(today)) {
        DateTime dateTime = DateTime.parse(entry[today]);

        String formattedTime = DateFormat('HH:mm').format(dateTime);
        return formattedTime;  // Return the time in HH:MM format
      }
    }
    return "NA";
  }
  String getDateEntry1() {
    String today = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    for (var entry in user.dict2) {
      if (entry.containsKey(today)) {
        DateTime dateTime = DateTime.parse(entry[today]);

        String formattedTime = DateFormat('HH:mm').format(dateTime);
        return formattedTime;  // Return the time in HH:MM format
      }
    }
    return "NA";
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      drawer:Global.buildDrawer(context),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff029A81),
        leading:InkWell(
          onTap:() {
            _scaffoldKey.currentState?.openDrawer();  // Opens the drawer
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.more_vert,color: Color(0xff029A81),size: 22,)),
            ),
          ),
        ),
        title: Text(!parent?"Parents Portal":"Student Portal",style:TextStyle(color:Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Center(
              child: Container(
                width: w-20,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade200,   // Very light blue
                      Colors.lightBlue.shade100,  // Light blue
                      Colors.blue.shade200,       // Medium blue
                      Colors.lightBlue.shade100,    // Darker blue
                      Colors.lightBlue.shade100,     // Indigo, dark blueish tone
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.3, 0.5, 0.7, 0.9], // Adjust the stops to control the gradient transition
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(user.pic),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.Name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/18),),
                        Text("Class : "+user.Class+" (${user.Section})",style: TextStyle(fontWeight: FontWeight.w400,fontSize: w/25),),
                        SizedBox(height: 10,),
                        Text("Check In : ${getDateEntry()}        Check Out : ${getDateEntry1()}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/28),)
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
                        Text("    Classroom",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Send.message(context, "No data Exist ! Student is Absent Today or in way to our School", false);
                                },
                                child: q(context,"assets/images/school/report5.svg","Today Report")),
                            InkWell(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final String id = prefs.getString('school') ?? "None";
                                  final String clas = prefs.getString('class') ?? "None";
                                  final String session = prefs.getString('session') ?? "None";
                                  final String regist = prefs.getString('id') ?? "None";
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: MyCalenderPage(idi: user
                                              .Registration_number, df: id,
                                            classi: clas, sessioni: session, user: user,
                                          ),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 400)));
                                },
                                child: q(context,"assets/images/parents/homework-svgrepo-com.svg","Attendance")),
                            InkWell(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final String id = prefs.getString('school') ?? "None";
                                  final String clas = prefs.getString('class') ?? "None";
                                  final String session = prefs.getString('session') ?? "None";
                                  final String regist = prefs.getString('id') ?? "None";
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: NoticeP(id: regist, clas: clas, school: id, session: session,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/parents/alert-bell-notice-svgrepo-com (2).svg","Notice")),
                            InkWell(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final String id = prefs.getString('school') ?? "None";
                                  final String clas = prefs.getString('class') ?? "None";
                                  final String session = prefs.getString('session') ?? "None";
                                  final String regist = prefs.getString('id') ?? "None";
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: Sticky(id: regist, clas: clas, school: id, session: session, teacher: false,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/parents/note-svgrepo-com.svg","Notes")),
                          ],
                        ),
                        SizedBox(height: 9,),
                       /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q(context,"assets/images/school/lecture-class-svgrepo-com.svg","Timetable"),
                            InkWell(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                },
                                child: q(context,"assets/images/school/schedule-svgrepo-com.svg","Upcoming")),
                            q(context,"assets/images/parents/school-material-writer-svgrepo-com.svg","Assignment"),
                            q(context,"assets/images/school/profile-user-svgrepo-com.svg","Profile"),
                          ],
                        ),*/
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
                      backgroundImage: NetworkImage(sch.Pic),
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
                            Text("On Campus : "+sch.Address,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/35,color: Colors.white),),
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
                                Text(capitalizeFirstLetterOfEachWord(sch.weather),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: w/25),),
                                Text("Temp : ${hju(sch.temp)} °C              Humidity : ${sch.humidity} g/V",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: w/45),),
                                Text("Wind : ${sch.wind} km/hr       Pressure : ${sch.pressure} Pa" ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: w/45),),
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
                        Text("    Bus Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        (user.bus&&user.busid.isNotEmpty)?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () async {

                                },
                                child: q(context,"assets/newportal/location-pin-svgrepo-com.svg","My Location")),
                            q(context,"assets/newportal/bus-svgrepo-com.svg","Track Bus"),
                            q(context,"assets/newportal/calendar-svgrepo-com.svg","Bus Timing"),
                            q(context,"assets/newportal/route-start-svgrepo-com.svg","Check Route"),
                          ],
                        ):
                        (user.busid.isNotEmpty?ListTile(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>CheckAllBus(schoolid: user.School_id_one,
                                studentid: user.Registration_number,)),
                            );
                          },
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/newportal/bus-svgrepo-com.svg",
                              semanticsLabel: 'Acme Logo',
                              height: 50,
                            ),
                          ),
                          title: Text("Confirmation Awaiting"),
                          subtitle: Text("Wrong Bus chosen? Select bus"),
                        ):ListTile(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>CheckAllBus(schoolid: user.School_id_one,
                                studentid: user.Registration_number,)),
                            );
                          },
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/newportal/bus-svgrepo-com.svg",
                              semanticsLabel: 'Acme Logo',
                              height: 50,
                            ),
                          ),
                          title: Text("No Bus Added"),
                          subtitle: Text("Bus Student? Add Now"),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            !parent?Center(
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
                        Text("    School & Info",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: Gatepass(user: sch, st: user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/new/gate-entrance-svgrepo-com.svg","GatePass")),
                            InkWell(
                              onTap: (){
                                Send.message(context, "Will Activate in our Next Update", false);
                              },
                                child: q(context,"assets/images/parents/sports-mode-svgrepo-com.svg","Fee Payment")),
                            InkWell(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final String id = prefs.getString('school') ?? "None";
                                  final String clas = prefs.getString('class') ?? "None";
                                  final String session = prefs.getString('session') ?? "None";
                                  final String regist = prefs.getString('id') ?? "None";
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: NoticeMeeting(id: regist, clas: clas, school: id, session: session, teacher: false, type: type_class.meeting,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/parents/colors-paint-svgrepo-com.svg","Parents Meeting")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Will Activate in our Next Update", false);
                                },
                                child: q(context,"assets/images/school/telescope-svgrepo-com.svg","Notice")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ):Center(
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
                        Text("    Club & Activities",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  //AIzaSyDJGQ3-DoQ5YgFk_fQqk0d3LcfCQcRw0V0
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage1()),
                                  );
                                },
                                child: qy(context,"assets/images/parents/fall-svgrepo-com.svg","Ask Tiara")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Will Activate in our Next Update", false);
                                },
                                child: q(context,"assets/images/parents/sports-mode-svgrepo-com.svg","Activity")),
                            InkWell(

                                  onTap: (){
                                    Send.message(context, "Will Activate in our Next Update", false);
                                  },
                                child: q(context,"assets/images/parents/colors-paint-svgrepo-com.svg","House")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Will Activate in our Next Update", false);
                                },
                                child: q(context,"assets/images/school/telescope-svgrepo-com.svg","Exhibition")),
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
                        Text("    Friends Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  final String id = prefs.getString('school') ?? "None";
                                  final String clas = prefs.getString('class') ?? "None";
                                  final String session = prefs.getString('session') ?? "None";
                                  final String regist = prefs.getString('id') ?? "None";
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: ChatPage(
                                            Name: user.Name, Pic: user.pic, school: id, clas: clas, idd: regist, teacher: false,
                                          ),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/parents/chat-chat-svgrepo-com.svg","Chats")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Will Activate in our Next Update", false);
                                },
                                child: q(context,"assets/images/parents/network-group-svgrepo-com.svg","Groups")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Will Activate in our Next Update", false);
                                },
                                child: q(context,"assets/images/parents/friendship-relationship-friends-svgrepo-com.svg","Friends")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Will Activate in our Next Update", false);
                                },
                                child: q(context,"assets/images/parents/chatting-talk-svgrepo-com.svg","Alumni")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*
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
                                onTap: () async {
                                  final LocalAuthentication auth = LocalAuthentication();
                                  // ···
                                  final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
                                  final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
                                  try {
                                    final bool didAuthenticate = await auth.authenticate(
                                        localizedReason: 'Please authenticate to update Authentication Method');
                                    print(didAuthenticate);
                                  } catch(e) {
                                    print(e);
                                  }
                                },
                                child: q(context,"assets/images/school/pin-code-svgrepo-com.svg","PIN")),
                            q(context,"assets/images/school/password-svgrepo-com.svg","Backup Code"),
                            q(context,"assets/images/school/attendance-svgrepo-com.svg","Verification"),
                            q(context,"assets/images/school/report-svgrepo-com.svg","Report"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
  int hju(double w){
    return w.toInt();
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
  String capitalizeFirstLetterOfEachWord(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word; // Handle empty strings or spaces
      }
    }).join(' ');
  }
}
