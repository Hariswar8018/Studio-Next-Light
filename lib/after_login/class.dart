import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/attendance/attendance_statistics.dart';
import 'package:student_managment_app/after_login/students.dart';

class Class extends StatefulWidget {
  String id;
  String session_id;
  String Session;
  String School;
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;

  Class({super.key, required this.id, required this.session_id, required this.School, required this.Session,
  required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  bool  fees = true ;

  List<SessionModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.orange,
          title: Text('Choose Your Class'),
          actions:[
            CupertinoSwitch(
              value: fees,
              onChanged: (value) {
                setState(() {
                  fees = value;
                });
              },
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              SessionModel s = SessionModel(Name: "0", id: widget.id, status: "0",
                  total: 0, Total_Fee: "0", MTF: "0", Ad_Fee: "0", feet : 0,
                  DevF: "0", ExamF: "0", TutionF: "0", MonthlyF: "0",
                  LetF: "0", TransportF: "0", ID_Card_Fee: "0", sset : 0,
                  section: "0");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(id: widget.id, session_id: widget.session_id, b : false, user : s ),
                ),
              );
            },
            child: Icon(Icons.add)),
        body: StreamBuilder(
          stream: Fire.collection('School').doc(widget.id).collection('Session').doc(widget.session_id).collection("Class").orderBy("Name").snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data
                    ?.map((e) => SessionModel.fromJson(e.data()))
                    .toList() ??
                    [];
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index], id: widget.id, sessionid: widget.session_id,
                      Session : widget.Session , School : widget.School,
                      EmailB: widget.EmailB, RegisB: widget.RegisB, Other4B: widget.Other4B,
                      Other3B: widget.Other3B, Other2B: widget.Other2B, Other1B: widget.Other1B,
                      MotherB: widget.MotherB, DepB: widget.DepB, BloodB: widget.BloodB, fees : fees,
                    );
                  },
                );
            }
          },
        ),
    );
  }
}

class ChatUser extends StatefulWidget {
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;
  SessionModel user;
  String id ;
  String sessionid;
  String Session ;
  String School ;
  bool fees ;
  ChatUser({super.key, required this.user, required this.id, required this.sessionid, required this. Session, required this.School,
    required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB, required this.fees});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int i = 0 ; int j = 0;
   void initState(){
     countTotalMfValue("j") ;
     countDocumentsWithPresent();
     cccc();
   }
   int s4 = 0 ;

   void cccc() async {
     s4 = int.parse(widget.user.Total_Fee) * widget.user.feet * 12 ;
     print(widget.user.Total_Fee);
     print(widget.user.feet);
     print(s4);
     CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.sessionid).collection('Class');
     await collection.doc(widget.user.id).update({
       "sset" : s4,
     });
   }
   void countTotalMfValue(String id) async {
      int totalMfValue = 0;
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('School')
            .doc(widget.id)
            .collection('Session')
            .doc( widget.sessionid)
            .collection('Class')
            .doc(widget.user.id)
            .collection('Student')
            .get();
        // Iterate over each document in the collection
        querySnapshot.docs.forEach((doc) {
          // Check if the document data is not null and is of type Map<String, dynamic>
          if (doc.data() != null && doc.data() is Map<String, dynamic>) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Check if the document contains the 'Mf' field
            if (data.containsKey('Mf')) {
              // Get the value of the 'Mf' field and add it to the totalMfValue
              dynamic mfValue = data['Mf'];
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
        if ( widget.user.feet != totalMfValue){
          CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.sessionid).collection('Class');
          await collection.doc(widget.user.id).update({
            "feet" : totalMfValue,
          });
        }

        print("Total value of 'Mf' across all documents: $totalMfValue");
      } catch (error) {
        print("Error counting total 'Mf' value: $error");
      }
    }
   void countDocumentsWithPresent() async {
    int count = 0;
    DateTime date = DateTime.now();
    String str = '${date.day}-${date.month}-${date.year}';
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.id)
        .collection('Session').doc(widget.sessionid).collection("Class").doc(widget.user.id).collection("Student")
        .where("Present", arrayContains: str)
        .get()
        .then((querySnapshot) async {
      count = querySnapshot.docs.length;
      setState(() async {
        j = querySnapshot.docs.length;
      });
      CollectionReference collection = FirebaseFirestore.instance.collection('School')
          .doc(widget.id).collection('Session')
          .doc(widget.sessionid).collection('Class');
      await collection.doc(widget.user.id).update({
        "pcount" : querySnapshot.docs.length,
      });
    }).catchError((error) {
      print("Error counting documents: $error");
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text( "Class : " + widget.user.Name + " (" + widget.user.section + ")", style : TextStyle(fontWeight : FontWeight.w700)),
      subtitle:  Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(id: widget.id, session_id: widget.sessionid, b : true , user : widget.user),
                ),
              );
            }, child: Text("Edit Mode", style : TextStyle(color : Colors.red)),
          ),
          SizedBox(width :10),
          InkWell(
            onTap: (){
              Navigator.push(
                  context, PageTransition(
                  child: StudentsJust8(id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
                    sname: widget.Session, cname: widget.user.Name, csection: widget.user.section, name: widget.School,
                  ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
              ));
            }, child: Text("Attendance", style : TextStyle(color : Colors.blueAccent)),
          ), SizedBox(width :10),
        ],
      ),
      onLongPress: (){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete this ?'),
            content: Text('Do you really want to delete this Sesssion including all Students'),
            actions: [
              TextButton(
                onPressed: () async {
                  CollectionReference collection1 = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.sessionid).collection('Class');
                  await collection1.doc(widget.user.id).update({
                    "ou":"Waiting",
                  }) ;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('This Class will be Deleted soon after Admin Approval'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),

              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    },
      onTap: () {
        if(widget.user.ou=="Waiting"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Class Will be Deleted Soon'),
                content: Text('Admin will delete this Class Manually ! Thanks for Patience'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                  TextButton(
                    onPressed: () async{
                      CollectionReference collection1 = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.sessionid).collection('Class');
                      await collection1.doc(widget.user.id).update({
                        "ou":"Waitgkugjgjing",
                      }) ;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('This Class is Live again'),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('No, Recover Class Now'),
                  ),
                ],
              );
            },
          );
        }else{
          Navigator.push(
              context, PageTransition(
              child: Students(id: widget.id, session_id: widget.sessionid, class_id: widget.user.id, shop: widget.user.status,
                Session : widget.Session, Class : widget.user.Name , sec : widget.user.section, School : widget.School,
                EmailB: widget.EmailB, RegisB: widget.RegisB, Other4B: widget.Other4B,
                Other3B: widget.Other3B, Other2B: widget.Other2B, Other1B: widget.Other1B,
                MotherB: widget.MotherB, DepB: widget.DepB, BloodB: widget.BloodB, feeo: widget.fees, fee : stringToInt(widget.user.Total_Fee) ,
              ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
          ));
        }
      },
      trailing : widget.user.ou=="Waiting"?Icon(
        Icons.hourglass_bottom,
        color: Colors.red,
        size: 20,
      ):!widget.fees ? Text(addCommas(i),  style: TextStyle(fontWeight: FontWeight.bold, color : i > 5000 ? Colors.red : Colors.black, fontSize : 21)) : RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
             TextSpan(
              text: j.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.blue, fontSize : 23),
            ),
            TextSpan(
              text: ' / ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: widget.user.total.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.black, fontSize : 18),
            ),
          ],
        ),
      ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return "₹" + formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    formattedNumber = "₹" + formattedNumber ;
    return formattedNumber;
  }

  int stringToInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      // If parsing fails, return 0
      return 0;
    }
  }
}

class Add extends StatefulWidget {
  String id;
  String session_id ; bool b ; SessionModel user;

  Add({super.key, required this.id, required this.session_id, required this.b, required this.user});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  
  
  void initState(){
    setState((){
       sessionNameController.text = widget.user.Name;
       sessionNameController1.text =  widget.user.section;
       MTF.text =  widget.user.MTF;
       Ad_Fee.text =  widget.user.Ad_Fee;
       Dev_F.text =  widget.user.DevF;

       Exam_F.text =  widget.user.ExamF;

       Tution_F.text =  widget.user.TutionF;

       Monthly_F.text =  widget.user.MonthlyF;

       Late_Fee.text =  widget.user.LetF;

       Transport_Fee.text =  widget.user.TransportF;

       ID_Car.text =  widget.user.ID_Card_Fee;

       Addition.text =  widget.user.Ad_Fee;
    });
  }
  TextEditingController sessionNameController = TextEditingController();
 TextEditingController sessionNameController1 = TextEditingController();
  TextEditingController MTF = TextEditingController();
  TextEditingController GST = TextEditingController();
  TextEditingController Ad_Fee = TextEditingController();
  TextEditingController Dev_F = TextEditingController();

  TextEditingController Exam_F = TextEditingController();

  TextEditingController Tution_F = TextEditingController();

  TextEditingController Monthly_F = TextEditingController();

  TextEditingController Late_Fee = TextEditingController();

  TextEditingController Transport_Fee = TextEditingController();

  TextEditingController ID_Car = TextEditingController();

  TextEditingController Addition = TextEditingController();

  String s = " ";

  TextEditingController Feef = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text( widget.b ? "Edit Class " : "Add Class"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: sessionNameController,
                  decoration: InputDecoration(
                    labelText: 'Class Name ( in Roman or Numeric )',
                    hintText: 'X',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please type your Password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    /*setState(() {
                      s = value;
                    });*/
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: sessionNameController1,
                  maxLength: 1,
                  decoration: InputDecoration(
                    labelText: 'Section',
                    hintText: 'A',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please type your Password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    /*setState(() {
                      s = value;
                    });*/
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left : 10.0, right : 10),
                child: Text("*The Class Name and Section will be same for All Students under this Class", style : TextStyle(fontSize : 13, color : Colors.red)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.credit_card, size: 30, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Fees Default",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Amount for Students :  ₹ " + Feef.text, style : TextStyle(fontWeight : FontWeight.w800, fontSize: 22)),
              ),
              max(Addition, "Additional Fee", "100.0", true),
              f(context, MTF, "MT Fee", "0.0", true, Ad_Fee, "Admission Fee", "0.0", true),
              f(context, Dev_F, "Development Fee", "0.0", true, Exam_F, "Exam Fee", "0.0", true),
              f(context, Tution_F, "Tution Fee", "0.0", true, Monthly_F, "Monthly Fee", "0.0", true),
              f(context, Late_Fee, "Late Fee", "0.0", true, Transport_Fee, "Transport Fee", "0.0", true),
              f(context, ID_Car, "ID Card Fee", "0.0", true, GST, "GST", "0.0", true),
              Text("*Fees if changed, It would be synced to Student from Next Calender Month ", style : TextStyle(color : Colors.red)),
              SizedBox(height : 10),
            ],
          ),
        ),
      ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: widget.b ? "Save Class":'Add Class Now',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                if ( widget.b){
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.session_id).collection('Class');
                    SessionModel s = SessionModel(Name: sessionNameController.text, section :sessionNameController1.text, id: widget.user.id, status: "Still Uploading", total: 0,
                        Total_Fee: Feef.text, MTF: MTF.text, Ad_Fee: Ad_Fee.text,
                        DevF: Dev_F.text, ExamF: Exam_F.text, TutionF: Tution_F.text, feet : 0, sset : 0,
                        MonthlyF: Monthly_F.text, LetF: Late_Fee.text, TransportF: Transport_Fee.text,
                        ID_Card_Fee: ID_Car.text);
                    await collection.doc(widget.user.id).update(s.toJson());
                    Navigator.pop(context);
                  } catch (e) {
                    print('${e}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${e}'),
                      ),
                    );
                  }

                }else{
                  try {
                    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.session_id).collection('Class');
                    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString(); // Replace with your own custom ID
                    SessionModel s = SessionModel(Name: sessionNameController.text, section :sessionNameController1.text, id: customDocumentId, status: "Still Uploading", total: 0,
                        Total_Fee: Feef.text, MTF: MTF.text, Ad_Fee: Ad_Fee.text,
                        DevF: Dev_F.text, ExamF: Exam_F.text, TutionF: Tution_F.text, feet : 0, sset : 0,
                        MonthlyF: Monthly_F.text, LetF: Late_Fee.text, TransportF: Transport_Fee.text,
                        ID_Card_Fee: ID_Car.text);
                    await collection.doc(customDocumentId).set(s.toJson());
                    Navigator.pop(context);
                  } catch (e) {
                    print('${e}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${e}'),
                      ),
                    );
                  }
                };
              },
            ),
          ),
          ],
    );
  }

  Widget f(BuildContext context, TextEditingController t1, String s1, String s2, bool b1, TextEditingController t2, String s3, String s4, bool b2){
    return Container(
      width : MediaQuery.of(context).size.width,
      child: Row(
          children : [
            Container(
                width : MediaQuery.of(context).size.width/2 - 10,
                child: max(t1, s1, s2, b1)),
            Container(
                width : MediaQuery.of(context).size.width/2 - 10,
                child: max(t2, s3, s3, b2)),
          ]
      ),
    );
  }

  Widget max(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
        onChanged: (value){
          int mtf = int.tryParse(MTF.text) ?? 0;
          int adFee = int.tryParse(Ad_Fee.text) ?? 0;
          int devF = int.tryParse(Dev_F.text) ?? 0;
          int examF = int.tryParse(Exam_F.text) ?? 0;
          int tutionF = int.tryParse(Tution_F.text) ?? 0;
          int monthlyF = int.tryParse(Monthly_F.text) ?? 0;
          int lateFee = int.tryParse(Late_Fee.text) ?? 0;
          int transportFee = int.tryParse(Transport_Fee.text) ?? 0;
          int idCar = int.tryParse(ID_Car.text) ?? 0;
          int addition = int.tryParse(Addition.text) ?? 0;
          int gst = int.tryParse(GST.text) ?? 0;
          // Add up all the integer values
          int total = mtf + adFee + devF + examF + tutionF + monthlyF + lateFee + transportFee + idCar + addition + gst;
          // Set the Feef.text as the total converted to string
          Feef.text = total.toString();
        },
      ),
    );
  }
}

class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,required this.sset,
    required this.feet,
    required this.status,
    required this.total ,
    required this.Total_Fee,
    required this.MTF,
    required this.Ad_Fee,
    required this.DevF,
    required this.ExamF,
    required this.TutionF,
    required this.MonthlyF,
    required this.LetF,
    required this.TransportF,
    required this.ID_Card_Fee,
    required this.section,
  });

  late final String Name;
  late final int feet;
  late final String id;
  late final String section ;
  late final String status;
  late final int total ;
  late final String Total_Fee;
  late final String MTF;
  late final String Ad_Fee;
  late final String DevF;
  late final String ExamF;
  late final String TutionF;
  late final int pcount ;
  late final String MonthlyF;
  late final String LetF;
  late final String TransportF;
  late final String ID_Card_Fee;
  late final int sset ;
  late final String ou;
  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    ou=json['ou']??"h";
    sset = json['sset'] ?? 0;
    pcount = json['pcount'] ?? 0;
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    status = json['status'] ?? "Still Uploading";
    total = json['total'] ?? 0 ;
    Total_Fee = json['Total_Fee'] ?? "";
    MTF = json['MTF'] ?? "";
    feet = json['feet'] ?? 0 ;
    Ad_Fee = json['Ad_Fee'] ?? "";
    DevF = json['DevF'] ?? "";
    ExamF = json['ExamF'] ?? "";
    section = json["S"] ?? "A";
    TutionF = json['TutionF'] ?? "";
    MonthlyF = json['MonthlyF'] ?? "";
    LetF = json['LetF'] ?? "";
    TransportF = json['TransportF'] ?? "";
    ID_Card_Fee = json['ID_Card_Fee'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['S'] = section ;
    data['status'] = status;
    data['id'] = id ;
    data['feet'] = feet ;
    data['Total_Fee'] = Total_Fee;
    data['MTF'] = MTF;
    data['Ad_Fee'] = Ad_Fee;
    data['DevF'] = DevF;
    data['ExamF'] = ExamF;
    data['TutionF'] = TutionF;
    data['sset'] = sset ;
    data['MonthlyF'] = MonthlyF;
    data['LetF'] = LetF;
    data['TransportF'] = TransportF;
    data['ID_Card_Fee'] = ID_Card_Fee;
    data['total'] = total ;
    return data;
  }

  static SessionModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SessionModel.fromJson(snapshot);
  }
}
