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
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/dormitory/chat.dart';

class QRViewExample3 extends StatefulWidget {
  UserModel user;
  QRViewExample3({Key? key,required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample3> {
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
                          : Text('Scan Student\s QR with Camera',
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
    as();
    String sid = parts[0];
    String ssid = parts[1];
    String classid = parts[2];
    String studentid = parts[3];
    List<StudentModel> list = [];
    late Map<String, dynamic> userMap;
    final Fire = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: Fire.collection('School').doc(sid)
          .collection("Students")
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
            list = data?.map((e) => StudentModel.fromJson(e.data())).toList() ?? [];
            print(list);
            if(sid == widget.user.schoolid) {
              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index], u: widget.user,
                    );
                  },
                );
              } else {
                return Center(child: Text("No Student Found"));
              }
            }else{
              print(list);
              print(sid);
              print(widget.user.schoolid);
              print(studentid);
              return Center(child: Text("Student is not from Your School or NULL"));
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
  StudentModel user;UserModel u;
  ChatUser({super.key,  required this.user, required this.u,});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {

  @override
  Widget build(BuildContext context) {
    double w= MediaQuery.of(context).size.width;
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
                  Container(
                    width: 1/3*w,
                    height: 1/3*w,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(widget.user.pic),
                          fit: BoxFit.contain,
                        )
                    ),
                  ),
                  Container(
                    width: 2/3*w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: w/24)),
                        Text("Mobile no. : " + widget.user.Mobile,style: TextStyle(fontSize: w/30),),
                        Text("Roll no. : " + widget.user.Roll_number.toString(),style: TextStyle(fontSize: w/30),),
                        Text("Class : " + widget.user.Class + "  Section (" + widget.user.Section + ")",style: TextStyle(fontSize: w/30),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  try{
                    await FirebaseFirestore.instance.collection('School').doc(widget.u.schoolid).collection('Students').doc(widget.user.Registration_number).update({
                      "dorin":DateTime.now().millisecondsSinceEpoch.toString(),
                      "dorout":true,
                    });
                    Send.message(context, "Done ! Student is Inside", true);
                    final id=DateTime.now().millisecondsSinceEpoch.toString();
                    DormitoryHistory us=DormitoryHistory(
                        id: id, name: widget.user.Name, pic: widget.user.pic,
                        inTime:'OUT', day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year
                    );
                    await FirebaseFirestore.instance.collection("School").doc(widget.u.schoolid).collection("Dormitory").doc(id).set(us.toJson());
                  }catch(e){
                    Send.message(context, "$e", false);
                  }
                },
                child: Container(
                  width: w/2-15,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(child: Text("Check IN",style: TextStyle(color: Colors.white),)),
                ),
              ),
              InkWell(
                onTap: () async {
                  try{
                    await FirebaseFirestore.instance.collection('School').doc(widget.u.schoolid).collection('Students').doc(widget.user.Registration_number).update({
                      "dorin":DateTime.now().millisecondsSinceEpoch.toString(),
                      "dorout":false,
                    });
                    Send.message(context, "Done ! Student is Outside", true);
                    final id=DateTime.now().millisecondsSinceEpoch.toString();
                    DormitoryHistory us=DormitoryHistory(
                        id: id, name: widget.user.Name, pic: widget.user.pic,
                        inTime:'OUT', day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year
                    );
                    await FirebaseFirestore.instance.collection("School").doc(widget.u.schoolid).collection("Dormitory").doc(id).set(us.toJson());
                  }catch(e){
                    Send.message(context, "$e", false);
                  }
                },
                child: Container(
                  width: w/2-15,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(child: Text("Check OUT",style: TextStyle(color: Colors.white),)),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
