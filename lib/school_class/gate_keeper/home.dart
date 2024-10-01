import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:galli_text_to_speech/text_to_speech.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/after_login/student_shift.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/school_class/gate_keeper/history.dart';
import 'package:student_managment_app/school_class/gate_keeper/qr.dart';
import 'package:student_managment_app/school_class/gate_keeper/sky/history.dart';
import 'package:student_managment_app/school_class/gate_keeper/sky/scan.dart';
import 'package:student_managment_app/school_class/gate_keeper/sky/scan_pqrent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/usermodel.dart';

class GatekeeperHome extends StatefulWidget {
  UserModel user;
  GatekeeperHome({super.key,required this.user});

  @override
  State<GatekeeperHome> createState() => _GatekeeperHomeState();
}

double volume = 1; // Range: 0-1
double rate = 1.0; // Range: 0-2
double pitch = 1.2; // Range: 0-2
class _GatekeeperHomeState extends State<GatekeeperHome> {
  int full=0, pending=0, completed=0, today=0;
  void initState(){
    countTotalMfValu();
    dooo();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
    tts = TextToSpeech();
  }
  TextToSpeech tts = TextToSpeech();
  String defaultLanguage = 'en-US';
  String? languageCode = 'en-US'; // Default to English
  double volume = 1.0;
  double rate = 1.0;
  double pitch = 1.0;
  String? voice;

  List<String> languageOptions = ['en-US', 'hi-IN']; // English and Hindi options
  TextEditingController textEditingController = TextEditingController();

  Future<void> initLanguages() async {
    languageCode = defaultLanguage;
    await setVoice(languageCode!);
    setState(() {});
  }

  Future<void> setVoice(String lang) async {
    voice = await getVoiceByLang(lang);
    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(lang);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }

  void speak(String englishText, String hindiText) {
    tts.setVolume(volume);
    tts.setRate(rate);
    tts.setPitch(pitch);

    // Check if the language code is English or Hindi
    String textToSpeak = (languageCode == 'en-US') ? englishText : hindiText;

    if (languageCode != null) {
      tts.setLanguage(languageCode!);
    }

    tts.speak(textToSpeak);
  }

void dooo()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool hin = prefs.getBool('HindiMode') ?? true ;
  setState(() {
    english=hin;
  });
}

  void countTotalMfValu() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.schoolid)
        .collection('Gate')
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        pending = querySnapshot.docs.length;
      });
      print("Number of documents with  in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      pending= count;
    });
  }

late bool english;
  bool speed=false;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return   Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-20,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.user.schoolpic),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.school,style: TextStyle(fontSize: w/25,fontWeight: FontWeight.w800,color: Colors.white),),
                        SizedBox(height: 20,),
                        Text("Total Served till date : ${full}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                        Text("Pending : ${full}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                        Text("Completed : ${full}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                        Text("Upcoming : ${full}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                      ],
                    )
                  ],
                ),
              ),

            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Row(
                children: [
                  Text("Language :  "),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("HindiMode", true);
                      setState(() {
                        english=true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:english? Colors.white:Colors.grey.shade300,
                        border: Border.all(
                          color: Colors.black,
                          width: english?0.5:0.1
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        child: Text("English",style: TextStyle(fontWeight: english?FontWeight.w800:FontWeight.w300),),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("HindiMode", false);
                      setState(() {
                        english=false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:!english? Colors.white:Colors.grey.shade300,
                        border: Border.all(
                            color: Colors.black,
                            width: !english?0.5:0.1
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        child: Text("Hindi",style: TextStyle(fontWeight: !english?FontWeight.w800:FontWeight.w300),),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text("Speed? "),
                  InkWell(
                    onTap: (){
                      setState(() {
                        speed=!speed;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:speed? Colors.white:Colors.grey.shade300,
                        border: Border.all(
                            color: Colors.black,
                            width: speed?0.5:0.1
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        child: Text("Yes",style: TextStyle(fontWeight: speed?FontWeight.w800:FontWeight.w300),),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        speed=!speed;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:!speed? Colors.white:Colors.grey.shade300,
                        border: Border.all(
                            color: Colors.black,
                            width: !speed?0.5:0.1
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        child: Text("No",style: TextStyle(fontWeight: !speed?FontWeight.w800:FontWeight.w300),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                        Text("    Let them In",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                 soop(context, true);
                                },
                                child: q(context,"assets/new/qr-code-svgrepo-com.svg","Scan Approval")),
                            InkWell(
                                onTap: (){
                                  soop(context, false);
                                },
                                child: q(context,"assets/id-card-svgrepo-com.svg","Parent Pass")),
                            InkWell(
                                onTap: (){
                                  Send.message(context, "Not Yet Active", false);
                                },
                                child: q(context,"assets/id-card-svgrepo-com (1).svg","Employee Pass")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(child: GateKeeperWidget(schoolid: widget.user.schoolid, schoolname: widget.user.school, lancode: english?"en-US":"hi-IN", user: widget.user,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/add.svg","Manual Add")),
                          ],
                        ),
                        SizedBox(height: 9,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
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
                                      PageTransition(child:ScanParent(Parent: false, user: widget.user, lancode: english?"en-US":"hi-IN", isleaving: false,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/new/qr-code-svgrepo-com.svg","Scan Now")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(child: GateKeeperWidget(schoolid: widget.user.schoolid, schoolname: widget.user.school, lancode: english?"en-US":"hi-IN", user: widget.user,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/add.svg","Add Entry")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(child:GateHistory(user: widget.user,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/images/school/lecture-class-svgrepo-com.svg","History")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(child: QRSchool(str: widget.user.schoolid,open: true,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/qr-code-svgrepo-com.svg","Show Scanner")),
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
                                      PageTransition(child:GateHistoryy(user: widget.user, pending: true,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/images/school/law-book-law-svgrepo-com.svg","Pending")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(child:GateHistoryy(user: widget.user, pending: false,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 80)));
                                },
                                child: q(context,"assets/images/school/law-book-law-svgrepo-com (1).svg","Upcoming")),
                            InkWell(
                                onTap: (){
                                  speak("Welcome User","स्वागत School ");
                                  Send.message(context, "Call Not False", false);
                                },
                                child: q(context,"assets/report-svgrepo-com.svg","Call ")),
                            InkWell(
                                onTap: () async {
                                  final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.starwish.student_managment_app');
                                  if (!await launchUrl(_url)) {
                                  throw Exception('Could not launch $_url');
                                  }
                                },
                                child: q(context,"assets/google-play-store-logo-svgrepo-com.svg","Download")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
  void soop(BuildContext context,bool approval){
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
                  Text("What are the Parents doing ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 19)),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if(approval){
                              Navigator.push(
                                  context,
                                  PageTransition(child:ScanParent(Parent: false, user: widget.user, lancode: english?"en-US":"hi-IN", isleaving: false,),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 80)));
                            }else{
                              Navigator.push(
                                  context,
                                  PageTransition(child:ScannStudent(schoolid:widget.user.schoolid, schoolname: widget.user.school, lancode: english?"en-US":"hi-IN", speed: speed, isleaving: false,),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 80)));
                            }
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
                                  20,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        "https://img.freepik.com/free-vector/children-back-school-with-parents_23-2148596552.jpg"),
                                    Text("Going IN",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w700))
                                  ])),
                        ),
                        InkWell(
                          onTap: () {
                            if(approval){
                              Navigator.push(
                                  context,
                                  PageTransition(child:ScanParent(Parent: false, user: widget.user, lancode: english?"en-US":"hi-IN", isleaving: true,),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 80)));
                            }else{
                              Navigator.push(
                                  context,
                                  PageTransition(child:ScannStudent(schoolid:widget.user.schoolid, schoolname: widget.user.school, lancode: english?"en-US":"hi-IN", speed: speed, isleaving: true,),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 80)));
                            }
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
                                  3,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        "https://img.freepik.com/free-vector/children-back-school-with-parents_23-2148606351.jpg"),
                                    Text("Going OUT",
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

  bool smsend = false ;
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
}
