import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:studio_next_light/model/student_model.dart';
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
              ),
            ),
          ),
          Container(
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
        ),
      ],
    );
  }

  Future downloadCollection(List<StudentModel>? docs) async{
    docs = docs ?? [] ;
    String fileContent = "name, brand";
    List<List<dynamic>> rows = [];
    rows.add(["Roll Number", "Name", "Pic Name", "Father Name", "Mobile", "Address", "Class", "Section",
    "Department", "DOB", "BloodGroup", "Email", "Mother Name", "Other 1", "Other 2", "Other 3", "Other 4"
    ]);
    docs.asMap().forEach((index, record){
      fileContent = fileContent +
          "\n" +record.Name.toString()
          + "," + record.Pic_Name.toString();
      print("\n" +record.Name.toString()
          + "," + record.Pic_Name.toString());
      rows.add([record.Roll_number.toString(), record.Name, record.Pic_Name.toString(),
      record.Father_Name, record.Mobile, record.Address , record.Class, record.Section, record.Department,
        record.newdob, record.BloodGroup, record.Email, record.Mother_Name, record.Other1,
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
      String filePath = "$dir/id_${id}_${classu}_list.csv";
      File file = File(filePath);
      await file.writeAsString(csv);
      print("File saved to: $filePath");
    } else {
      print("Permission denied for storage.");
    }
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
  String c;
  String s;
  String school;
  StudentModel user;

  ChatUser({super.key, required this.user, required this.school, required this.s ,required this.c});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          user.Roll_number.toString() +
          "   " +
          user.Class +
          user.Section ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}
