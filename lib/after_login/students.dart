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
import 'package:studio_next_light/model/student_model.dart';
import 'package:studio_next_light/model/orders_model.dart';
import 'dart:typed_data';
import 'package:studio_next_light/upload/storage.dart';
import 'package:intl/intl.dart';

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

  Students(
      {super.key,
      required this.id,
      required this.session_id,
      required this.class_id,
      required this.shop,
      required this.School,
      required this.Session,
      required this.Class,
        required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
        required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB});

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
                  color : Colors.white,
                  border: Border.all(
                    color: Colors.red, // Set the border color to green
                    width: 2.0, // Set the border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text( shop ),
                )),
            SizedBox(width : 5),
          ],
        ),
        floatingActionButton:  FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Add(
                        id: id,
                        session_id: session_id,
                        classid: class_id,
                        EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
                        Other3B: Other3B, Other2B: Other2B, Other1B: Other1B,
                        MotherB: MotherB, DepB: DepB, BloodB: BloodB,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.add)),
        body: StreamBuilder(
          stream: Fire.collection('School')
              .doc(id)
              .collection('Session')
              .doc(session_id)
              .collection("Class")
              .doc(class_id)
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
                list = data
                        ?.map((e) => StudentModel.fromJson(e.data()))
                        .toList() ??
                    [];
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
                      b: shop == "Still Uploading",
                      EmailB: EmailB, RegisB: RegisB, Other4B: Other4B,
                      Other3B: Other3B, Other2B: Other2B, Other1B: Other1B,
                      MotherB: MotherB, DepB: DepB, BloodB: BloodB,
                    );
                  },
                );
            }
          },
        ),
        persistentFooterButtons: [
          shop == "Still Uploading" ? Padding(
            padding: const EdgeInsets.all(1.0),
            child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: shop == "Still Uploading"
                  ? 'PLACE ORDER NOW  🛒' :
                  '' ,
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
                                  DateFormat('HH:mm - dd-MMM-yyyy').format(now);
                              OrderModel s = OrderModel(
                                  School_id: id,
                                  session_id: session_id,
                                  class_id: class_id,
                                  class_name: Class,
                                  session_name: Session,
                                  status: "ID Ordered on ",
                                  School_Name: School,
                                  Time: formattedDate);
                              CollectionReference collection = FirebaseFirestore.instance.collection('Admin').doc("Order").collection('Orders');
                              await collection.doc(formattedDate).set(s.toJson());

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
          ) :
          SizedBox(height : 5),
        ],
    );
  }
}

class ChatUser extends StatelessWidget {
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
  String id;
  String session_id;

  String class_id;
  bool b;

  ChatUser(
      {super.key,
      required this.user,
      required this.id,
      required this.session_id,
      required this.class_id,
      required this.b,  required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
        required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB});

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
          user.Section),
      onTap: () {
        if (b) {
          if (user.state == "Editing") {
            Navigator.push(
                context,
                PageTransition(
                    child: StudentProfile(
                      user: user,
                      class_id: class_id,
                      session_id: session_id,
                      school_id: id,
                      parent: false,
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 800)));
          } else {
            Navigator.push(
                context,
                PageTransition(
                    child: StudentProfileN(
                      user: user,
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 800)));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Profile Confirmed and closed for Editing !"),
              ),
            );
          }
        } else {
          Navigator.push(
              context,
              PageTransition(
                  child: StudentProfileN(
                    user: user,
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 800)));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed ! This Class\'s Order is already Submitted for ID CARD. Thus can\'t be Edited'),
            ),
          );
        }
      },
      trailing: user.state == "Editing"
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
                child: Text(user.state),
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
  Add(
      {super.key,
      required this.id,
      required this.session_id,
      required this.classid,
        required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
        required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.BloodB
      });

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController Name = TextEditingController();
  final TextEditingController dob = TextEditingController();
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
              lockAspectRatio: false
          ),
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

  String pic = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add a Student"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
              InkWell(
                onTap: () async {
                  Uint8List? _file = await pickImage(ImageSource.gallery);
                  String photoUrl = await StorageMethods()
                      .uploadImageToStorage('students', _file!, true);
                  setState(() {
                    pic = photoUrl;
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
                    child: Image.network(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                      fit: BoxFit.cover,
                    )
                    // You can customize the fit as needed
                    ),
              ),
              SizedBox(height: 6),
              d(
                Name,
                "Student Name",
                "AYUSMAN SAMASI",
                false,
              ),
              d(
                Registration_number,
                "Registration Number",
                "TN09863256",
                false,
              ),
              widget.RegisB ?  d(
                AdmissionNumber,
                "Admission Number",
                "AN000123",
                false,
              ) : SizedBox(),
              d(
                id_number,
                "Id Number",
                "AN000123",
                false,
              ),
              d(
                dob,
                "Date of Birth",
                "14 October 2023",
                false,
              ),
              max(Roll, "Roll Number", "21", true, 3),
              widget.BloodB ? max(blood, "Blood Group", "A+", false, 3) : SizedBox(),
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
              widget.MotherB ? d(
                Mother,
                "Mother Name",
                "RATAN SAMASI",
                false,
              ) : SizedBox(width : 0.1),
              max(Mobile, "Mobile Number", "7978097489", true, 10),
              widget.EmailB ? d(
                Email,
                "Email",
                "hariswarsamasi@gmail.com",
                false,
              ): SizedBox(width : 0.1),
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
              widget.DepB ? d(
                Department,
                "Department / Major",
                "Science",
                false,
              ): SizedBox(width : 0.1),
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
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: widget.Other1B ? d(
                    Other1,
                    "Other1",
                    " ",
                    false,
                  ): SizedBox(width : 0.1),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: widget.Other2B ? d(
                    Other2,
                    "Other2",
                    " ",
                    false,
                  ): SizedBox(width : 0.1),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: widget.Other3B ? d(
                    Other3,
                    "Other3",
                    " ",
                    false,
                  ): SizedBox(width : 0.1),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: widget.Other4B ? d(
                    Other4,
                    "Other4",
                    " ",
                    false,
                  ): SizedBox(width : 0.1),
                )
              ]),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SocialLoginButton(
                  backgroundColor: Color(0xff50008e),
                  height: 40,
                  text: 'Add Student Now',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    try {
                      CollectionReference collection = FirebaseFirestore
                          .instance
                          .collection('School')
                          .doc(widget.id)
                          .collection('Session')
                          .doc(widget.session_id)
                          .collection('Class')
                          .doc(widget.classid)
                          .collection("Student");

                      String customDocumentId = DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(); // Replace with your own custom ID
                      String Mobile1 = Mobile.text;
                      String Roll1 = Roll.text;
                      // Try to parse the text to an integer
                      int rollNumber = int.tryParse(Roll1) ?? 3;
                      String shhhh = AdmissionNumber.text.isEmpty ? customDocumentId : AdmissionNumber.text ;
                      int MobileNum = int.tryParse(Mobile1) ?? 7978097489;
                      StudentModel student1 = StudentModel(
                          Name: Name.text,
                          id: id_number.text,
                          Address: Address.text,
                          Email: Email.text ?? 'NA',
                          Admission_number: shhhh ,
                          Batch: Batch.text,
                          BloodGroup: blood.text ?? 'NA',
                          Class: Class.text,
                          Con: " ",
                          Department: Department.text  ?? 'NA',
                          Driver: " ",
                          Father_Name: Father.text,
                          Mobile: MobileNum,
                          Mother_Name: Mother.text  ?? 'NA',
                          pic: pic,
                          Registration_number: Registration_number.text,
                          Roll_number: rollNumber,
                          Section: Section.text,
                          Session: Session.text,
                          Other1: Other1.text ?? 'NA',
                          Other2: Other2.text ?? 'NA',
                          Other3: Other3.text ?? 'NA',
                          Other4: Other4.text  ?? 'NA',
                          state: "Editing", dob: dob.text);
                      await collection
                          .doc(shhhh)
                          .set(student1.toJson());
                      CollectionReference collection22 = FirebaseFirestore.instance.collection('Admin');
                      await collection22.doc("Order").update({
                        'Students': FieldValue.increment(1)  ,
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      print('${e}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${e}'),
                        ),
                      );
                    }
                    ;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget d(
    TextEditingController c,
    String label,
    String hint,
    bool number,
  ) {
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

class StudentProfile extends StatelessWidget {
  bool parent;

  StudentModel user;

  String class_id;
  String session_id;
  String school_id;

  StudentProfile(
      {super.key,
      required this.user,
      required this.class_id,
      required this.session_id,
      required this.school_id,
      required this.parent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.Name),
        backgroundColor: Colors.orange,
        actions: [
          parent
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      onPressed: () async {
                        CollectionReference collection = FirebaseFirestore
                            .instance
                            .collection('School')
                            .doc(school_id)
                            .collection('Session')
                            .doc(session_id)
                            .collection('Class')
                            .doc(class_id)
                            .collection("Student");
                        await collection.doc(user.Admission_number).delete();
                        CollectionReference collection22 = FirebaseFirestore.instance.collection('Admin');
                        await collection22.doc("Order").update({
                          'Students': FieldValue.increment(-1)  ,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.pic),
                  radius: 120,
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: class_id,
                            session_id: session_id,
                            pic: user.pic,
                            school_id: school_id,
                            student_id: user.Admission_number,
                            change_change: 'Name',
                            to_change: 'Name',
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
                          child: Student_Data_Update(
                            class_id: class_id,
                            session_id: session_id,
                            pic: user.pic,
                            school_id: school_id,
                            student_id: user.Admission_number,
                            change_change: 'Father Name',
                            to_change: 'Father_Name',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Father Name", user.Father_Name, true, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: class_id,
                            session_id: session_id,
                            pic: user.pic,
                            school_id: school_id,
                            student_id: user.Admission_number,
                            change_change: 'Mother Name',
                            to_change: 'Mother_Name',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Mother Name", user.Mother_Name, false, true)),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: class_id,
                            session_id: session_id,
                            pic: user.pic,
                            school_id: school_id,
                            student_id: user.Admission_number,
                            change_change: 'Blood Group',
                            to_change: 'BloodGroup',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Blood Group", user.BloodGroup, true, true)),
            s("Mobile", user.Mobile.toString(), false, false),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: class_id,
                            session_id: session_id,
                            pic: user.pic,
                            school_id: school_id,
                            student_id: user.Admission_number,
                            change_change: 'Email',
                            to_change: 'Email',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Email", user.Email, true, true)),
            SizedBox(height: 20),
            s("Admission Number", user.Admission_number, false, false),
            s("Registration Number", user.Registration_number, true, false),
            s("ID", user.id, false, false),
            s("Session", user.Session, true, false),
            s("Roll Number", user.Roll_number.toString(), false, false),
            SizedBox(height: 20),
            s("Batch", user.Batch, true, false),
            s("Class", user.Class, false, false),
            s("Section", user.Section, true, false),
            s("Department", user.Department, false, false),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Student_Data_Update(
                            class_id: class_id,
                            session_id: session_id,
                            pic: user.pic,
                            school_id: school_id,
                            student_id: user.Admission_number,
                            change_change: 'Address',
                            to_change: 'Address',
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                },
                child: s("Address", user.Address, true, true)),
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
              if (parent) {
                CollectionReference collection = FirebaseFirestore.instance
                    .collection('School')
                    .doc(school_id)
                    .collection('Session')
                    .doc(session_id)
                    .collection('Class')
                    .doc(class_id)
                    .collection("Student");
                await collection.doc(user.Admission_number).update({
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
                    .doc(school_id)
                    .collection('Session')
                    .doc(session_id)
                    .collection('Class')
                    .doc(class_id)
                    .collection("Student");
                await collection.doc(user.Admission_number).update({
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
