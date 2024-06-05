import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/admin/Student_Data_Update.dart';
import 'package:studio_next_light/admin/student_profile_view.dart';
import 'package:studio_next_light/after_login/calender.dart';
import 'package:studio_next_light/attendance/Qr_code.dart';
import 'package:studio_next_light/model/birthday_student.dart';
import 'package:studio_next_light/model/student_model.dart';
import 'package:studio_next_light/model/orders_model.dart';
import 'package:studio_next_light/picture.dart';
import 'dart:typed_data';
import 'package:studio_next_light/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../Parents_Portal/as.dart';


class StudentProfile extends StatefulWidget {
  bool parent;
  String str ;
  StudentModel user;
  String class_id;
  String session_id ;
  String school_id;

  StudentProfile({super.key,
    required this.user,required this.str ,
    required this.class_id,
    required this.session_id,
    required this.school_id,
    required this.parent
  });

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
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

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];


  String _getValueText(CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.Name),
        backgroundColor: Colors.orange,
        actions: [
          widget.parent
              ? SizedBox()
              : Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () async {
                  CollectionReference collection = FirebaseFirestore
                      .instance
                      .collection('School')
                      .doc(widget.school_id)
                      .collection('Session')
                      .doc(widget.session_id)
                      .collection('Class')
                      .doc(widget.class_id)
                      .collection("Student");
                  await collection.doc(widget.user.Registration_number)
                      .delete();
                  CollectionReference collection22 =
                  FirebaseFirestore.instance.collection('Admin');
                  await collection22.doc("Order").update({
                    'Students': FieldValue.increment(-1),
                  });
                },
                icon: Icon(Icons.delete, color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: InkWell(
                      onLongPress: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Pic(str: widget.user.pic,
                                    name: widget.user.Name),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
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
                            ..collection('School')
                                .doc(widget.school_id).collection('Session')
                                .doc(widget.session_id)
                                .collection('Class')
                                .doc(widget.class_id)
                                .collection("Student")
                                .doc(widget.user.Registration_number)
                                .update({
                              "pic": photoUrl,
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
                            ..collection('School')
                                .doc(widget.school_id).collection('Session')
                                .doc(widget.session_id)
                                .collection('Class')
                                .doc(widget.class_id)
                                .collection("Student")
                                .doc(widget.user.Registration_number)
                                .update({
                              "pic": photoUrl,
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
                        backgroundImage: NetworkImage(widget.user.pic),
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
                                      "tel:" + widget.user.Mobile);
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
                                      "mailto:" + widget.user.Email);
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
                                      "https://www.google.com/maps/search/?api=1&query=${widget.user.Address}");
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Single Tap to open Gallery and Double Tap to open Camera", textAlign : TextAlign.center, style : TextStyle(fontSize : 9, color : Colors.blue))),
            ),
            Center(child: Text(widget.user.Pic_Name)),
            SizedBox(height: 10),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 10),
                    TextButton.icon(onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: MyCalenderPage(idi: widget.user
                                  .Registration_number, df: widget.school_id,
                                classi: widget.class_id, sessioni: widget
                                    .session_id, user: widget.user,
                              ),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400)));
                    },
                      icon: Icon(Icons.how_to_reg, size: 25),
                      label: Text("Attendance"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),
                    SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () => Global.As(widget.user, false, widget.str),
                      icon: Icon(Icons.receipt, size: 25),
                      label: Text("Reminder"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.lightGreen),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),
                    SizedBox(width: 10),
                  ]
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 10),
                    TextButton.icon(onPressed: () {},
                      icon: Icon(Icons.receipt, size: 25),
                      label: Text("Fee Report"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),
                    SizedBox(width: 10),
                    TextButton.icon(onPressed: () {

                    },
                      icon: Icon(Icons.credit_score, size: 25),
                      label: Text("Notices "),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurple),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),

                    SizedBox(width: 10),
                  ]
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Name',
                            to_change: 'Name',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Name", widget.user.Name, false, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Father Name',
                            to_change: 'Father_Name',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Father Name", widget.user.Father_Name, true, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Mother Name',
                            to_change: 'Mother_Name',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Mother Name", widget.user.Mother_Name, false, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Blood Group',
                            to_change: 'BloodGroup',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Blood Group", widget.user.BloodGroup, true, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Fees',
                            to_change: 'Mf',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s(
                    "Total Fees", "₹ " + widget.user.Myfee.toString(), false,
                    true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Mobile',
                            to_change: 'Mobile',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                }, child: s("Mobile", widget.user.Mobile.toString(), false, true)),
            _buildCalendarDialogButton(),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Email',
                            to_change: 'Email',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Email", widget.user.Email, true, true)),
            SizedBox(height: 20),
            s("Registration Number", widget.user.Registration_number, false,
                false),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Admission Number',
                            to_change: 'Admission_number',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Admission Number", widget.user.Admission_number, true,
                    true)),
            s("ID", widget.user.id, false, false),
            s("Session", widget.user.Session, true, false),
            s("Roll Number", widget.user.Roll_number.toString(), false, false),
            SizedBox(height: 20),
            s("Batch", widget.user.Batch, true, false),
            s("Class", widget.user.Class, false, false),
            s("Section", widget.user.Section, true, false),
            s("Department", widget.user.Department, false, false),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: widget.class_id,
                            session_id: widget.session_id,
                            pic: widget.user.pic,
                            school_id: widget.school_id,
                            student_id: widget.user.Registration_number,
                            change_change: 'Address',
                            to_change: 'Address',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Address", widget.user.Address, true, true)),
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Confirm Student Profile ',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              if (widget.parent) {
                CollectionReference collection = FirebaseFirestore.instance
                    .collection('School')
                    .doc(widget.school_id)
                    .collection('Session')
                    .doc(widget.session_id)
                    .collection('Class')
                    .doc(widget.class_id)
                    .collection("Student");
                await collection.doc(widget.user.Registration_number).update({
                  "State": "Confirm by Parent",
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Success ! Waiting for Admin to generate SchoolId card"),
                  ),
                );
                Navigator.pop(context);
              } else {
                CollectionReference collection = FirebaseFirestore.instance
                    .collection('School')
                    .doc(widget.school_id)
                    .collection('Session')
                    .doc(widget.session_id)
                    .collection('Class')
                    .doc(widget.class_id)
                    .collection("Student");
                await collection.doc(widget.user.Registration_number).update({
                  "State": "Confirm by Inst.",
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('Success ! Waiting for Parents to confirm Now'),
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
  _buildCalendarDialogButton() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return ListTile(
      onTap : () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: _singleDatePickerValueWithDefaultValue ,
          dialogBackgroundColor: Colors.white,
        );
        if (values != null) {
          // ignore: avoid_print
          print(_getValueText(
            config.calendarType,
            values,
          ));
          // Format the DateTime in the desired format (DD/MM/YYYY)
          _singleDatePickerValueWithDefaultValue  = values;
          DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
          String dateTimeString = date.toString(); // Replace with your DateTime string

          // Convert DateTime string to DateTime
          DateTime dateTime = DateTime.parse(dateTimeString);
          await FirebaseFirestore.instance
            ..collection('School')
                .doc(widget.school_id).collection('Session')
                .doc(widget.session_id)
                .collection('Class')
                .doc(widget.class_id)
                .collection("Student")
                .doc(widget.user.Registration_number)
                .update({
              "newdob": dateTimeString,
            });
          if( widget.user.School_id_one == null ||  widget.user.School_id_one == "" ){
            String pichj = DateTime.now().microsecondsSinceEpoch.toString() ;
            await FirebaseFirestore.instance
              ..collection('School')
                  .doc(widget.school_id).collection('Session')
                  .doc(widget.session_id)
                  .collection('Class')
                  .doc(widget.class_id)
                  .collection("Student")
                  .doc(widget.user.Registration_number)
                  .update({
                "SCHOOLID" : pichj ,
              });
            StudentModel2 hghh7 = StudentModel2(Name: widget.user.Name, id: pichj,
                Mobile: widget.user.Mobile, pic: widget.user.pic, newdob: dateTimeString, dne : false ,
                School_id_one: pichj, par : false );

            await FirebaseFirestore.instance.collection("School").doc(widget.school_id)
                .collection("Students").doc(pichj).set(hghh7.toJson());
          }else{
            StudentModel2 hghh7 = StudentModel2(Name: widget.user.Name, id: widget.user.School_id_one,
                Mobile: widget.user.Mobile, pic: widget.user.pic, newdob: dateTimeString, dne : false ,
                School_id_one: widget.user.School_id_one, par : false );
              await FirebaseFirestore.instance.collection('School')
                  .doc(widget.school_id).collection('Students')
                  .doc(widget.user.School_id_one).update(hghh7.toJson()); }
        }
      },
      title: const Text('Date of Birth : '),
      leading : Icon(Icons.calendar_month, color: Colors.green, size: 20),
      trailing:
      Text( hjk(widget.user.newdob) , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      splashColor: Colors.orange.shade300,
      tileColor:  Colors.white,
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

  String hjk( String g ) {
    String dateTimeString = g; // Replace with your DateTime string
    print(g);
    // Convert DateTime string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate ;
  }
}
