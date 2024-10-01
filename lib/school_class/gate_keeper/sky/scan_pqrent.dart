
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galli_text_to_speech/text_to_speech.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/school_class/gate_keeper/history.dart';

import '../../../model/gatehistory.dart';

class ScannStudent extends StatefulWidget {
String schoolid;String schoolname;String lancode;bool speed;
bool isleaving;
  ScannStudent({super.key,required this.schoolid,required this.schoolname,
    required this.lancode,required this.speed,required this.isleaving});

  @override
  State<ScannStudent> createState() => _ScannStudentState();
}

class _ScannStudentState extends State<ScannStudent> {
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
        title: Text("Scan Parent Gate Pass"),
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
      return Text('Input does not contain enough parts');
    }

    String sid = parts[0];
    String ssid = parts[1];
    String classid = parts[2];
    String studentid = parts[3];
    final Fire = FirebaseFirestore.instance;
    /*if(sid!=widget.schoolid){
      return Center(child: Text("Parent is not from your School"));
    }*/
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
              if(widget.isleaving){
               gtyu(list.first);
              }else{
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendNow(user: list.first, schoolname: widget.schoolname, schoolid: widget.schoolid, lancode: widget.lancode, speed: widget.speed,),
                    ),
                  );
                });
              }
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

  Future<void> gtyu(StudentModel user) async {

    final nes = DateTime.now().millisecondsSinceEpoch.toString();
    String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
    await FirebaseFirestore.instance.collection('School').doc(widget.schoolid).collection("Gate").doc("History")
        .collection(g).doc(user.Registration_number).update({
      "timeleave":nes,
    });
    play();
    speak(
        "Thank you ${user.Father_Name} for visiting our ${widget.schoolname}. Have a good day.",
        "धन्यवाद श्री ${user.Father_Name} जी, हमारे ${widget.schoolname} में आने के लिए। आपका दिन शुभ हो।"
    );
    Navigator.pop(context);
  }
  @override
  void initState(){
    languageCode = widget.lancode;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });

    tts = TextToSpeech();
  }
  TextToSpeech tts = TextToSpeech();
  late String languageCode;
  double volume = 1.0;
  double rate = 1.0;
  double pitch = 1.0;
  String? voice;

  TextEditingController textEditingController = TextEditingController();

  Future<void> initLanguages() async {
    languageCode = languageCode;
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
}

class SendNow extends StatefulWidget {
  StudentModel user;String schoolid;String schoolname;String lancode;bool speed;
  SendNow({super.key,required this.user,required this.schoolname,required this.schoolid,required this.lancode,required this.speed});

  @override
  State<SendNow> createState() => _SendNowState();
}

class _SendNowState extends State<SendNow> {
  Future<void> play() async {
    final player = AudioPlayer();
    await player.play(AssetSource("beep-04.mp3"));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          title: Text("Confirm this Student Parent"),
        ),
        body:Column(
          children: [
            SizedBox(height: 150,),
            Center(
              child: CircleAvatar(
                radius: 120,
                backgroundImage: NetworkImage(widget.user.pic),
              ),
            ),
            SizedBox(height: 10,),
            Text(widget.user.Name,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
            Text("Class " + widget.user.Class + " (${widget.user.Section})",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            Text("Mobile : " + widget.user.Mobile ,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
            Text("Email : " + widget.user.Email,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
            DropdownButton<String>(
              value: selectedReason,
              hint: Text("Select Reason to Enter School"), // Dropdown hint
              onChanged: (String? newValue) async {
                setState(() {
                  selectedReason = newValue; // Update selected reason
                });
                String str2 = selectedReason ?? "No reason selected";
                print("Selected reason: $str2");
                if(widget.speed){
                  if(selectedReason!.isEmpty){
                    return ;
                  }
                  play();
                  String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
                  final nes = DateTime.now().millisecondsSinceEpoch.toString();
                  GateKeeper ui= GateKeeper(id: widget.user.Registration_number, parentname: widget.user.Father_Name, verified: true,
                      accept:false, timenow: nes, timeleave: "",
                      phone:widget.user.Mobile, email: widget.user.Email, pic: widget.user.pic,
                      pic2sign: "b", reason: selectedReason!, studentname: widget.user.Name, classs: widget.user.Class+"(${widget.user.Section})");
                  await FirebaseFirestore.instance.collection('School').doc(widget.schoolid).collection("Gate").doc("History")
                      .collection(g).doc(widget.user.Registration_number).set(ui.toJson());
                  speak("Respected ${widget.user.Father_Name}, Welcome to our ${widget.schoolname}","सम्माननीय श्री ${widget.user.Father_Name} जी आपका ${widget.schoolname} में स्वागत है");
                  Navigator.pop(context);
                }
              },
              items: reasons.map((String reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                  backgroundColor: Colors.blue,
                  height: 40,
                  text: 'Yes, CONFIRM',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    if(selectedReason!.isEmpty){
                      Send.message(context, "Reason can't be Empty", false);
                      return ;
                    }
                    play();
                    String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
                    final nes = DateTime.now().millisecondsSinceEpoch.toString();
                    GateKeeper ui= GateKeeper(id: widget.user.Registration_number, parentname: widget.user.Father_Name, verified: true,
                        accept:false, timenow: nes, timeleave: "",
                        phone:widget.user.Mobile, email: widget.user.Email, pic: widget.user.pic,
                        pic2sign: "b", reason: selectedReason!, studentname: widget.user.Name, classs: widget.user.Class+"(${widget.user.Section})");
                    await FirebaseFirestore.instance.collection('School').doc(widget.schoolid).collection("Gate").doc("History")
                        .collection(g).doc(widget.user.Registration_number).set(ui.toJson());
                    speak("Respected ${widget.user.Father_Name}, Welcome to our ${widget.schoolname}","सम्माननीय श्री ${widget.user.Father_Name} जी आपका ${widget.schoolname} में स्वागत है");
                    Navigator.pop(context);
                  }
              ),
            ),
          ],
        )
    );
  }
  String? selectedReason; // Store the selected reason
  final List<String> reasons = [
    "To Pick Up or Drop Off the Student",
    "To Meet the Teacher (Parent-Teacher Meeting)",
    "To Pay Fees or Complete Related Formalities",
    "To Submit or Collect Documents",
    "For Admission Process",
    "To Meet the School Administration or Principal",
    "For Medical or Health-Related Reasons",
    "To Participate in School Events",
    "For Transport-Related Issues",
    "For Other Specific Reasons",
  ];

  @override
  void initState(){
    languageCode = widget.lancode;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });

    tts = TextToSpeech();
  }
  TextToSpeech tts = TextToSpeech();
  late String languageCode;
  double volume = 1.0;
  double rate = 1.0;
  double pitch = 1.0;
  String? voice;

  TextEditingController textEditingController = TextEditingController();

  Future<void> initLanguages() async {
    languageCode = languageCode;
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
}
