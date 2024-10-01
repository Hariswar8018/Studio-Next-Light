import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/aextra/session.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import '../model/fee.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:student_managment_app/after_login/class.dart' as d;
import 'package:url_launcher/url_launcher.dart';

import '../upload/storage.dart';


class Fee extends StatefulWidget {
  SchoolModel user;
  String id;

  bool b;

  Fee({super.key, required this.id, required this.user, required this.b});

  @override
  State<Fee> createState() => _FeeState();
}

class _FeeState extends State<Fee> {
  List<FeeModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  final List<String> items = [
    '2019',
    '2020',
    '2021',
    '2022', '2023','2024','2025','2026','2027','2028','2029',
  ];
  final List<String> items1 = [
    '1',
    '2',
    '3',
    '4', // This value is causing the error
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  void initState(){
    DateTime now = DateTime.now();
    int Mo = now.month;
    int Ye = now.year;
    setState((){
       selectedValue = Ye.toString();
    });
    setState((){
      mo = Mo.toString();
    });
  }

  String selectedValue = "2023";
  String mo = "1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff50008e),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Fee Details', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list_outlined,
              )),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(height : 60, width : MediaQuery.of(context).size.width , color : Colors.deepPurple.shade200,
            child : Center (
              child : Row(
                children : [
                  Container(
                    width : MediaQuery.of(context).size.width / 2,
                    child : DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Year',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14, color : Colors.black
                            ),
                          ),
                        ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width : MediaQuery.of(context).size.width / 2,
                    child : DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Month',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items1
                            .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                                fontSize: 14, color : Colors.black
                            ),
                          ),
                        ))
                            .toList(),
                        value: mo,
                        onChanged: (String? value) {
                          setState(() {
                            mo = value!;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  )
                ]
              )
            )
          ),
          Container(
            height : MediaQuery.of(context).size.height - 145,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                  .collection('Fee')
                  .doc(selectedValue).collection("Month").doc(mo).collection("Day").snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list =
                        data?.map((e) => FeeModel.fromJson(e.data())).toList() ?? [];
                    if ( list.isEmpty){
                      return Center(
                        child : Column(
                          mainAxisAlignment : MainAxisAlignment.center,
                          children : [
                            Icon(Icons.hourglass_empty, color : Colors.red, size : 80),
                            Text(textAlign : TextAlign.center, "Look Likes ! No Transaction have occured during the Timeline", style : TextStyle(color : Colors.red, fontSize : 17)),
                            SizedBox(height : 15),
                            TextButton(onPressed:(){
                              DateTime now = DateTime.now();
                              int Mo = now.month;
                              int Ye = now.year;
                              setState((){
                                selectedValue = Ye.toString();
                              });
                              setState((){
                                mo = Mo.toString();
                              });
                            }, child : Text("Go to Today")),
                          ]
                        )
                      );
                    }else{
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(bottom: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser(user: list[index], u: widget.user, b: widget.b);
                        },
                      );
                    }

                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUser extends StatelessWidget {
  SchoolModel u;

  bool b;

  ChatUser({super.key, required this.user, required this.u, required this.b});

  FeeModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => K(user: user, b: b, u: u)),
        );
      },
      leading: Icon(Icons.verified, color : Colors.blueAccent),
      title: Text("₹" + user.Total_Fee, style : TextStyle(fontWeight : FontWeight.w900, fontSize: 21 )),
      subtitle: Text(user.Student_Name, style : TextStyle(fontWeight : FontWeight.w500, fontSize: 17)),
      trailing: Text("PAID : " + user.time + " PM", style : TextStyle(fontWeight : FontWeight.w500, fontSize: 12)),
    );
  }
}

class K extends StatefulWidget {
  K({super.key, required this.user, required this.b, required this.u});

  FeeModel user;

  SchoolModel u;

  bool b;

  @override
  State<K> createState() => _KState();
}

class _KState extends State<K> {
  final GlobalKey boundaryKey = GlobalKey();
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
              toolbarTitle: 'Crop Image',
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
  String pic = "https://lh5.googleusercontent.com/p/AF1QipMXCPA_gRTOuJrZLOKgC723ELhqc-U4NlFQhE50=w1080-k-no";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor : Color(0xff50008e),
        iconTheme: IconThemeData(
          color : Colors.white
        ),
        actions : [
          IconButton(
            icon : Icon(Icons.camera_alt),
            onPressed  : () async {
              Uint8List? _file = await pickImage(ImageSource.gallery);
              String photoUrl = await StorageMethods()
                  .uploadImageToStorage('users', _file!, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Paid Picture Updated"),
                ),
              );
              await FirebaseFirestore.instance.collection("School").doc(widget.u.id).update({
                "paidp" : photoUrl ,
              });
              Navigator.pop(context);
              Navigator.pop(context);
            }
          ),
          IconButton(
              icon : Icon(Icons.circle),
              onPressed  : () async {
                Uint8List? _file = await pickImage(ImageSource.gallery);
                String photoUrl = await StorageMethods()
                    .uploadImageToStorage('users', _file!, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Stamp Picture Updated"),
                  ),
                );
                await FirebaseFirestore.instance.collection("School").doc(widget.u.id).update({
                  "stampp" : photoUrl ,
                });
                Navigator.pop(context);
                Navigator.pop(context);
              }
          )
        ]
      ),
      body: RepaintBoundary(
        key: boundaryKey,
        child: Container(
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height : 20),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.user.Pic_thumbnail),
                      opacity: 0.6,
                      fit: BoxFit.cover),
                ),
                child: Row(children: [
                  SizedBox(width: 22),
                  CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.user.Pic_logo,
                      ),
                      radius: 40)
                ])),
            SizedBox(height: 12),
            Text("Fee Receipt",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                SizedBox(width: 15),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 18,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From"),
                        Text(widget.u.Name + ",",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 17)),
                        Text("Email : " + widget.u.Email,
                            style: TextStyle(fontSize: 15)),
                        Text("Phone : " + widget.u.Phone,
                            style: TextStyle(fontSize: 15)),
                      ]),
                ),
                SizedBox(width: 30),
                Container(
                    width: MediaQuery.of(context).size.width / 2 - 18,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("To"),
                          Text(widget.user.Student_Name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 17)),
                          Text("Class : " +
                              widget.user.S_class +
                              "( " +
                              widget.user.S_Section +
                              " )"),
                          Text("Email : " + widget.user.Parent_Email),
                          Text("Phone : " + widget.user.Parent_Phone),
                        ])),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Set the border color here
                      width: 1, // Set the border width
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        SizedBox(width: 15),
                        Container(
                            width: MediaQuery.of(context).size.width / 2 - 18,
                            child: Text("Fee Type",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        SizedBox(width: 30),
                        Container(
                            width: MediaQuery.of(context).size.width / 2 - 18,
                            child: Text("Amount",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                      ]),
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      a("Admission Fee", widget.user.Ad_Fee),
                      a("Tution Fee", widget.user.TutionF),
                      a("Exam Fee", widget.user.ExamF),
                      SizedBox(height: 5),
                      a("Development Fee", widget.user.DevF),
                      a("Monthly Fee", widget.user.MonthlyF),
                      a("Transport Fee", widget.user.TransportF),
                      SizedBox(height: 5),
                      a("Additional Fee", "0"),
                      a("Multi Type Fee", widget.user.MTF),
                      a("ID Card Fee", widget.user.ID_Card_Fee),
                      a("Late Fee", widget.user.LetF),
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      a("Total Fee", widget.user.Total_Fee),
                      SizedBox(height: 5),
                    ],
                  )),
            ),
            SizedBox(height: 25),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Image.network(
                          height: 55,
                          widget.u.stampp ),
                      Text("Stamp of School"),
                    ],
                  ),
                  Column(
                    children: [
                      Image.network(height: 45, widget.u.AuthorizeSignature),
                      Text("Principal Signature"),
                    ],
                  ),
                  Column(
                    children: [
                      Image.network(
                          height: 45,
                          widget.u.paidp ),
                      Text("Paid Signature"),
                    ],
                  )
                ])
          ]),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: widget.b ? "Download Receipt & Send" : "Edit Receipt",
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              if (widget.b) {
                RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Adjust the pixelRatio as needed
                ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                Uint8List pngBytes = byteData!.buffer.asUint8List();
                final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
                String phoneNumber = "91" + widget.user.Phone;
                String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeFull("Hello, We had got your Payment Receipt in our School")}";
                final Uri _url = Uri.parse(whatsappUrl);
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Editing From will be available post 24 hours once receipt is made'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget a(String s1, String s2) {
    return Row(children: [
      SizedBox(width: 15),
      Container(
          width: MediaQuery.of(context).size.width / 2 - 18,
          child:
              Text(s1 + " :", style: TextStyle(fontWeight: FontWeight.w500))),
      SizedBox(width: 30),
      Container(
          width: MediaQuery.of(context).size.width / 2 - 65,
          child:
              Text("₹ " + s2, style: TextStyle(fontWeight: FontWeight.w500))),
    ]);
  }
}

class AddFee extends StatefulWidget {
  SchoolModel user;

  AddFee({super.key, required this.user});

  @override
  State<AddFee> createState() => _AddFeeState();
}

class _AddFeeState extends State<AddFee> {
  TextEditingController School = TextEditingController();

  TextEditingController Address = TextEditingController();

  TextEditingController Email = TextEditingController();
String hy = "y7" ;
  TextEditingController Phone = TextEditingController();

  TextEditingController Name = TextEditingController();

  TextEditingController Classs = TextEditingController();

  TextEditingController Section = TextEditingController();

  TextEditingController Registrationn = TextEditingController();

  TextEditingController Emrollment = TextEditingController();

  TextEditingController Feef = TextEditingController();

  TextEditingController Session = TextEditingController();

  TextEditingController Gst = TextEditingController();

  TextEditingController ID = TextEditingController();

  TextEditingController Tras = TextEditingController();

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Add Payment", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff50008e),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child:
                Icon(Icons.supervised_user_circle, size: 30, color: Colors.red),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Student Info",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          ListTile(
            onTap: () async {
              StudentModel u = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SessionJust(id: widget.user.id, student: true, reminder : false, sname : widget.user.Name)),
              );
              print(u.Name);
              setState(() {
                Name.text = u.Name;
                Classs.text = u.Class;
                Section.text = u.Section;
                Registrationn.text = u.Registration_number;
                Emrollment.text = u.Admission_number;
                Phone.text = u.Mobile;
                Email.text = u.Email;
                Feef.text = u.Myfee.toString();
              });
            },
            splashColor: Colors.orange,
            tileColor: Colors.greenAccent.shade100,
            leading: Icon(Icons.dataset_rounded),
            title: Text("Add from School Data",
                style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text("Add from already present Student Data"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          max(Name, "Student Name", "Ayusman Samasi", false),
          max(Classs, "Class", "10", false),
          max(Section, "Section", "A", false),
          max(Registrationn, "Registration Number", "DH5805V758", false),
          max(Emrollment, "Enrollment Number", "YHK9543378", false),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(Icons.home, size: 30, color: Colors.red),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Contact Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          max(Phone, "Phone", "Phone Number", true),
          max(Email, "Email", "hariswarsamasi@gmail.com", false),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(Icons.credit_card, size: 30, color: Colors.green),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Payment Detail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Total Amount Paid :  ₹ " + Feef.text,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
          ),
          ListTile(
            onTap: () async {
              d.SessionModel u = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SessionJust(id: widget.user.id, student: false, reminder : false, sname : widget.user.Name)),
              );
              setState(() {
                hy = u.id ;
                print(hy);
                Addition.text = u.Ad_Fee ?? "0";
                Tras.text = u.TransportF ?? "0";
                MTF.text = u.MTF ?? "0";
                Ad_Fee.text = u.Ad_Fee ?? "0";
                Dev_F.text = u.DevF ?? "0";
                ID_Car.text = u.ID_Card_Fee ?? "0";
                ID.text = u.ID_Card_Fee ?? "0";
                Transport_Fee.text = u.TransportF ?? "0";
                Late_Fee.text = u.LetF ?? "0";
                Monthly_F.text = u.MonthlyF ?? "0";
                Tution_F.text = u.TutionF ?? "0";
                Exam_F.text = u.ExamF ?? "0";
              });
            },
            splashColor: Colors.orange,
            tileColor: Colors.greenAccent.shade100,
            leading: Icon(Icons.dataset_rounded),
            title: Text("Add from School Data",
                style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text("Add from Class Data"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          max(Addition, "Additional Fee", "100.0", true),
          f(context, MTF, "MT Fee", "0.0", true, Ad_Fee, "Admission Fee", "0.0",
              true),
          f(context, Dev_F, "Development Fee", "0.0", true, Exam_F, "Exam Fee",
              "0.0", true),
          f(context, Tution_F, "Tution Fee", "0.0", true, Monthly_F,
              "Monthly Fee", "0.0", true),
          f(context, Late_Fee, "Late Fee", "0.0", true, Transport_Fee,
              "Transport Fee", "0.0", true),
          f(context, ID_Car, "ID Card Fee", "0.0", true, GST, "GST", "0.0",
              true),
        ]),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Add Entry :  ₹${Feef.text}',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              DateTime now = DateTime.now();
              int Mo = now.month;
              int Ye = now.year;
              String df = now.millisecondsSinceEpoch.toString();
              String formattedDate = DateFormat('dd/MM/yyyy').format(now);
              String formatted = DateFormat('hh:mm').format(now);
              FeeModel u = FeeModel(
                School_Name: widget.user.id,
                Address: Address.text,
                Email: widget.user.Email,
                Phone: widget.user.Phone,
                Pic_logo: widget.user.Pic_link,
                Pic_thumbnail: widget.user.Pic,
                Student_Name: Name.text,
                S_class: Classs.text,
                S_Section: Section.text,
                Registration_N: Registrationn.text,
                Enrollment_N: Emrollment.text,
                Parent_Phone: Phone.text,
                Parent_Email: Email.text,
                Total_Fee: Feef.text ?? "0",
                MTF: MTF.text ?? "0",
                Ad_Fee: Ad_Fee.text ?? "0",
                DevF: Dev_F.text ?? "0",
                ExamF: Exam_F.text ?? "0",
                TutionF: Tution_F.text ?? "0",
                MonthlyF: Monthly_F.text ?? "0",
                LetF: Late_Fee.text ?? "0",
                TransportF: Transport_Fee.text ?? "0",
                ID_Card_Fee: ID_Car.text ?? "0",
                on: false,
                Gst: Gst.text ?? "0",
                Session: Session.text,
                id: df,
                date: formattedDate,
                time: formatted, Year: '', Month: '',
              );
              int g = int.parse(Feef.text);
              await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                  .collection('Fee')
                  .doc(Ye.toString()).collection("Month").doc(Mo.toString()).collection("Day").doc(df)
                  .set(u.toJson());
              try{
                await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                    .collection('Session').doc(widget.user.csession)
                    .collection('Class').doc(hy)
                    .collection('Student').doc(Registrationn.text ).update({
                  "Mf": FieldValue.increment(-g),
                });
              }catch (e){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Class or Student Data not Added ! Please decrease Fee manually !')));
              }
              try {
                await FirebaseFirestore.instance.collection('School').doc(
                    widget.user.id)
                    .collection('Fee')
                    .doc(Ye.toString()).collection("Month")
                    .doc(Mo.toString())
                    .update({
                  "Fee": FieldValue.increment(g),
                });
              }catch(e){
                await FirebaseFirestore.instance.collection('School').doc(
                    widget.user.id)
                    .collection('Fee')
                    .doc(Ye.toString()).collection("Month")
                    .doc(Mo.toString())
                    .set({
                  "Fee": g,
                });
              }
              try{
                await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                    .collection('Fee').doc(df)
                    .set(u.toJson());
                print("Done");
              }catch(e){

              }
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget f(BuildContext context, TextEditingController t1, String s1, String s2,
      bool b1, TextEditingController t2, String s3, String s4, bool b2) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Container(
            width: MediaQuery.of(context).size.width / 2 - 10,
            child: max(t1, s1, s2, b1)),
        Container(
            width: MediaQuery.of(context).size.width / 2 - 10,
            child: max(t2, s3, s3, b2)),
      ]),
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
        onChanged: (value) {
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
          int total = mtf +
              adFee +
              devF +
              examF +
              tutionF +
              monthlyF +
              lateFee +
              transportFee +
              idCar +
              addition +
              gst;
          // Set the Feef.text as the total converted to string
          Feef.text = total.toString();
        },
      ),
    );
  }
}
