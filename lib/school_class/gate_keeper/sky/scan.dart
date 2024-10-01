import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galli_text_to_speech/text_to_speech.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/anew/parents/home/gatepass/gatepass.dart';
import 'package:student_managment_app/anew/parents/two_factor_authenticate.dart';
import 'package:student_managment_app/anew/parents/verify/find_school.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/gate_keeper/history.dart';

import '../../../model/gatehistory.dart';


class ScanParent extends StatefulWidget {
  bool Parent;UserModel user;String lancode;bool isleaving;
  ScanParent({super.key,required this.Parent,required this.user,required this.lancode,required this.isleaving});

  @override
  State<ScanParent> createState() => _ScanParentState();
}

class _ScanParentState extends State<ScanParent> {
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
        title: Text("Scan Approval Pass"),
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
                          : Text('Scan Parent\'s QR with Camera',
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
    final Fire = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: Fire.collection('School')
          .doc(widget.user.schoolid)
          .collection('Pass')
          .where("id", isEqualTo: s77)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            List<GatePassForm> list = data?.map((e) => GatePassForm.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              if(widget.isleaving){
                gtyu(list.first);
              }else{
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Show(user: list.first, schoolname: widget.user.school, schoolid: widget.user.schoolid, lancode: widget.lancode,)
                    ),
                  );
              });
              }
              return SizedBox.shrink();
            } else {
              return Center(child: Text("No Parent Found"));
            }
        }
      },
    );
  }


  String s(String entry) {
    try {
      DateTime dateTime = DateTime.parse(entry);

      // Format the DateTime to dd/mm/yy on hh:mm using DateFormat from intl package
      String formattedTime = DateFormat('dd/MM/yy on HH:mm').format(dateTime);

      return formattedTime;
    } catch (e) {
      return "NA"; // Return "NA" if parsing fails
    }
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
  Future<void> gtyu(GatePassForm user) async {

    final nes = DateTime.now().millisecondsSinceEpoch.toString();
    String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
    await FirebaseFirestore.instance.collection('School').doc(widget.user.schoolid).collection("Gate").doc("History")
        .collection(g).doc(user.id).update({
      "timeleave":nes,
    });
    play();
    speak(
        "Thank you ${user.name} for visiting our ${widget.user.school}. Have a good day.",
        "धन्यवाद श्री ${user.name} जी, हमारे ${widget.user.school} में आने के लिए। आपका दिन शुभ हो।"
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

class Show extends StatefulWidget {
  GatePassForm user;String schoolname;String schoolid;String lancode;
   Show({super.key,required this.user,required this.schoolname,required this.schoolid,required this.lancode});

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {
  String s(String entry) {
    try {
      DateTime dateTime = DateTime.parse(entry);
      String formattedTime = DateFormat('dd/MM/yy on HH:mm').format(dateTime);
      return formattedTime;
    } catch (e) {
      return "NA";
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
        title: Text("Parent / Student Pass"),
      ),
      body:Column(
        children: [
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width:9,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(9)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width/2-24,height: MediaQuery.of(context).size.width/2-14,
                      decoration: BoxDecoration(
                          image:DecorationImage(
                              image: AssetImage("assets/WhatsApp Image 2023-11-22 at 17.13.30_388ceeb5.jpg")
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 9,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9,),
                    Text("Parents /",style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/18),),
                    Text("Guardian Detail",style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/18),),
                    SizedBox(height: 13,),
                    Text(widget.user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/29),),
                    Text(widget.user.email,style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/29),),
                    Text(widget.user.phone,style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/29),),

                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width-20,
                height:70,
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.grey.shade900,
                      width: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.stpic),
                      radius: 24,
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.stname,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text("Class : "+ widget.user.stclass ,
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text( "",
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                      ],
                    ),
                    Spacer(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.verified),
                    title: Text("Verified : "+widget.user.verified.toString(),style: TextStyle(fontSize: 19,color: Colors.green),),
                    subtitle: Text("Verified as it's come from Parent Porta;"),
                  )
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: widget.user.accepted?Container(
                  width: MediaQuery.of(context).size.width-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.settings_accessibility,color: Colors.white,),
                    title: Text("Meeting Accepted",style: TextStyle(fontSize: 19,color: Colors.white),),
                    subtitle: Text("Meeting is accepted by Principal",style: TextStyle(color: Colors.white),),
                  )
              ):Container(
                  width: MediaQuery.of(context).size.width-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.warning,color: Colors.white,),
                    title: Text("Meeting Still Not Accepted",style: TextStyle(fontSize: 19,color: Colors.white),),
                    subtitle: Text("Meeting is NOT accepted by Principal",style: TextStyle(color: Colors.white),),
                  )
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.share_arrival_time),
                    title: Text("Decided for : "+s(widget.user.time2),style: TextStyle(fontSize:19,color: Colors.blue,fontWeight: FontWeight.w800),),
                    subtitle: Text("Desired for : "+s(widget.user.time),style: TextStyle(color: Colors.grey),),
                  )
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor:Colors.blue,
            height: 40,
            text:'Add Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              GatePassForm user=widget.user;
              String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
              final nes = DateTime.now().millisecondsSinceEpoch.toString();
              GateKeeper ui= GateKeeper(id: user.id, parentname: user.name, verified: true,
                  accept: user.accepted, timenow: nes, timeleave: "",
                  phone: user.phone, email: user.email, pic: user.stpic,
                  pic2sign: "b", reason: user.reason, studentname: user.stname, classs: user.stclass);
              await FirebaseFirestore.instance.collection('School').doc(widget.schoolid).collection("Gate").doc("History")
                  .collection(g).doc(user.id).set(ui.toJson());
              speak("Respected ${ user.name}, Welcome to our ${widget.schoolname}","सम्माननीय श्री ${ user.name} जी आपका ${widget.schoolname} में स्वागत है");
              Navigator.pop(context);
              Send.message(context, "New Parent Added", true);
            },
          ),
        )
      ],
    );
  }
  @override
  void initState(){
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
    languageCode = widget.lancode;
    tts = TextToSpeech();
  }
  TextToSpeech tts = TextToSpeech();
  late String? languageCode ;
  double volume = 1.0;
  double rate = 1.0;
  double pitch = 1.0;
  String? voice;

  List<String> languageOptions = ['en-US', 'hi-IN']; // English and Hindi options
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
