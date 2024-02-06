import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:csv/csv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Csv extends StatefulWidget {
  String school ;
  String session ;
  String classi ;
  Csv({super.key, required this.school, required this.session, required this.classi});

  @override
  State<Csv> createState() => _CsvState();
}

class _CsvState extends State<Csv> {
  List<List<dynamic>> _data = [];

  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text("Upload CSV"),
      ),
      body : SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("Click to Import"),
              onPressed:(){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Alert !"),
                      content: Text("The CSV you would import must be in this format :  NAME,FATHER NAME,CLASS,D.O.B.,ADDRESS,MOBILE,PHOTO NO."),
                      actions: [
                        TextButton(
                          onPressed: () async {
                             _pickFile();
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("OK"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );

              },
            ),
            ListView.builder(
              itemCount: _data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Card(
                  margin: const EdgeInsets.all(3),
                  color: index == 0 ? Colors.yellow : Colors.white,
                  child: ListTile(
                    leading: Text(_data[index][0].toString(),textAlign: TextAlign.center,
                      style: TextStyle(fontSize: index == 0 ? 18 : 15, fontWeight:index == 0 ? FontWeight.bold :FontWeight.normal,color: index == 0 ? Colors.red : Colors.black),),
                    title: Text(_data[index][3],textAlign: TextAlign.center,
                      style: TextStyle(fontSize: index == 0 ? 18 : 15, fontWeight: index == 0 ? FontWeight.bold :FontWeight.normal,color: index == 0 ? Colors.red : Colors.black),),
                    trailing: Text(_data[index][4].toString(),textAlign: TextAlign.center,
                      style: TextStyle(fontSize: index == 0 ? 18 : 15, fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,color: index == 0 ? Colors.red : Colors.black),),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        SocialLoginButton(
          backgroundColor: Color(0xff50008e),
          height: 40,
          text: 'UPLOAD DATA NOW',
          borderRadius: 20,
          fontSize: 21,
          buttonType: SocialLoginButtonType.generalLogin,
          onPressed: () async {
            int i = 100 ;
            if (_data.isNotEmpty) {
              for (var element in _data.skip(1)) {
                String picn= DateTime.now().microsecondsSinceEpoch.toString();
                var myData = {
                  "Registration_number": i.toString(),
                  "Admission_number" : i.toString(),

                  "Name": element[0].toString(),
                  "Father_Name": element[1].toString(),
                  "Class": element[2].toString(),
                  "dob": element[3].toString(),
            "Address": element[4].toString(),
                  "Mobile": element[5].toString(),
                  "Pic_Name": picn,
                };
                // Use the first name from the CSV as the document ID
                String docId = element[0].toString();
                // Reference to the "U" collection and the document with the first name as the ID
                var documentReference = FirebaseFirestore.instance.collection('School')
                    .doc(widget.school)
                    .collection('Session')
                    .doc(widget.session)
                    .collection('Class')
                    .doc(widget.classi)
                    .collection("Student").doc(i.toString());
                // Set the data in Firestore
                await documentReference.set(myData);
                i ++ ;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Data uploaded to Firestore for $docId, Uploading Next..."),
                ));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("No data to upload."),
              ));
            }
          }
        ),
      ],
    );

  }

  void _pickFile() async {

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);

    setState(() {
      _data = fields;
    });
  }
}
