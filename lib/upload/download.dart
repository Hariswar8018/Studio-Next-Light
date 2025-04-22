import 'dart:convert';
import 'dart:io';
<<<<<<< HEAD
import 'package:intl/intl.dart';
=======
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
<<<<<<< HEAD
import 'package:student_managment_app/anew/school_service/click_photo/direcy/download_pic.dart';
import 'package:student_managment_app/attendance/Qr_code.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
=======
import 'package:studio_next_light/model/student_model.dart';
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
import 'package:download/download.dart' ;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:ui' as ui ;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' ;
<<<<<<< HEAD
import 'package:student_managment_app/upload/download_qr.dart';

class Download extends StatefulWidget {
  String id ;
  List<StudentModel> list = [];
  String session ;bool newb;SchoolModel school;
  String classu ;int i;
   Download({super.key, required this.id , required this.session, required this.classu,required this.list,required this.i,required this.school,required this.newb});

  @override
  State<Download> createState() => _DownloadState();
}
Set<StudentModel> selectedStudents = {};

class _DownloadState extends State<Download> {


  late Map<String, dynamic> userMap;

  final Fire = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    selectedStudents = {};
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Download all Student Data")),
      body: Column(
        children: [
          Container(
            height: 110,
            width: w,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade500,
                child: Icon(Icons.download_for_offline, size: 55, color: Colors.white),
=======
import 'package:studio_next_light/upload/download_qr.dart';

class Download extends StatelessWidget {

  String id ;
  String session ;
  String classu ;
   Download({super.key, required this.id , required this.session, required this.classu});
  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Download all Student Data")
      ),
      body : Column(
        children: [
          Container(
            height : 220,
            child: Center(
              child: CircleAvatar(
                radius: 68,
                backgroundColor: Colors.blue.shade500,
                child: Icon(Icons.download_for_offline, size : 55, color : Colors.white),
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
              ),
            ),
          ),
          Container(
<<<<<<< HEAD
            height: h-260,width: w,
            child: ListView.builder(
                    itemCount: widget.list.length,
                    padding: EdgeInsets.only(top: 10),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
            return ChatUser(
              user: widget.list[index],
              c: widget.classu,
              s: widget.session,
              school: widget.id,
              il: widget.i,
              isSelected: selectedStudents.contains(widget.list[index]),
              onLongPress: () {
                setState(() {
                  if (selectedStudents.contains(widget.list[index])) {
                    selectedStudents.remove(widget.list[index]);
                  } else {
                    selectedStudents.add(widget.list[index]);
                  }
                });
              },
            );
                    },
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        widget.i==0?Center(
          child: InkWell(
            onTap: () async {
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request();
              }
              if (selectedStudents.isEmpty) {
                Send.message(context, "Downloading QR....", true);
                Navigator.push(
                    context, PageTransition(
                    child: Download2(id: widget.id, session: widget.session, classu: widget.classu, list: widget.list,), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                ));
              } else {
                Send.message(context, "Downloading QR of ${selectedStudents.length} Students", true);
                Navigator.push(
                    context, PageTransition(
                    child: Download2(id: widget.id, session: widget.session, classu: widget.classu, list:selectedStudents.toList(),), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                ));
              }
            },
            child: Container(
              height:45,width:w-15,
              decoration:BoxDecoration(
                borderRadius:BorderRadius.circular(7),
                color:Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                    spreadRadius: 5, // The extent to which the shadow spreads
                    blurRadius: 7, // The blur radius of the shadow
                    offset: Offset(0, 3), // The position of the shadow
                  ),
                ],
              ),
              child: Center(child: Text("Start QR Download",style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RobotoS",fontWeight: FontWeight.w800
              ),)),
            ),
          ),
        ):
        (widget.i==1)?Center(
          child: InkWell(
            onTap:  () async {
              if(widget.newb){
                var status = await Permission.storage.status;
                if (!status.isGranted) {
                  await Permission.storage.request();
                }
                if (selectedStudents.isEmpty) {
                  Send.message(context, "Downloading Pass....", true);
                  Navigator.push(
                      context, PageTransition(
                      child: Download4( list: widget.list, school: widget.school,session: widget.session,), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                  ));
                } else {
                  Send.message(context, "Downloading Pass of ${selectedStudents.length} Students", true);
                  Navigator.push(
                      context, PageTransition(
                      child: Download4( list:selectedStudents.toList(), school: widget.school,session: widget.session,), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                  ));
                }
              }else{
                var status = await Permission.storage.status;
                if (!status.isGranted) {
                  await Permission.storage.request();
                }
                try{
                  Send.message(context, "Downloading..........", true);
                  if (selectedStudents.isEmpty) {
                    await downloadPic(widget.list);
                  } else {
                    await downloadPic(selectedStudents.toList());
                  }
                  Send.message(context, "Done ! Images saved to Storage/Pictures", true);
                }catch(e){
                  Send.message(context, "$e", false);
                }
              }
              
            },
            child: Container(
              height:45,width:w-15,
              decoration:BoxDecoration(
                borderRadius:BorderRadius.circular(7),
                color:Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                    spreadRadius: 5, // The extent to which the shadow spreads
                    blurRadius: 7, // The blur radius of the shadow
                    offset: Offset(0, 3), // The position of the shadow
                  ),
                ],
              ),
              child: Center(child: Text("Start Pic Download",style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RobotoS",fontWeight: FontWeight.w800
              ),)),
            ),
          ),
        ):
        Center(
          child: InkWell(
            onTap: () async {
              try{
                Send.message(context, "Exporting..........", true);
                if (selectedStudents.isEmpty) {
                  await downloadCollection(widget.list);
                } else {
                  await downloadCollection(selectedStudents.toList());
                }
                Send.message(context, "Done ! File saved to: /storage/emulated/0/Android/data/com.heavenonthisearth.student_managment_app/files/list.csv", true);
              }catch(e){
                Send.message(context, "$e", true);
              }
            },
            child: Container(
              height:45,width:w-15,
              decoration:BoxDecoration(
                borderRadius:BorderRadius.circular(7),
                color:Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                    spreadRadius: 5, // The extent to which the shadow spreads
                    blurRadius: 7, // The blur radius of the shadow
                    offset: Offset(0, 3), // The position of the shadow
                  ),
                ],
              ),
              child: Center(child: Text("Start CSV Download",style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RobotoS",fontWeight: FontWeight.w800
              ),)),
            ),
          ),
=======
            height : MediaQuery.of(context).size.height - 220,
            child : StreamBuilder(
              stream: Fire.collection('School')
                  .doc(id)
                  .collection('Session')
                  .doc(session)
                  .collection("Class")
                  .doc(classu)
                  .collection("Student")
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

                    return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: 10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUser(
                          user: list[index],
                          c : classu,
                          s : session,
                          school: id,
                        );
                      },
                    );
                }
              },
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        Column(
          children: [
            SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'DOWNLOAD QR Codes',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Downloading QR....'),
                  ),
                );
                Navigator.push(
                    context, PageTransition(
                    child: Download2(id: id, session: session, classu: classu,), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                ));
              },
            ),
            SizedBox(height : 10),
            SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'DOWNLOAD CSV ',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                try{
                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                      content: Text(
                          'Exporting....'),
                    ),
                  );
                  await downloadCollection(list);
                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                      content: Text(
                          'Done ! File saved to: /storage/emulated/0/Android/data/com.heavenonthisearth.studio_next_light/files/list.csv'),
                    ),
                  );
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                      content: Text(
                          '${e}'),
                    ),
                  );
                }
              },
            ),
            SizedBox(height : 10),
            SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'DOWNLOAD PICTURES ',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                try{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Exporting....'),
                    ),
                  );
                downloadPic(list);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Done ! Images saved to Storage/Pictures'),
                    ),
                  );
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${e}'),
                    ),
                  );
                }
              },
            ),
          ],
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
        ),
      ],
    );
  }

  Future downloadCollection(List<StudentModel>? docs) async{
    docs = docs ?? [] ;
    String fileContent = "name, brand";
    List<List<dynamic>> rows = [];
    rows.add(["Roll Number", "Name", "Pic Name", "Father Name", "Mobile", "Address", "Class", "Section",
<<<<<<< HEAD
    "Department", "DOB", "BloodGroup","Admission Number","Registration Number," "Email", "Mother Name", "Other 1", "Other 2", "Other 3", "Other 4"
=======
    "Department", "DOB", "BloodGroup", "Email", "Mother Name", "Other 1", "Other 2", "Other 3", "Other 4"
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
    ]);
    docs.asMap().forEach((index, record){
      fileContent = fileContent +
          "\n" +record.Name.toString()
<<<<<<< HEAD
          + "," + record.Registration_number.toString();
      print("\n" +record.Name.toString()
          + "," + record.Pic_Name.toString());
      rows.add([record.Roll_number.toString(), record.Name, record.Registration_number.toString(),
      record.Father_Name, record.Mobile, record.Address , record.Class, record.Section, record.Department,
        hjk(record.newdob), record.BloodGroup, record.Admission_number,record.Registration_number,
        record.Email, record.Mother_Name, record.Other1,
=======
          + "," + record.Pic_Name.toString();
      print("\n" +record.Name.toString()
          + "," + record.Pic_Name.toString());
      rows.add([record.Roll_number.toString(), record.Name, record.Pic_Name.toString(),
      record.Father_Name, record.Mobile, record.Address , record.Class, record.Section, record.Department,
        record.newdob, record.BloodGroup, record.Email, record.Mother_Name, record.Other1,
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
        record.Other2, record.Other3, record.Other4
      ]);
    } );
    print(rows);
    String csv = const ListToCsvConverter().convert(rows);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      String dir = (await getExternalStorageDirectory())!.path;
<<<<<<< HEAD
      String filePath = "$dir/id_${widget.id}_${widget.classu}_list.csv";
=======
      String filePath = "$dir/id_${id}_${classu}_list.csv";
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
      File file = File(filePath);
      await file.writeAsString(csv);
      print("File saved to: $filePath");
    } else {
      print("Permission denied for storage.");
    }
  }

<<<<<<< HEAD
  String hjk( String g ) {
    String dateTimeString = g; // Replace with your DateTime string
    print(g);
    // Convert DateTime string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate ;
  }

=======
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
 Future downloadPic(List<StudentModel>? docs) async{
    docs = docs ?? [] ;
    var status = await Permission.storage.status;
    if (status.isGranted) {
      var dir = await getExternalStorageDirectory();
      for (var record in docs) {
                try {
          var response = await Dio().get(
              record.pic,
              options: Options(responseType: ResponseType.bytes));
          final result = await ImageGallerySaver.saveImage(
              Uint8List.fromList(response.data),
              quality: 100,
              name: "${record.Pic_Name}");
          print(result);
          print("Image downloaded successfully for ${record.Name}");
        } catch (error) {
          print("Error downloading image for ${record.Name} : $error");
        }
      }
      print("CSV File saved to: ");
    } else {
      print("Permission denied for storage.");
    }
  }
}



class ChatUser extends StatelessWidget {
<<<<<<< HEAD
  final String c;
  final String s;
  int il;
  final String school;
  final StudentModel user;
  final bool isSelected;
  final VoidCallback onLongPress;

  ChatUser({
    Key? key,
    required this.il,
    required this.user,
    required this.school,
    required this.s,
    required this.c,
    required this.isSelected,
    required this.onLongPress,
  }) : super(key: key);
=======
  String c;
  String s;
  String school;
  StudentModel user;

  ChatUser({super.key, required this.user, required this.school, required this.s ,required this.c});
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
<<<<<<< HEAD
      subtitle: Text("Updated "+timeAgoFromMilliseconds(user.Registration_number)+" ago",style: TextStyle(color: Colors.grey,fontSize: 15),),
      splashColor: Colors.orange.shade300,
      trailing: IconButton(
        icon: isSelected ? Icon(Icons.check_box, color: Colors.black):Icon(Icons.check_box_outline_blank, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: Qrcode(
                school_id: school,
                class_id: c,
                sesiion: s,
                idi: user.Registration_number,
              ),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 800),
            ),
          );
        },
      ),
      onTap: onLongPress,
      onLongPress: onLongPress,
    );
  }
  String timeAgoFromMilliseconds(String millisString) {
    try {
      int millis = int.parse(millisString);
      DateTime givenDate = DateTime.fromMicrosecondsSinceEpoch(millis);
      DateTime now = DateTime.now();

      // Calculate the difference between the two dates
      Duration difference = now.difference(givenDate);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} sec';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hr';
      } else if (difference.inDays < 30) {
        return '${difference.inDays} day';
      } else if (difference.inDays < 365) {
        int months = (difference.inDays / 30).floor();
        return '$months month';
      } else {
        int years = (difference.inDays / 365).floor();
        return '$years year';
      }
    }catch(e){
      return "Long Time ago";
    }
  }
=======
      subtitle: Text("Roll no : " +
          user.Roll_number.toString() +
          "   " +
          user.Class +
          user.Section ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
}
