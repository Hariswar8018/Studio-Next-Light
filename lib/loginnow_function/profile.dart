

import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/upload/storage.dart';

class Profile extends StatelessWidget {
  UserModel user;
  Profile({super.key,required this.user});
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
              toolbarTitle: 'Crop Profile Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false
          ),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            InkWell(
              onTap: ()async{
                try {
                  Uint8List? _file = await pickImage(
                      ImageSource.gallery);
                  Send.message(context, "Uploading...", true);
                  String photoUrl = await StorageMethods()
                      .uploadImageToStorage('${user.position}', _file!, true);
                  await FirebaseFirestore.instance
                    .collection('Users')
                        .doc(user.uid)
                        .update({
                      "pic": photoUrl,
                    });
                  Send.message(context, "Profile Pic updated", true);
                }catch(e){
                  Send.message(context, "$e", false);
                }
              },
              child: Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.pic),
                  radius: 65,
                ),
              ),
            ),
            SizedBox(height: 25,),
           c("My Profile"),
            s("Email", user.email, false,false),
            s("Name", user.name, true, false),
            s("Position for you", user.position, true, false),
            SizedBox(height: 20),
           c("School Info"),
            s("School ID", user.schoolid, true, false),
            s("School Name", user.school, true, false),
            s("Class ID", user.classid, false, false),
            s("Section", user.email, true, false),
            s("Department", user.last, false, false),
          ],
        ),
      ),
    );
  }
  Widget c(String str)=> Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8,top: 4,bottom: 4),
          child: Text("$str",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20)),
        ),
      ),
    ),
  );
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
