import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/aextra/marksheet.dart';
import 'package:student_managment_app/afeeeeeee/declare_holiday.dart';
import 'package:student_managment_app/after_login/Birthdays.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/anew/school/dashboard/attendance.dart';
import 'package:student_managment_app/anew/school/dashboard/fees.dart';
import 'package:student_managment_app/anew/school/gatepass/gate_pass.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:local_auth/local_auth.dart';
import 'package:weather/weather.dart';
import 'package:one_clock/one_clock.dart';


class SchholH extends StatefulWidget {
  SchoolModel user;
  SchholH({super.key,required this.user});

  @override
  State<SchholH> createState() => _SchholHState();
}

class _SchholHState extends State<SchholH> {
  int i = 0;

  void initState(){
    countTotalMfValue();
    setState(() {
      weather=widget.user.weather;
      temp=widget.user.temp.toStringAsFixed(1);
      humidity=widget.user.humidity.toStringAsFixed(0);
      pressure=widget.user.pressure.toStringAsFixed(0);
      wind=widget.user.wind.toStringAsFixed(0);
    });
    cs();
    countp();
    leavenow();
  }

  String weather = "", temp = "", humidity = "", pressure = "", wind = "";

  Future<void> cs() async {
    WeatherFactory wf = WeatherFactory("8d978f8ad3d09832086988570c48add6");
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    String currentDay = DateFormat('EEEE').format(now); // Get the day of the week

    DocumentSnapshot schoolSnapshot = await FirebaseFirestore.instance
        .collection("School")
        .doc(widget.user.id)
        .get();

    Map<String, dynamic> schoolData = schoolSnapshot.data() as Map<String, dynamic>;
    String? lastUpdateString = schoolData["lastUpdate"]; // Retrieve last update time
    DateTime? lastUpdate;

    if (lastUpdateString != null) {
      lastUpdate = DateTime.parse(lastUpdateString); // Convert to DateTime
    }

    // Check if it's Monday to Friday and if smsend is true
    if (widget.user.smsend && (currentDay != 'Saturday' && currentDay != 'Sunday')) {
      // Check if the date has changed (i.e., a new day)
      bool isNewDay = lastUpdate == null || lastUpdate.day != now.day;

      if (isNewDay || lastUpdate == null) {
        // Reset the update count for a new day by setting `lastUpdate` to null.
        await FirebaseFirestore.instance.collection("School").doc(widget.user.id).update({
          "lastUpdate": null,  // Reset the date for a new day
        });
      }

      // If it's the first update of the day (8 AM to 12 PM)
      if (isNewDay && currentHour >= 8 && currentHour <= 12) {
        print("First update of the day");
        Weather w = await wf.currentWeatherByLocation(widget.user.lat, widget.user.lon);
        double windd = w.windSpeed ?? 0.0;
        double tempp = w.temperature!.celsius ?? 0.0;
        String weatherr = w.weatherDescription ?? "Unknown";
        double humi = w.humidity ?? 0.0;
        double pascal = w.pressure ?? 0.0;

        await FirebaseFirestore.instance.collection("School").doc(widget.user.id).update({
          "wind": windd,
          "weather": weatherr,
          "temp": tempp,
          "humidity": humi,
          "pressure": pascal,
          "lastUpdate": now.toIso8601String(),  // Save the current time
        });

        setState(() {
          weather = weatherr;
          temp = tempp.toStringAsFixed(1);
          humidity = humi.toStringAsFixed(0);
          pressure = pascal.toStringAsFixed(0);
          wind = windd.toStringAsFixed(0);
        });
      }
      // If it's the second update of the day (2 PM to 4 PM)
      else if (!isNewDay && currentHour >= 14 && currentHour <= 16) {
        print("Second update of the day");
        Weather w = await wf.currentWeatherByLocation(widget.user.lat, widget.user.lon);
        double windd = w.windSpeed ?? 0.0;
        double tempp = w.temperature!.celsius ?? 0.0;
        String weatherr = w.weatherDescription ?? "Unknown";
        double humi = w.humidity ?? 0.0;
        double pascal = w.pressure ?? 0.0;

        await FirebaseFirestore.instance.collection("School").doc(widget.user.id).update({
          "wind": windd,
          "weather": weatherr,
          "temp": tempp,
          "humidity": humi,
          "pressure": pascal,
          "lastUpdate": now.toIso8601String(),  // Save the current time
        });

        setState(() {
          weather = weatherr;
          temp = tempp.toStringAsFixed(1);
          humidity = humi.toStringAsFixed(0);
          pressure = pascal.toStringAsFixed(0);
          wind = windd.toStringAsFixed(0);
        });
      }
    }
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

  void countp() async {
    int totalMfValue = 0;
    int totalMfValue2 = 0;
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
          if (data.containsKey('pcount1')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['pcount1'];
            if (mfValue is int) {
              totalMfValue2 += mfValue;
            } else if (mfValue is double) {
              totalMfValue2 += mfValue.toInt();
            }else{
              totalMfValue2 += int.parse(mfValue) ;
            }
          }
        }
      });
      setState(() {
        cin = totalMfValue;
        cout=totalMfValue2;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }
  int cin=0,cout=0;

  int leave=0;
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


  void countTotalMfValue() async {
    int totalMfValue = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.user.id)
          .collection('Session')
          .get();
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double w =MediaQuery.of(context).size.width;
    return Scaffold(
      drawer:Global.buildDrawer(context),
      key: _scaffoldKey,
      appBar: AppBar(
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.user.Pic_link)),
        title: Text(widget.user.Name),
        actions: [
          IconButton(onPressed: (){
            _scaffoldKey.currentState?.openDrawer();
          }, icon: Icon(Icons.more_vert_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,width: w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.user.Pic),
                  fit: BoxFit.cover
                )
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(height: 10,),
            Container(
              width: w-20,height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  t(w,"Total","Students",i),
                  c(),
                  t(w,"Pending","Students",widget.user.Students-i),
                  c(),
                  t(w,"School","Students",widget.user.Students),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: w-20,height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  t1(w,"Present","( Check IN )",cin),
                  c1(),
                  t1(w,"Present","( CHECK OUT )",cout),
                  c1(),
                  t1(w,"Pending","OUT",cin-cout),
                  c1(),
                  t1(w,"Absent","Students",i-cin-leave),
                  c1(),
                  t1(w,"Leave","Students",leave),
                ],
              ),
            ),
            SizedBox(height: 10,),
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
                        Text("    Overview",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
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
                                          child: SchoolA(user: widget.user, b: true,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/school/report5.svg","Attendance")),
                            InkWell(
                                onTap: (){
                                  if (widget.user.b) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: Session( csession : widget.user.csession,
                                              id: widget.user.id,
                                              School: widget.user.Name,
                                              EmailB: widget.user.EmailB,
                                              RegisB: widget.user.RegisB,
                                              Other4B: widget.user.Other4B,
                                              Other3B: widget.user.Other3B,
                                              Other2B: widget.user.Other2B,
                                              Other1B: widget.user.Other1B,
                                              MotherB: widget.user.MotherB,
                                              DepB: widget.user.DepB,
                                              BloodB: widget.user.BloodB,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 50)));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(" School Editing had been Closed by Admin "),
                                      ),
                                    );
                                  }
                                },
                                child: q(context,"assets/images/school/lecture-class-svgrepo-com.svg","Class")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: SchoolF(user: widget.user, b: true,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/images/school/money-transfer-svgrepo-com.svg","Finance")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: BDay(
                                            logo: widget.user.Pic_link,
                                            id : widget.user.id ,
                                            School: widget.user.Name, address: widget.user.Address,                            ),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 400)));
                                },
                                child: q(context,"assets/birthday-cake-svgrepo-com.svg","Birthdays")),
                          ],
                        ),
                        SizedBox(height: 9,),
                      /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q(context,"assets/images/school/schedule-svgrepo-com.svg","Upcomings"),
                            q(context,"assets/images/school/price-tag-discount-svgrepo-com.svg","Pricing"),
                            q(context,"assets/images/school/price-tag-price-svgrepo-com.svg","Premium"),
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
                               Text(capitalizeFirstLetterOfEachWord(weather),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: w/25),),
                               Text("Temp : ${temp} °C       Humidity : ${humidity} g/V",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: w/45),),
                               Text("Wind : ${wind} km/hr       Pressure : ${pressure} Pa" ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: w/45),),
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
            Text("*Weather is updated every 8 AM and 3 PM ( Mon to Fri ) automatically",style: TextStyle(fontSize: 11,color: Colors.red),),
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
                        Text("    Gate Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>GateSchooory(user: widget.user, onlyout: false,)),
                                  );
                                },
                                child: q(context,"assets/border-guard-svgrepo-com.svg","Gate Access")),
                            InkWell(
                                child: q(context,"assets/images/school/track-svgrepo-com.svg","Gate Timings")),
                            InkWell(
                                child: q(context,"assets/images/school/alert-bell-notice-svgrepo-com.svg","Gate Message")),
                            q(context,"assets/images/school/announcement-svgrepo-com.svg","Gate Call"),
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
                        Text("    Student Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
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
                                      builder: (context) => Mark(user: widget.user)),
                                );
                              },
                              child: q(context,"assets/a-plus-result-svgrepo-com (1).svg","Marksheet")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Declare_Holi(user: widget.user)),
                                  );
                                },
                                child: q(context,"assets/images/school/cruise-ship-svgrepo-com.svg","Holidays")),
                            q(context,"assets/images/school/lecture-class-svgrepo-com.svg","TimeTable"),
                            q(context,"assets/images/school/alert-bell-notice-svgrepo-com.svg","Notice"),
                          ],
                        ),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q(context,"assets/images/school/law-book-law-svgrepo-com.svg","Probation"),
                            q(context,"assets/images/school/law-book-law-svgrepo-com (1).svg","Rules"),
                            q(context,"assets/images/school/law-svgrepo-com.svg","Announce"),
                            q(context,"assets/images/school/profile-user-svgrepo-com.svg","Verification"),
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
                        Text("    Benefit Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q(context,"assets/images/school/health-hospital-medical-svgrepo-com.svg","Health"),
                            InkWell(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                },
                                child: q(context,"assets/images/school/health-insurance-medical-medical-svgrepo-com.svg","Insurance")),
                            q(context,"assets/images/school/training-gym-svgrepo-com.svg","Training"),
                            q(context,"assets/images/school/telescope-svgrepo-com.svg","Exhibition"),
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
                                onTap: () async {
                                  final LocalAuthentication auth = LocalAuthentication();
                                  // ···
                                  final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
                                  final bool canAuthenticate =
                                      canAuthenticateWithBiometrics || await auth.isDeviceSupported();
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

  Widget t(double w,String s1,String s2, int y)=>Container(
    width: w/3-10,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(s1,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 9),),
        Text(s2,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 9),),
        SizedBox(height: 2,),
        Text(y.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 27),),
      ],
    ),
  );

  Widget t1(double w,String s1,String s2, int y)=>Container(
    width: w/5-10,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(s1,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 9),),
        Text(s2,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 7),),
        SizedBox(height: 2,),
        Text(y.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 22),),
      ],
    ),
  );
  Widget c()=>Container(
    width: 3,
    height: 60,
    decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20)
    ),
  );
  Widget c1()=>Container(
    width: 3,
    height: 40,
    decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20)
    ),
  );
}
