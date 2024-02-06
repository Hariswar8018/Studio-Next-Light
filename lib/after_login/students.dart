import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/admin/Student_Data_Update.dart';
import 'package:studio_next_light/admin/student_profile_view.dart';
import 'package:studio_next_light/after_login/student_shift.dart';
import 'package:studio_next_light/model/birthday_student.dart';
import 'package:studio_next_light/model/student_model.dart';
import 'package:studio_next_light/model/orders_model.dart';
import 'package:studio_next_light/after_login/stu_edit.dart';
import 'dart:typed_data';
import 'package:studio_next_light/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class Students extends StatelessWidget {
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;
  String id;
  String session_id;
  String class_id;

  String shop;

  String School;
  String Class;
  String Session;

  Students({super.key,
    required this.id,
    required this.session_id,
    required this.class_id,
    required this.shop,
    required this.School,
    required this.Session,
    required this.Class,
    required this.EmailB,
    required this.RegisB,
    required this.Other4B,
    required this.Other3B,
    required this.Other2B,
    required this.Other1B,
    required this.MotherB,
    required this.DepB,
    required this.BloodB});

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Students Data'),
        actions: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.red, // Set the border color to green
                  width: 2.0, // Set the border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(shop),
              )),
          SizedBox(width: 5),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Add(
                      id: id,
                      session_id: session_id,
                      classid: class_id,
                      EmailB: EmailB,
                      RegisB: RegisB,
                      Other4B: Other4B,
                      Other3B: Other3B,
                      Other2B: Other2B,
                      Other1B: Other1B,
                      MotherB: MotherB,
                      DepB: DepB,
                      BloodB: BloodB,
                    ),
              ),
            );
          },
          child: Icon(Icons.add)),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(id).collection('Session').doc(session_id).collection("Class").doc(class_id).collection("Student").snapshots(),
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
                    id: id,
                    session_id: session_id,
                    class_id: class_id,
                    length : list.length ,
                    b: shop == "Still Uploading",
                    EmailB: EmailB,
                    RegisB: RegisB,
                    Other4B: Other4B,
                    Other3B: Other3B,
                    Other2B: Other2B,
                    Other1B: Other1B,
                    MotherB: MotherB,
                    DepB: DepB,
                    BloodB: BloodB,
                  );
                },
              );
          }
        },
      ),
      persistentFooterButtons: [
        shop == "Still Uploading"
            ? Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: shop == "Still Uploading" ? 'PLACE ORDER NOW  🛒' : '',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () {
              if (shop == "Still Uploading") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Alert'),
                      content: Text(
                          'Continue Order ! Once Order is Submitted, No Edit would be Allowed ! Please double check all Data before Continue to Order ID Card'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Close the dialog
                            DateTime now = DateTime.now();
                            // Format the DateTime
                            String formattedDate =
                            DateFormat('HH:mm - dd-MMM-yyyy')
                                .format(now);
                            OrderModel s = OrderModel(
                                School_id: id,
                                session_id: session_id,
                                class_id: class_id,
                                class_name: Class,
                                session_name: Session,
                                status: "ID Ordered on ",
                                School_Name: School,
                                num : list.length ,
                                Time: formattedDate);
                            CollectionReference collection =
                            FirebaseFirestore.instance
                                .collection('Admin')
                                .doc("Order")
                                .collection('Orders');
                            await collection
                                .doc(formattedDate)
                                .set(s.toJson());

                            CollectionReference collection1 =
                            FirebaseFirestore.instance
                                .collection('School')
                                .doc(id)
                                .collection('Session')
                                .doc(session_id)
                                .collection('Class');
                            await collection1.doc(class_id).update({
                              "status": "Order Processing",
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Success ! We notified the Admin to Start processing your ID Cards"),
                              ),
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Order Now only'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed ! This Class\'s Order is already being Proceed'),
                  ),
                );
              }
            },
          ),
        )
            : SizedBox(height: 5),
      ],
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
  StudentModel user;
  int length ;
  String id;
  String session_id;

  String class_id;
  bool b;

  ChatUser({super.key,
    required this.user,
    required this.length ,
    required this.id,
    required this.session_id,
    required this.class_id,
    required this.b,
    required this.EmailB,
    required this.RegisB,
    required this.Other4B,
    required this.Other3B,
    required this.Other2B,
    required this.Other1B,
    required this.MotherB,
    required this.DepB,
    required this.BloodB});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {

  void initState(){
    v();
  }

  void v() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Session').doc(widget.session_id).collection('Class');
        await collection.doc(widget.class_id).update({
      "total" : widget.length,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.pic),
      ),
      title: Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          widget.user.Roll_number.toString() +
          "   " +
          widget.user.Class +
          widget.user.Section),
      onLongPress: (){
        Navigator.push(
            context,
            PageTransition(child: Class1(
              uder: widget.user,
              class_id: widget.class_id,
              session_id: widget.session_id,
              id: widget.id,
            ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 800)));
      },
      onTap: () {
        if (widget.b) {
          if (widget.user.state == "Editing") {
            Navigator.push(
                context,
                PageTransition(child: StudentProfile(
                      user: widget.user,
                      class_id: widget.class_id,
                      session_id: widget.session_id,
                      school_id: widget.id,
                      parent: false,
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 800)));
          } else {
            Navigator.push(
                context,
                PageTransition(
                    child: StudentProfileN(
                      user: widget.user,
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 800)));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Profile Confirmed and closed for Editing !"),
              ),
            );
          }
        } else {
          Navigator.push(
              context,
              PageTransition(
                  child: StudentProfileN(
                    user: widget.user,
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 800)));
        }
      },
      trailing: widget.user.state == "Editing"
          ? Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green, // Set the border color to green
              width: 2.0, // Set the border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Editing"),
          ))
          : Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red, // Set the border color to green
              width: 2.0, // Set the border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.user.state),
          )),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
}

class Add extends StatefulWidget {
  String id;
  String session_id;
  String classid;
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;

  Add({super.key,
    required this.id,
    required this.session_id,
    required this.classid,
    required this.EmailB,
    required this.RegisB,
    required this.Other4B,
    required this.Other3B,
    required this.Other2B,
    required this.Other1B,
    required this.MotherB,
    required this.DepB,
    required this.BloodB});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController Name = TextEditingController();
  TextEditingController dob = TextEditingController();
  final TextEditingController AdmissionNumber = TextEditingController();
  final TextEditingController id_number = TextEditingController();
  final TextEditingController Registration_number = TextEditingController();
  final TextEditingController blood = TextEditingController();
  final TextEditingController Roll = TextEditingController();
  final TextEditingController Father = TextEditingController();
  final TextEditingController Mother = TextEditingController();
  final TextEditingController Mobile = TextEditingController();
  final TextEditingController Email = TextEditingController();
  final TextEditingController Address = TextEditingController();
  final TextEditingController Class = TextEditingController();
  final TextEditingController Section = TextEditingController();
  final TextEditingController Department = TextEditingController();
  final TextEditingController Session = TextEditingController();
  final TextEditingController Batch = TextEditingController();
  final TextEditingController Con = TextEditingController();
  final TextEditingController Driver = TextEditingController();
  final TextEditingController Other1 = TextEditingController();
  final TextEditingController Other2 = TextEditingController();
  final TextEditingController Other3 = TextEditingController();
  final TextEditingController Other4 = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool? checkboxIconFormFieldValue = false;

  String s = " ";

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
          WebUiSettings(
            context: context,
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

  Uint8List? _file2;

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];


  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
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
                setState(() {
                  _singleDatePickerValueWithDefaultValue  = values;
                  DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
                  String dateTimeString = date.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime = DateTime.parse(dateTimeString);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  dob = TextEditingController(text: formattedDate);
                });
              }
            },
            child: const Text('Choose Date of Birth'),
          ),
        ],
      ),
    );
  }

  String pic = " ";
  bool isUploading = false;
  int i = 1 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add a Student"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child:
                Icon(Icons.person_pin, size: 30, color: Colors.pinkAccent),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Student Basic Information",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              isUploading
                  ? LinearProgressIndicator()
                  : InkWell(
                onTap: () async {
                  setState(() {
                    isUploading = true; // Set to true before starting the upload
                  });

                  Uint8List? _file = await pickImage(ImageSource.gallery);
                  String photoUrl = await StorageMethods()
                      .uploadImageToStorage('students', _file!, true);
                  setState(() {
                    pic = photoUrl;
                    isUploading = false; // Set back to false after upload is complete
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Profile Pic uploaded"),
                    ),
                  );
                },
                onDoubleTap: () async {
                  setState(() {
                    isUploading = true; // Set to true before starting the upload
                  });

                  Uint8List? _file = await pickImage(ImageSource.camera);
                  String photoUrl = await StorageMethods()
                      .uploadImageToStorage('students', _file!, true);
                  setState(() {
                    pic = photoUrl;
                    isUploading = false; // Set back to false after upload is complete
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Profile Pic uploaded"),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  width: 80,
                  child: pic == " " ? Image.network(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                    fit: BoxFit.cover,
                  ) : Image.network(
                    pic,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Single Tap to open Gallery and Double Tap to open Camera", textAlign : TextAlign.center, style : TextStyle(fontSize : 9, color : Colors.blue))),
              ),
              SizedBox(height: 6),
              d(
                Name,
                "Student Name",
                "AYUSMAN SAMASI",
                false,
              ),
          widget.RegisB ? d(
                Registration_number,
                "Registration Number",
                "TN09863256",
                false,
              ) : SizedBox(),
              _buildCalendarDialogButton(),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: dob, readOnly: true ,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              d(
                AdmissionNumber,
                "Admission Number",
                "AN000123",
                false,
              ),
              d(
                id_number,
                "Id Number",
                "AN000123",
                false,
              ),
              max(Roll, "Roll Number", "21", true, 3),
              widget.BloodB
                  ? max(blood, "Blood Group", "A+", false, 3)
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.book, size: 30, color: Colors.lightGreen),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Other Basic Information",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              d(
                Father,
                "Father Name",
                "RATAN SAMASI",
                false,
              ),
              widget.MotherB
                  ? d(
                Mother,
                "Mother Name",
                "RATAN SAMASI",
                false,
              )
                  : SizedBox(width: 0.1),
              max(Mobile, "Mobile Number", "7978097489", true, 10),
              widget.EmailB
                  ? d(
                Email,
                "Email",
                "hariswarsamasi@gmail.com",
                false,
              )
                  : SizedBox(width: 0.1),
              d(
                Address,
                "Address",
                "A-20, Jhirpani, Rourkela, Odisha",
                false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.school, size: 30, color: Colors.blueAccent),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Academic Information",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              d(
                Class,
                "Class",
                "Class X",
                false,
              ),
              max(Section, "Section", "A", false, 1),
              widget.DepB
                  ? d(
                Department,
                "Department / Major",
                "Science",
                false,
              )
                  : SizedBox(width: 0.1),
              d(
                Session,
                "Session",
                "2023",
                false,
              ),
              d(
                Batch,
                "Batch",
                "1",
                false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.dashboard, size: 30, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Other Information",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 10,
                  child: widget.Other1B
                      ? d(
                    Other1,
                    "Other1",
                    " ",
                    false,
                  )
                      : SizedBox(width: 0.1),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 10,
                  child: widget.Other2B
                      ? d(
                    Other2,
                    "Other2",
                    " ",
                    false,
                  )
                      : SizedBox(width: 0.1),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 10,
                  child: widget.Other3B
                      ? d(
                    Other3,
                    "Other3",
                    " ",
                    false,
                  )
                      : SizedBox(width: 0.1),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 10,
                  child: widget.Other4B
                      ? d(
                    Other4,
                    "Other4",
                    " ",
                    false,
                  )
                      : SizedBox(width: 0.1),
                ),
              ]),
              CheckboxListTileFormField(
                title: Text(
                    'T&C- I consent to processing the information to be provided by me as a photo id card.'),
                onSaved: (bool? value) {
                  print(value);
                },
                validator: (bool? value) {
                  if (value!) {
                    return null;
                  } else {
                    return 'Please accept T&C';
                  }
                },
                onChanged: (value) {
                  if (value) {
                    print("ListTile Checked :)");
                    setState(() {
                      checkboxIconFormFieldValue = value;
                    });
                  } else {
                    print("ListTile Not Checked :(");
                    setState(() {
                      checkboxIconFormFieldValue = value;
                    });
                  }
                },
                autovalidateMode: AutovalidateMode.always,
                contentPadding: EdgeInsets.all(1),
              ),

            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Add Student Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              bool jgfj = checkboxIconFormFieldValue ?? false;
              if (jgfj) {
                print("1");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Uploadind Data Please Wait.....'),
                  ),
                );
                try {
                  await dhhh();
                  Navigator.pop(context);
                } catch (e) {
                  print('${e}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e}'),
                    ),
                  );
                };
              } else {
                print("2");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please accept the T&C first !'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> dhhh() async {
    CollectionReference collection = FirebaseFirestore.instance.collection(
        'School').doc(widget.id).collection('Session').doc(widget.session_id)
        .collection('Class').doc(widget.classid)
        .collection("Student");

    String customDocumentId = DateTime.now().millisecondsSinceEpoch.toString() ; // Replace with your own custom ID

    String Mobile1 = Mobile.text ;
    String Roll1 = Roll.text ;

    int rollNumber = int.tryParse(Roll1) ?? 3 ;
    String shhhh = AdmissionNumber.text.isEmpty ? customDocumentId : AdmissionNumber.text ;
    String pichj = DateTime.now().microsecondsSinceEpoch.toString() ;
    String jh = "DSC_00" + pichj ;
    DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
    String dateofbirth = date.toString() ;

    setState(() {
      i ++ ;
    });

    int MobileNum = int.tryParse(Mobile1) ?? 7978097489;
    StudentModel student1 = StudentModel(
        Name: Name.text ,
        id: id_number.text ,
        Address: Address.text,
        Email: Email.text ?? 'NA',
        Admission_number: shhhh,
        Batch: Batch.text,
        BloodGroup: blood.text ?? 'NA',
        Class: Class.text,
        Con: " ",
        Department: Department.text ?? 'NA',
        Driver: " ",
        Father_Name: Father.text,
        Mobile: MobileNum.toString(),
        Mother_Name: Mother.text ?? 'NA',
        pic: pic,
        Registration_number: Registration_number.text ?? "NA",
        Roll_number: rollNumber,
        Section: Section.text,
        Session: Session.text,
        Other1: Other1.text ?? 'NA',
        Other2: Other2.text ?? 'NA',
        Other3: Other3.text ?? 'NA',
        Other4: Other4.text ?? 'NA',
        state: "Editing",
        dob: dob.text,
        Pic_Name: jh, newdob: dateofbirth , School_id_one: pichj );

    await collection.doc(shhhh).set(student1.toJson());

    StudentModel2 hghh7 = StudentModel2(Name: Name.text, id: pichj,
        Mobile: MobileNum.toString(), pic: pic, newdob: dateofbirth, dne : false ,
        School_id_one: pichj, par: false);

    await FirebaseFirestore.instance.collection("School").doc(widget.id)
        .collection("Students").doc(pichj).set(hghh7.toJson());

    CollectionReference collection22 = FirebaseFirestore.instance.collection(
        'Admin'); //Update Student in Admin Panel
    await collection22.doc("Order").update({
      'Students': FieldValue.increment(1),
    });

    await FirebaseFirestore.instance.collection("School").doc(widget.id).update({
      'Total': FieldValue.increment(1),
      'Pending': FieldValue.increment(1),
    }); //Update School Panel

    await FirebaseFirestore.instance.collection("School").doc(widget.id).collection('Session')
        .doc(widget.session_id)
        .collection('Class').doc(widget.classid).update({
      'total': FieldValue.increment(1),
    }); //Update Class Panel
  }

  Widget d(TextEditingController c, String label, String hint, bool number,) {
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

  Widget max(TextEditingController c, String label, String hint, bool number,
      int max) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        maxLength: max,
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
