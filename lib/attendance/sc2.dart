import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/after_login/calender.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class QRViewExample1 extends StatefulWidget {
  String str ; String id ; String status ;
  QRViewExample1({Key? key, required this.str, required this.id, required this.status}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample1> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool b = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  bool bgi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Scanner"),
        actions: [
          Switch(
            value: bgi,
            onChanged: (newValue) {
              setState(() {
                bgi = newValue;
              });
            },
          ),
          IconButton(
              onPressed: () async {
                await controller!.flipCamera();
              },
              icon: Icon(Icons.flip, color: Colors.brown)),
          IconButton(
              onPressed: () async {
                await controller!.toggleFlash();
              },
              icon: Icon(Icons.flashlight_on, color: Colors.blue)),
          IconButton(
              onPressed: () async {
                await controller!.resumeCamera();
              },
              icon: Icon(Icons.play_arrow, color: Colors.green)),
          IconButton(
              onPressed: () async {
                await controller!.pauseCamera();
              },
              icon: Icon(Icons.stop, color: Colors.red))
        ],
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
                          : Text('Scan Employee\s QR with Camera',
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

  Widget sdg(String? sd) {
    String s77 = sd ?? "y";
    String input = s77;

    List<String> parts = input.split('/');


    String sid = parts[0];
    String ssid = parts[1];
    List<EmployeeModel> list = [];
    late Map<String, dynamic> userMap;
    TextEditingController ud = TextEditingController();

    final Fire = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: Fire.collection('School')
          .doc(sid)
          .collection('Employee')
          .where("Id_number", isEqualTo: ssid)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            list = data?.map((e) => EmployeeModel.fromJson(e.data())).toList() ??
                [];
            if(sid == widget.id) {
              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index],
                      bgi: bgi,
                      school: widget.id,
                      id: sid,
                      st: widget.str,
                      status : widget.status,
                    );
                  },
                );
              } else {
                return Center(child: Text("No Employee Found"));
              }
            }else{
              return Center(child: Text("Employee is not from Your School or NULL"));
            }
        }
      },
    );
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

class ChatUser extends StatefulWidget {
  EmployeeModel user; bool bgi ; String id ;  String st ; String school ; String status ;

  ChatUser({super.key, required this.user, required this.bgi, required this.id, required this.st, required this.school, required this.status});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {

  bool b =  false ;
  void initState(){
    checkDatePresence() ;
    if(widget.bgi){
      DateTime now = DateTime.now();
      String n = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
      _storeColorInFirestore(now, Colors.blue);
      setState((){
        b = true ;
      });
    }
  }

  void checkDatePresence() async {
    DateTime date = DateTime.now();
    String st = '${date.day}-${date.month}-${date.year}';
    final schoolDocRef = FirebaseFirestore.instance.collection('School')
        .doc(widget.id).collection("Employee").doc(widget.user.Id_number);
    schoolDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        final presentArray = docSnapshot.data()!['Present'] as List<dynamic>? ?? [];
        if (presentArray.contains(st)) {
          print('String already exists in the "Present" array: $st');
          setState((){
            b = true ;
          });
        } else {
          print('String does not exist in the "Present" array: $st');
        }
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 130,
      child: Column(
        children: [
          InkWell(
            onTap: () {

            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.Pic,),
                      child : b ? Icon(Icons.verified, color : Colors.blue, size : 60) : SizedBox(width : 1),
                      radius: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.user.Name,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 22)),
                        Text("Profession : " + widget.user.Profession),
                        Text("Mobile no. : " + widget.user.Phone),
                        Text("ID Number : " + widget.user.Registration_Number),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SocialLoginButton(
              backgroundColor: Colors.green,
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 30,
              text: 'Present',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                DateTime now = DateTime.now();
                // Format the date as desired
                String n = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
                _storeColorInFirestore(now, Colors.blue);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.user.Name} marked as Present"),
                  ),
                );
              },
            ),
            SocialLoginButton(
              backgroundColor: Colors.redAccent,
              height: 40,
              width: MediaQuery.of(context).size.width / 2 - 30,
              text: 'Absent',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                DateTime now = DateTime.now();
                // Format the date as desired
                String n = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
                _storeColorInFirestore(now, Colors.red);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.user.Name} marked as Absent"),
                  ),
                );
              },
            ),
          ])
        ],
      ),
    );
  }
  Future<void> _storeColorInFirestore(DateTime date, Color color) async {
    try {
      String st = '${date.day}-${date.month}-${date.year}';
      await FirebaseFirestore.instance.collection('School').doc(widget.id)
          .collection("Employee")
          .doc(widget.user.Id_number)
          .collection("Colors")
          .doc(st)
          .set({
        'color': color.value,
        'date': date,
        'st' : st,
      });
      final player = AudioPlayer();
      await player.play(AssetSource("beep-04.mp3"));
      if( color == Colors.blue){

        await FirebaseFirestore.instance.collection('School').doc(widget.id).collection("Employee")
            .doc(widget.user.Id_number)
            .update({
          'Present' : FieldValue.arrayUnion([st]),
        });
      }

    } catch (error) {
      print(error);
    }
  }
}
