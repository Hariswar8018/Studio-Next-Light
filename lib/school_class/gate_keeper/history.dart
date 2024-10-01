import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galli_text_to_speech/text_to_speech.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/aextra/session.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/gate_keeper/home.dart';
import 'package:student_managment_app/school_class/gate_keeper/sky/signature.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hand_signature/signature.dart';

import '../../model/gatehistory.dart';


class GateHistory extends StatefulWidget {
  UserModel user;
  GateHistory({super.key,required this.user,});

  @override
  State<GateHistory> createState() => _GateHistoryState();
}

class _GateHistoryState extends State<GateHistory> {
  List<GateKeeper> list = [];
int inn=0,out=0;
  late Map<String, dynamic> userMap;
  void countTotalMfValu() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.schoolid)
        .collection('Gate').doc("History").collection(g)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        inn = querySnapshot.docs.length;
      });
      print("Number of documents with  in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      inn= count;
    });
  }
  void countTotalMfValu1() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.schoolid)
        .collection('Gate')
        .doc("History")
        .collection(g)
        .get()
        .then((querySnapshot) {
      // Iterate over each document
      for (var doc in querySnapshot.docs) {
        if (doc.data().containsKey('timeleave')) {
          try {
            // Parse 'timeleave' as an integer if it is a string
            int timeleaveMillis = int.parse(doc['timeleave']);
            DateTime.fromMillisecondsSinceEpoch(timeleaveMillis);
            count++;
          } catch (e) {
            print("Invalid timeleave value: ${doc['timeleave']}");
          }
        }
      }
      setState(() {
        out = count;
      });
      print("Number of valid documents with 'timeout': $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
  }

  TextEditingController ud = TextEditingController();

bool todaytime=true;
void initState(){
  countTotalMfValu();
  countTotalMfValu1();
}
  final Fire = FirebaseFirestore.instance;
  List<DateTime?> _dates = [
    DateTime.now().add(const Duration(days: 1)),
  ];
  DateTime h=DateTime.now();
  String g=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:Row(
        children: [
          SizedBox(width: 30,),
          Container(
            height:50,
            width:210,
            child: Row(
              children: [
                Container(
                  height: 50,width: 105,color: Colors.green,
                  child: Row(
                    children: [
                      SizedBox(width: 6,),
                      Icon(Icons.transit_enterexit,color: Colors.white,),
                      Text("   "+inn.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
                Container(height: 50,width: 105,color: Colors.redAccent,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Icon(Icons.login,color: Colors.white,),
                      Text("   "+out.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: !todaytime?Colors.red.shade50:Colors.red.shade800,
            onPressed: () async {
              print(_dates);
              List<DateTime?>? results = await showCalendarDatePicker2Dialog(
              context: context,
              config: CalendarDatePicker2WithActionButtonsConfig(),
              dialogSize: const Size(325, 400),
              value: _dates,
              borderRadius: BorderRadius.circular(15),
              );
              print(_dates);
              if(results!=null){
                String h1=(results[0]!.day.toString()+"-"+results[0]!.month.toString()+"-"+results[0]!.year.toString()).toString();
                print(h1);
                setState(() {
                  g=h1;
                  now=results[0]!;
                });
                countTotalMfValu1();
                countTotalMfValu();
              }
            },
            child: !todaytime?Icon(Icons.today,color: Colors.white,):Icon(Icons.today,color: Colors.white,),
          ), SizedBox(width: 10,),
          FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final bool hin = prefs.getBool('HindiMode') ?? true ;
              Navigator.push(
                  context,
                  PageTransition(child: GateKeeperWidget(schoolid: widget.user.schoolid, schoolname: widget.user.school, lancode:  hin?"en-US":"hi-IN", user: widget.user,),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 40)));
            },
            child: Icon(Icons.add,color: Colors.white,),
          ),
          SizedBox(width: 5,),
        ],
      ),
      body: StreamBuilder(
        stream: Fire.collection('School')
            .doc(widget.user.schoolid).collection("Gate").doc("History")
            .collection(g)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Icon(Icons.bedtime_off_outlined, size: 30, color: Colors.red)),
                    Center(child: Text("No History", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
                    Center(child: Text("No one had entered or left this School", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                  ],
                );
              }

              final data = snapshot.data?.docs;
              final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
              final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999).millisecondsSinceEpoch;
              List<GateKeeper> list = data
                  ?.map((e) => GateKeeper.fromJson(e.data()))
                  .where((doc) {
                final id = int.tryParse(doc.timenow); // Parse the id to an integer
                if (id == null) return false; // Skip if id is invalid
                if (todaytime) {
                  return id >= startOfDay && id <= endOfDay;
                }
                return true; // No filter if `todaytime` is false
              }).toList() ?? [];
              if (list.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Icon(Icons.bedtime_off_outlined, size: 30, color: Colors.red)),
                    Center(child: Text("No History", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
                    Center(child: Text("No one had entered or left this School on $g", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                  ],
                );
              }
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUse(user: list[index], schoolid: widget.user.schoolid);
                },
              );
          }
        },
      ),
    );
  }
}
class ChatUse extends StatelessWidget {
  GateKeeper user;String schoolid;
  ChatUse({super.key,required this.user,required this.schoolid});
  String convertEpochToTime(String epochString) {
    try {
      // Parse the string into an integer
      int millisecondsSinceEpoch = int.parse(epochString);

      // Convert the milliseconds since epoch to a DateTime object
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

      // Format the time as hh:mm a (AM/PM format)
      String formattedTime = DateFormat('hh:mm a').format(dateTime);

      return formattedTime;
    } catch (e) {
      return "NA";
    }
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        onDoubleTap: () async {
          if(convertEpochToTime(user.timeleave)=="NA"){
            DateTime d=DateTime.now();
            await FirebaseFirestore.instance.collection('School').doc(schoolid).collection("Gate").doc("History").collection("${d.day}-${d.month}-${d.year}").doc(user.id).update({
              "timeleave":DateTime.now().millisecondsSinceEpoch.toString(),
            });
          }
        },
        onLongPress: () async {
          if(convertEpochToTime(user.timeleave)=="NA"){
            DateTime d=DateTime.now();
            await FirebaseFirestore.instance.collection('School').doc(schoolid).collection("Gate").doc("History").collection("${d.day}-${d.month}-${d.year}").doc(user.id).update({
              "timeleave":DateTime.now().millisecondsSinceEpoch.toString(),
            });
          }
        },
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.only(left: 12,right: 12),
                child: Row(
                  children: [
                    Text("Gate ID : STID"+user.id+"TG"),
                    Spacer(),
                    convertEpochToTime(user.timeleave)=="NA"?InkWell(
                      onTap: () async {
                        DateTime d=DateTime.now();
                       await FirebaseFirestore.instance.collection('School').doc(schoolid).collection("Gate").doc("History").collection("${d.day}-${d.month}-${d.year}").doc(user.id).update({
                         "timeleave":DateTime.now().millisecondsSinceEpoch.toString(),
                       });
                      },
                      child: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                          child: Text("Exit",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ):SizedBox()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12,right: 12),
                child: Row(
                  children: [
                    Text("Entry Time : "+convertEpochToTime(user.id)),
                    SizedBox(width: 25,),
                    Text("Exit Time : "+convertEpochToTime(user.timeleave)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12,right: 12),
                child: Row(
                  children: [
                    Container(
                        width:MediaQuery.of(context).size.width-38,
                        child: Text("Reason : "+user.reason,textAlign:TextAlign.left,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),)),
                    Spacer()
                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.pic),
                ),
                title: Text("Parent Name :"+ user.parentname,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                subtitle: Text("Student Name :"+ user.studentname+ "  ${user.classs}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

class GateKeeperWidget extends StatefulWidget {
  UserModel user;
  String schoolid;String schoolname;String lancode;
  GateKeeperWidget({Key? key,required this.schoolid,required this.schoolname,required this.lancode,required this.user}) : super(key: key);

  @override
  State<GateKeeperWidget> createState() => _GateKeeperWidgetState();
}

class _GateKeeperWidgetState extends State<GateKeeperWidget> {
  final TextEditingController idController = TextEditingController();

  final TextEditingController parentNameController = TextEditingController();

  final TextEditingController timenowController = TextEditingController();

  final TextEditingController timeleaveController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController picController = TextEditingController();

  final TextEditingController pic2signController = TextEditingController();

  final TextEditingController reasonController = TextEditingController();

  final TextEditingController stname = TextEditingController();
  final TextEditingController stclas = TextEditingController();
  bool verified = false;

  bool accept = false;

  // Function to generate a TextFormField
  Widget buildTextFormField(String label, TextEditingController controller,bool number) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0,right: 14,top: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }

  bool drawn=false;
  String newf="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('GateKeeper Form'),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor:drawn?Colors.blue:Colors.grey,
            height: 40,
            text:'Add New Form',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              if(drawn){
                final nes = DateTime.now().millisecondsSinceEpoch.toString();
                final DateTime d=DateTime.now();
               GateKeeper ui= GateKeeper(id: nes, parentname: parentNameController.text, verified: verified,
                    accept: accept, timenow: nes, timeleave: "",
                    phone: phoneController.text, email: emailController.text, pic: picController.text,
                    pic2sign: picController.text, reason: reasonController.text, studentname: stname.text, classs: stclas.text);
               await FirebaseFirestore.instance.collection('School').doc(widget.schoolid).collection("Gate").doc("History")
                   .collection("${d.day}-${d.month}-${d.year}").doc(nes).set(ui.toJson());
               speak("Respected ${parentNameController.text}, Welcome to our ${widget.schoolname}","सम्माननीय श्री ${parentNameController.text} जी आपका ${widget.schoolname} में स्वागत है");
               Navigator.pop(context);
                Send.message(context, "New Gate Form Added", true);
              }else{
                Send.message(context, "Please Sign and click Export", false);
              }
            },
          ),
        )
      ],
      body: Column(
        children: [
          buildTextFormField('Parent Name', parentNameController,false),
          buildTextFormField('Phone', phoneController,true),
          buildTextFormField('Reason for Visit', reasonController,false),
          SizedBox(height: 8,),
          stname.text.isEmpty? ListTile(
            onTap: () async {
              StudentModel u = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SessionJust(id: widget.user.schoolid, student: true, reminder :false, sname : "NA")),
              );
              print(u.Name);
              setState(() {
                stclas.text=u.Class+" ("+u.Section+")";
                stname.text=u.Name;
                picController.text=u.pic;
                newf=u.Father_Name;
              });
            },
            splashColor: Colors.orange,
            tileColor: Colors.greenAccent.shade100,
            leading: Icon(Icons.dataset_rounded),
            title: Text("Find Student",
                style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text("Find Student & Add "),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ) :
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(picController.text),
            ),
            title: Text(stname.text,style : TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("Class :"+stclas.text),
            trailing: Icon(Icons.verified, color : Colors.green),
          ),
          Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: scrollTest
              ? Container(
            width: 499, height: 300,
            color: Colors.grey,
          )
              : SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 2.0,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints.expand(),
                                color: Colors.white,
                                child: HandSignature(
                                  control: control,
                                  type: SignatureDrawType.shape,
                                  // supportedDevices: {
                                  //   PointerDeviceKind.stylus,
                                  // },
                                ),
                              ),
                              CustomPaint(
                                painter: DebugSignaturePainterCP(
                                  control: control,
                                  cp: false,
                                  cpStart: false,
                                  cpEnd: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap:(){
                            control.clear();
                            svg.value = null;
                            rawImage.value = null;
                            rawImageFit.value = null;
                          },
                          child: Container(
                            width: 75,
                            height:60,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.indigo,
                            ),
                            child: Center(child: Text('Clear',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
                          ),
                        ),
                        InkWell(
                          onTap:() async {
                            svg.value = control.toSvg(
                              color: Colors.blueGrey,
                              type: SignatureDrawType.shape,
                              fit: true,
                            );
                            rawImage.value = await control.toImage(
                              color: Colors.blueAccent,
                              background: Colors.greenAccent,
                              fit: false,
                            );
                            rawImageFit.value = await control.toImage(
                              color: Colors.black,
                              //background: Colors.greenAccent,
                              fit: true,
                            );
                            setState((){
                              drawn = true;
                            });
                          },
                          child: Container(
                            width: 75,
                            height: 60.0,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.purpleAccent,
                            ),
                            child: Center(child: Text('Export',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildImageView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: hgy(),
          ),
        ],
      ),
    );
  }
  Widget hgy(){
    if(newf.isEmpty||newf==""||parentNameController.text.isEmpty) {
      return SizedBox();
    }
    if(newf==parentNameController.text){
      return SizedBox();
    }
    return Container(
      width: MediaQuery.of(context).size.width-50,
      color:Colors.red,
      child:Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(child: Text("Father Name do not Match",style: TextStyle(color: Colors.white),)),
      ),
    );
  }

void initState(){
   languageCode = widget.lancode;
}
  TextToSpeech tts = TextToSpeech();
  String defaultLanguage = 'en-US';
  late String? languageCode = widget.lancode; // Default to English
  double volume = 1.0;
  double rate = 1.0;
  double pitch = 1.0;
  String? voice;

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



  bool get scrollTest => false;

  Widget _buildImageView() => Container(
    width: 192.0,
    height: 96.0,
    decoration: BoxDecoration(
      border: Border.all(),
      color: Colors.white30,
    ),
    child: ValueListenableBuilder<ByteData?>(
      valueListenable: rawImage,
      builder: (context, data, child) {
        if (data == null) {
          return Container(
            color: Colors.red,
            child: Center(
              child: Text('not signed yet (png)\nscaleToFill: false'),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.memory(data.buffer.asUint8List()),
          );
        }
      },
    ),
  );
/* Row(
  children: <Widget>[
  const Text('Language'),
  const SizedBox(
  width: 20,
  ),
  DropdownButton<String>(
  value: language,
  icon: const Icon(Icons.arrow_downward),
  iconSize: 24,
  elevation: 16,
  style: const TextStyle(color: Colors.deepPurple),
  underline: Container(
  height: 2,
  color: Colors.deepPurpleAccent,
  ),
  onChanged: (String? newValue) async {
  languageCode =
  await tts.getLanguageCodeByName(newValue!);
  voice = await getVoiceByLang(languageCode!);
  setState(() {
  language = newValue;
  });
  },
  items: languages
      .map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
  value: value,
  child: Text(value),
  );
  }).toList(),
  ),
  ],
  ),*/
}
HandSignatureControl control = new HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

ValueNotifier<String?> svg = ValueNotifier<String?>(null);

ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

