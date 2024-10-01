import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/model/employee_model.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/upload/storage.dart';
import 'package:student_managment_app/zemployee/card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class UiE extends StatelessWidget {
  SchoolModel user ; bool pres;
   UiE({super.key, required this.user,required this.pres});
   List<EmployeeModel> list = [];
   late Map<String, dynamic> userMap;
   TextEditingController ud = TextEditingController();
   final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text("All Employee", style : TextStyle(color : Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
      body : StreamBuilder(
        stream: Fire.collection('School')
            .doc(user.id)
            .collection('Employee')
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => EmployeeModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                        user: list[index], SchoolId: user.id,pres:pres
                    );
                  });
          }
        },
      ),
      floatingActionButton : FloatingActionButton(
        child : Icon(Icons.add), onPressed : (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Add(  user : user)
          ),
        );
      }
      )
    );
  }
}

class ChatUser extends StatelessWidget {
  EmployeeModel user ; String SchoolId; bool pres;
   ChatUser({super.key, required this.user, required this.SchoolId,required this.pres});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap : (){
        if(pres){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Qrcode(idi: user.Id_number, school_id: SchoolId,    )
            ),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmpC(user:user, cssession: SchoolId,    )
            ),
          );
        }

      },
      leading : CircleAvatar(
        backgroundImage : NetworkImage(user.Pic),
      ),
        title : Text(user.Name, style : TextStyle(fontWeight : FontWeight.w900)),
        subtitle : Text(user.Profession, style : TextStyle(fontWeight : FontWeight.w700)),
      trailing : acheck(),
    );
  }
  Widget acheck(){
    DateTime now = DateTime.now();
    String stm = '${now.day}-${now.month}-${now.year}';
    if ( user.present.contains(stm)) {
      return Text("P", style : TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color : Colors.blue));
    }else{
      return Text("A", style : TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color : Colors.red));
    }
  }
}

class Qrcode extends StatefulWidget {
  String school_id, idi ;

  Qrcode(
      {super.key, required this.school_id,  required this.idi});

  @override
  State<Qrcode> createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {

  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.school_id}/${widget.idi}');
    qrImage = QrImage(qrCode);
  }
  final GlobalKey boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : Text("Employee QR Code")
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: boundaryKey,
            child: Container(
              color : Colors.white,
              child: Padding ( padding : EdgeInsets.all(45), child : PrettyQrView(
                qrImage: qrImage,
                decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                    image: AssetImage('assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png'),
                  ),
                ),
              ), ),
            ),
          ),
          Text("This is your QR Code ! ", style : TextStyle(color : Colors.blue, fontWeight: FontWeight.w800, fontSize: 22))
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Download Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                  Text('Downloading Image !'),
                ),
              );
              try {
                RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Adjust the pixelRatio as needed
                ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                Uint8List pngBytes = byteData!.buffer.asUint8List();
                final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('Image saved $result'),
                  ),
                );
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('${e}'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}



class Add extends StatefulWidget {
  SchoolModel user ;
   Add({super.key, required this.user});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController Name = TextEditingController();

  TextEditingController Pic = TextEditingController();

  TextEditingController DOB = TextEditingController();

  TextEditingController Profession = TextEditingController();

  TextEditingController Address = TextEditingController();

  TextEditingController Phone = TextEditingController();

  TextEditingController Email = TextEditingController();

  TextEditingController BloodG = TextEditingController();

  TextEditingController Father_Name = TextEditingController();

  TextEditingController Id_number = TextEditingController();

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

  Uint8List? _file2;

  String pic = " ";

  bool isUploading = false;

  int i = 1 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Add Student Data", style : TextStyle(color : Colors.white)),
        backgroundColor: Color(0xff50008e),
      ),
      body : SingleChildScrollView(
        child: Column(
          children : [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.supervised_user_circle, size: 30, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Personal Information",
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
            d(Name, "Name", "Ayusman", false,  ),
            d(Id_number, "Employee ID", "MG8329A9J8", false,  ),
            d(BloodG, "Blood Group", "AB+", false,  ),
            d(DOB, "DOB", "14/10/2003", false,  ),
            d(Father_Name, "Father Name", "Human", false,  ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.school, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Profession Information",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            d(Profession, "Profession", "English Teacher", false,  ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.contact_page, size: 30, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Contact Information",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            d(Phone, "Phone", "7978097489", true  ),
            d(Email, "Email", "hariswarsamasi@gmail.com", false,  ),
            d(Address, "Address", "RS Colony, Jhirpani, Rourkela", false,  ),
          ]
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Add Employee Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              String nj = DateTime.now().microsecondsSinceEpoch.toString() ;
              EmployeeModel u = EmployeeModel(Name: Name.text, Pic: pic, DOB: DOB.text, Profession: Profession.text,
                Address: Address.text, Phone: Phone.text, Email: Email.text, BloodG: BloodG.text,
                Emergency_Contact: 'j', Father_Name: Father_Name.text, Id_number: nj,present:[],
                Registration_Number: Id_number.text,
              );
              try {
                await FirebaseFirestore.instance.collection('School')
                    .doc(widget.user.id)
                    .collection('Employee').doc(nj).set(u.toJson());
                Navigator.pop(context);
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
        ),
      ],
    );
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
}
