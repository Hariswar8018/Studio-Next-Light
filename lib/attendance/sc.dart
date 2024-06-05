import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:studio_next_light/after_login/calender.dart';
import 'package:studio_next_light/model/student_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class QRViewExample extends StatefulWidget {
  String str ; String id ; String status ;
  QRViewExample({Key? key, required this.str, required this.id, required this.status}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result ;
  QRViewController? controller ;
  bool b = false ;

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
    print(studentid);
    List<StudentModel> list = [];
    late Map<String, dynamic> userMap;
    TextEditingController ud = TextEditingController();

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
            list = data?.map((e) => StudentModel.fromJson(e.data())).toList() ??
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
                      status : widget.status, sid : sid , ssid : ssid , clasid : classid , studentid : studentid,
                    );
                  },
                );
              } else {
                return Center(child: Text("No Student Found"));
              }
            }else{
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
  StudentModel user; bool bgi ; String id ;  String st ; String school ; String status ; String sid ; String ssid ; String clasid ; String studentid ;

  ChatUser({super.key, required this.user, required this.bgi, required this.id, required this.st, required this.school, required this.status, required this.clasid, required this.sid, required this.ssid, required this.studentid});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {

  bool b = false;

  void initState() {
    checkDatePresence();
    if (widget.bgi) {
      DateTime now = DateTime.now();
      String n = DateFormat('yyyy-MM-dd 00:00:00.000').format(now);
      _storeColorInFirestore(now, Colors.blue);
      setState(() {
        b = true;
      });
    }
  }

  void checkDatePresence() async {
    DateTime date = DateTime.now();
    String st = '${date.day}-${date.month}-${date.year}';
    final schoolDocRef = FirebaseFirestore.instance.collection('School').doc(
        widget.id).collection("Students").doc(widget.user.School_id_one);
    schoolDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        final presentArray = docSnapshot.data()!['Present'] as List<dynamic>? ??
            [];
        if (presentArray.contains(st)) {
          print('String already exists in the "Present" array: $st');
          setState(() {
            b = true;
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
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 130,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: MyCalenderPage(
                        idi: widget.user.School_id_one,
                        df: widget.id, sessioni: widget.clasid, classi: widget.ssid, user: widget.user,
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 400)));
            },
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 90,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.pic,),
                      child: b
                          ? Icon(Icons.verified, color: Colors.blue, size: 60)
                          : SizedBox(width: 1),
                      radius: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.user.Name,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 22)),
                        Text("Mobile no. : " + widget.user.Mobile),
                        Text(
                            "Roll no. : " + widget.user.Roll_number.toString()),
                        Text("Class : " +
                            widget.user.Class +
                            "  Section (" +
                            widget.user.Section +
                            ")"),
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2 - 30,
              text: 'Present',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                DateTime date = DateTime.now();
                /*await _storeColorInFirestore(now, Colors.blue);*/
                String st = '${date.day}-${date.month}-${date.year}';
                try{
                  await FirebaseFirestore.instance.collection('School').doc(widget.sid)
                      .collection("Session")
                      .doc(widget.ssid).collection("Class").doc(widget.clasid).collection("Student").doc(widget.studentid)
                      .update({
                    'Present': FieldValue.arrayUnion([st]),
                  });
                  DateTime now = DateTime.now();
                  await _storeColorInFirestore(now, Colors.blue);
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${e}"),
                    ),
                  );
                }
              },
            ),
            SocialLoginButton(
              backgroundColor: Colors.redAccent,
              height: 40,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2 - 30,
              text: 'Absent',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                DateTime now = DateTime.now();
                String st = '${now.day}-${now.month}-${now.year}';
                await FirebaseFirestore.instance.collection('School').doc(widget.sid)
                    .collection("Session")
                    .doc(widget.ssid).collection("Class").doc(widget.clasid).collection("Student").doc(widget.studentid)
                    .update({
                  'Absent': FieldValue.arrayUnion([st]),
                });
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
          .collection("Students")
          .doc(widget.user.Registration_number)
          .collection("Colors")
          .doc(st)
          .set({
        'color': color.value,
        'date': date,
        'st': st,
      });
      final player = AudioPlayer();
      await player.play(AssetSource("beep-04.mp3"));
      String apiUrl = 'https://sms.autobysms.com/app/smsapi/index.php';
      DateTime currentTime = DateTime.now();
      String formattedTime = DateFormat('h:mm a').format(currentTime);
      Map<String, String> queryParams = {
        'key': '365E176C71F352',
        'campaign': '0',
        'routeid': '9',
        'type': 'text',
        'contacts': widget.user.Mobile,
        'senderid': 'WAHRAM',
        'msg':
        'Dear Parents, Your ${widget.user.Name} of Class ${widget.user
            .Class} Check ${widget
            .status} Time $formattedTime in our institute ${widget.st} JRAM',
        'template_id': '1407171212391331672',
      };

      String fullUrl = '$apiUrl?' +
          queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(
              e.value)}').join('&');

      try {
        var response = await http.get(Uri.parse(fullUrl));
        if (response.statusCode == 200) {
          print('SMS sent successfully');
          print('Response: ${response.body}');
        } else {
          print('Failed to send SMS. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending SMS: $e');
      }
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }
}