import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/anew/parents/two_factor_authenticate.dart';
import 'package:student_managment_app/anew/parents/verify/find_school.dart';
import 'package:student_managment_app/model/student_model.dart';

class Parents_Login extends StatefulWidget {
  bool student;
  Parents_Login({super.key,required this.student});

  @override
  State<Parents_Login> createState() => _Parents_LoginState();
}

class _Parents_LoginState extends State<Parents_Login> {
  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );

  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
            ]));
  }

  String st = "";

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Container(
        width: w,height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80,),
            Center(
              child: Container(
                width:w-40,height:300,
                decoration:BoxDecoration(
                  image:DecorationImage(
                    image:AssetImage(widget.student?"assets/images/login/high.png":"assets/images/login/parent.png"),
                    fit: BoxFit.contain
                  )
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text("Welcome "+(widget.student?"Student":"Parent"),
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text("Let's Find your Profile first by login to your Account",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 7,),
            InkWell(
              onTap: (){
                if(st=="QR"){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: ScanStudent(student: widget.student,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 10)));
                }
                setState(() {
                  st="QR";
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: w-40,
                  height:90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: st=="QR"?Colors.blue:Colors.grey,
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
                        "assets/images/login/qr-code-scanning-concept-with-characters_23-2148654288 (1).png"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login by Student ID Card',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Login easily by Scanning ID Card',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('provided by School',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                        ],
                      ),
                      Spacer(),
                      st=="QR"? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                        ),
                      ):SizedBox(),
                  ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(st=="ST"){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: FindParentSchool(student: widget.student,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 10)));
                }
                setState(() {
                  st="ST";
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15),
                child: Container(
                  width: w-40,
                  height:90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: st=="ST"?Colors.blue:Colors.grey,
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
                          "assets/images/login/secure-login-illustration-in-flat-design-vector.jpg"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login Manually',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Login by finding School>Session>',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('Class>Student',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                        ],
                      ),
                      Spacer(),
                      st=="ST"? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                        ),
                      ):SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Container(
                width: w-100,height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login/design.png"),
                  )
                ),
              ),
            ),
            SizedBox(height: 23,),
          ],
        ),
      ),
    );
  }
}

class ScanStudent extends StatefulWidget {
  bool student;
  ScanStudent({super.key,required this.student});

  @override
  State<ScanStudent> createState() => _ScanStudentState();
}

class _ScanStudentState extends State<ScanStudent> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result ;

  QRViewController? controller ;

  bool b = false ;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
        title: Text("Scan Student QR Code"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25), // Adjust the radius as needed
                    topRight:
                    Radius.circular(25), // Adjust the radius as needed
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: (result != null)
                          ? SizedBox(height: 8)
                          : Text('Scan Student\'s QR with Camera',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                    ),
                    (result != null)
                        ? SizedBox(height: 1)
                        : SizedBox(height: 15),
                    (result != null)
                        ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: sdg(result!.code),
                    )
                        : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: LoadingIndicator(
                            indicatorType: Indicator.lineScale,

                            /// Required, The loading type of the widget
                            colors: _kDefaultRainbowColors,

                            /// Optional, The color collections
                            strokeWidth: 1,

                            /// Optional, The stroke of the line, only applicable to widget which contains line
                            backgroundColor: Colors.white,

                            /// Optional, Background of the widget
                            pathBackgroundColor: Colors.black

                          /// Optional, the stroke backgroundColor
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void as()async{
    await controller!.pauseCamera();
  }

  Widget sdg(String? sd) {
    String s77 = sd ?? "y";
    String input = s77;

    List<String> parts = input.split('/');

    if (parts.length < 4) {
      // Handle the case where input does not contain enough parts
      return Text('Input does not contain enough parts');
    }

    String sid = parts[0];
    String ssid = parts[1];
    String classid = parts[2];
    String studentid = parts[3];

    final Fire = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: Fire.collection('School')
          .doc(sid)
          .collection('Session')
          .doc(ssid)
          .collection("Class")
          .doc(classid)
          .collection("Student")
          .where("Registration_number", isEqualTo: studentid)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            List<StudentModel> list = data?.map((e) => StudentModel.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              // Navigate to the new Scaffold when data is available
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation:0,
                        leading: InkWell(
                          onTap:()=>Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
                            ),
                          ),
                        ),
                        title: Text("Confirm Student Profile"),
                      ),
                      body:Column(
                        children: [
                          SizedBox(height: 150,),
                          Center(
                            child: CircleAvatar(
                              radius: 120,
                              backgroundImage: NetworkImage(list.first.pic),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(list.first.Name,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
                          Text("Class " + list.first.Class + " (${list.first.Section})",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SocialLoginButton(
                              backgroundColor: Colors.blue,
                              height: 40,
                              text: 'I CONFIRM',
                              borderRadius: 20,
                              fontSize: 21,
                              buttonType: SocialLoginButtonType.generalLogin,
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: TwoFactorAuthenticate(u: list.first, student: widget.student, id: sid, sessionid: ssid, classid: classid,),
                                        type: PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 10)));
                              }
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                );
              });

              // Return an empty container while navigating
              return SizedBox.shrink();
            } else {
              return Center(child: Text("No Student Found"));
            }
        }
      },
    );
  }


Future<void> play() async {
  final player = AudioPlayer();
  await player.play(AssetSource("beep-04.mp3"));
}
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  List<Color> _kDefaultRainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
}
