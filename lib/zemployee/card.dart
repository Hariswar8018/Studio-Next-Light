import 'package:flutter/material.dart';
import 'package:student_managment_app/model/employee_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/after_login/my_fee_report_report.dart';
import 'package:student_managment_app/attendance/notice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/admin/Student_Data_Update.dart';
import 'package:student_managment_app/admin/update_int.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/calender.dart';
import 'package:student_managment_app/attendance/Qr_code.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/picture.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../Parents_Portal/as.dart';

class EmpC extends StatelessWidget {
  EmployeeModel user; String cssession;
  EmpC({super.key,required this.user,required this.cssession});
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Student Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        final Uint8List data = await croppedFile.readAsBytes();
        return data;
      }
    }
    print('No Image Selected');
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(user.Name),
    backgroundColor: Colors.orange,
        ),
      body:SingleChildScrollView(
        child: Column(
          children:[
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: InkWell(
                      onLongPress: () {

                      },
                      onTap: () async {
                        try {
                          Uint8List? _file = await pickImage(
                              ImageSource.gallery);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Uploading..."),
                            ),
                          );
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('students', _file!, true);
                          await FirebaseFirestore.instance
                            .collection('School').doc(cssession).collection("Employee").doc(user.Id_number)
                                .update({
                              "Pic": photoUrl,
                            });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Profile Pic updated"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e}"),
                            ),
                          );
                        }
                      },
                      onDoubleTap: () async {
                        try {
                          Uint8List? _file = await pickImage(
                              ImageSource.camera);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Uploading..."),
                            ),
                          );
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('students', _file!, true);
                          await FirebaseFirestore.instance
                              .collection('School').doc(cssession).collection("Employee").doc(user.Id_number)
                              .update({
                            "Pic": photoUrl,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Profile Pic updated"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e}"),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.Pic),
                        radius: 120,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Row(
                      children: [
                        Spacer(),
                        Column(
                            children: [
                              SizedBox(height: 20),
                              InkWell(
                                onTap: ()  async {
                                  final Uri _url = Uri.parse(
                                      "tel:" + user.Phone);
                                  if (!await launchUrl (_url)
                                  ) {
                                    throw Exception('Could not launch $_url');
                                  }
                                },
                                child: CircleAvatar(radius: 24,
                                  child: Icon(Icons.call, color: Colors.white,
                                      size: 20),
                                  backgroundColor: Colors.greenAccent,),

                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () async  {
                                  final Uri _url = Uri.parse(
                                      "mailto:" + user.Email);
                                  if (!await launchUrl (_url)
                                  ) {
                                    throw Exception('Could not launch $_url');
                                  }
                                }, child:
                              CircleAvatar(radius: 24,
                                child: Icon(
                                    Icons.mail, color: Colors.white, size: 20),
                                backgroundColor: Colors.red,),
                              ), SizedBox(height: 5),
                              InkWell(
                                onTap: () async {
                                  final Uri _url = Uri.parse(
                                      "https://www.google.com/maps/search/?api=1&query=${user.Address}");
                                  if (!await launchUrl (_url)) {
                                    throw Exception('Could not launch $_url');
                                  }
                                }, child:
                              CircleAvatar(radius: 24,
                                child: Icon(
                                    Icons.map_sharp, color: Colors.white,
                                    size: 20),
                                backgroundColor: Colors.purple,),
                              ),
                            ]
                        ),
                        SizedBox(width: 8),
                      ]
                  ),
                ),
              ],
            ),
            Text(user.Name,style:TextStyle(fontWeight: FontWeight.w800,fontSize: 26)),
            Text(user.Profession,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 15)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Single Tap to open Gallery and Double Tap to open Camera", textAlign : TextAlign.center, style : TextStyle(fontSize : 9, color : Colors.blue))),
            ),
            SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'Name', to_change: 'Name',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Name", user.Name, false, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'Profession', to_change: 'Profession',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Profession", user.Profession, true, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'Email', to_change: 'Email',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Email", user.Email, false, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'Address', to_change: 'Address',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Address", user.Address, true, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'Phone', to_change: 'Phone',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Phone", user.Phone, false, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'BloodG', to_change: 'BloodG',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Blood Group", user.BloodG, true, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'Father_Name', to_change: 'Father_Name',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s(
                    "Father Name", user.Father_Name, false,
                    true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: School_Data_Update(
                            pic: user.Pic, sid: cssession, cid: user.Id_number,
                            change_change: 'DOB', to_change: 'DOB',

                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s(
                    "Dob", user.DOB, false,
                    true)),
          ]
        ),
      )
    );
  }
  Widget s(String s, String n, bool b, bool j) {
    return ListTile(
      leading: j
          ? Icon(Icons.edit_rounded, color: Colors.green, size: 20)
          : Icon(Icons.circle, color: Colors.black, size: 20),
      title: Text(s + " :"),
      trailing:
      Text(n, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      splashColor: Colors.orange.shade300,
      tileColor: b ? Colors.grey.shade50 : Colors.white,
    );
  }
}


class School_Data_Update extends StatelessWidget {

  String cid, sid;
  String to_change;
  String change_change ;
  String pic ;

  School_Data_Update({ required this.pic, required this.sid,
    required this.cid, required this.change_change, required this.to_change
  });
  final TextEditingController Admission = TextEditingController();

  final TextEditingController Registration = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color : Colors.white,
          ),
          title : Text("Update $change_change", style : TextStyle(color : Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
        body : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(pic),
                  radius: 40,
                ),
              ),
            ),
            SizedBox(height : 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text( textAlign: TextAlign.center, "Type the New $change_change ")),
            ),
            d( Admission, "His New $change_change" , "AN000123", false,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor:  Color(0xff50008e),
                height: 40,
                text: 'Update $change_change',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(sid).collection("Employee");
                  await collection.doc(cid).update({
                    "$to_change" : Admission.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Success ! Updating ! It may take a While'),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
    );
  }
  Widget d( TextEditingController c , String label, String hint, bool number,  ){
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
      ),
    );
  }
}
