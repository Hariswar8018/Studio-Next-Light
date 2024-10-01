import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/anew/school_service/click_photo/direcy/download_pic.dart';
import 'package:student_managment_app/attendance/Qr_code.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
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
              ),
            ),
          ),
          Container(
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
        ),
      ],
    );
  }

  Future downloadCollection(List<StudentModel>? docs) async{
    docs = docs ?? [] ;
    String fileContent = "name, brand";
    List<List<dynamic>> rows = [];
    rows.add(["Roll Number", "Name", "Pic Name", "Father Name", "Mobile", "Address", "Class", "Section",
    "Department", "DOB", "BloodGroup","Admission Number","Registration Number," "Email", "Mother Name", "Other 1", "Other 2", "Other 3", "Other 4"
    ]);
    docs.asMap().forEach((index, record){
      fileContent = fileContent +
          "\n" +record.Name.toString()
          + "," + record.Registration_number.toString();
      print("\n" +record.Name.toString()
          + "," + record.Pic_Name.toString());
      rows.add([record.Roll_number.toString(), record.Name, record.Registration_number.toString(),
      record.Father_Name, record.Mobile, record.Address , record.Class, record.Section, record.Department,
        hjk(record.newdob), record.BloodGroup, record.Admission_number,record.Registration_number,
        record.Email, record.Mother_Name, record.Other1,
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
      String filePath = "$dir/id_${widget.id}_${widget.classu}_list.csv";
      File file = File(filePath);
      await file.writeAsString(csv);
      print("File saved to: $filePath");
    } else {
      print("Permission denied for storage.");
    }
  }

  String hjk( String g ) {
    String dateTimeString = g; // Replace with your DateTime string
    print(g);
    // Convert DateTime string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate ;
  }

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
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
}
