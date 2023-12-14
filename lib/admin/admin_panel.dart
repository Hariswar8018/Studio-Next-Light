import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:studio_next_light/admin/onoff.dart';
import 'package:studio_next_light/admin/update_school.dart';
import 'package:studio_next_light/after_login/session.dart';
import 'package:studio_next_light/before_check/first.dart';
import 'package:studio_next_light/model/school_model.dart';
import 'package:studio_next_light/model/student_model.dart';
import 'dart:typed_data';
import 'package:crop_image/crop_image.dart';
import 'package:studio_next_light/upload/storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/after_login/session.dart';
import 'package:studio_next_light/upload/storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AdminP extends StatelessWidget {
  AdminP({super.key});

  List<SchoolModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  String s = FirebaseAuth.instance.currentUser!.email ?? "tt";

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset("assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png")),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Our Website"),
            onTap: () async {
              final Uri _url = Uri.parse('https://wingtrix.in/');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            splashColor: Colors.orange.shade200,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(Icons.work, color: Colors.redAccent, size: 30),
            title: Text("Our Services"),
            onTap: () async {},
            splashColor: Colors.orange.shade300,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.redAccent,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(Icons.map, color: Colors.greenAccent, size: 30),
            title: Text("Locate on Map"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'https://www.google.com/maps?q=15.2803236,73.9558804');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.greenAccent,
              size: 20,
            ),
            splashColor: Colors.orange.shade300,
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.redAccent, size: 30),
            title: Text("Mail Us"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'mailto:nextlight000@gmail.com?subject=Known_more_about_services&body=New%20plugin');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            splashColor: Colors.orange.shade300,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.redAccent,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: SocialMediaButton.whatsapp(
              onTap: () {
                print('or just use onTap callback');
              },
              size: 35,
              color: Colors.green,
            ),
            title: Text("Whatsapp"),
            onTap: () async {
              final Uri _url =
              Uri.parse('https://wa.me/917000994158?text=Hello!%20We%20are%20contacting%20you%20for%20Students%20ID%20Card%20Services!');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            subtitle: Text("Inquire in Whatsapp"),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.green,
              size: 20,
            ),
            splashColor: Colors.orange.shade300,
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: SocialMediaButton.instagram(
              onTap: () {
                print('or just use onTap callback');
              },
              size: 35,
              color: Colors.red,
            ),
            title: Text("Instagram"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'https://instagram.com/studio_next_light?igshid=MTNiYzNiMzkwZA==');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            subtitle: Text("Follow on Instagram"),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.purpleAccent,
              size: 20,
            ),
            splashColor: Colors.orange.shade300,
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
              size: 30,
            ),
            title: Text("Log Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              print('User signed out');
              // Navigate to the login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => First()),
              );
            },
            splashColor: Colors.orange.shade200,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
            subtitle : Text("Log out "),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff50008e),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Add_School(),
              ),
            );
          },
          child: Icon(Icons.add, color : Colors.white)),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color : Colors.white,
        ),
        // leading: IconButton(
        //   onPressed: (){
        //     buildDrawer(context);
        //   },
        //   icon : Icon(Icons.menu_outlined),
        // ),
        backgroundColor: Color(0xff50008e),
        title: Center(
            child: Text('School\'s You Operate', style : TextStyle(color : Colors.white))),
        actions: [
          IconButton(onPressed: () async {
            final Uri _url =
            Uri.parse('https://wa.me/917000994158?text=Hi%20Wingtrix');
            if (!await launchUrl(_url)) {
            throw Exception('Could not launch $_url');
            }
          }, icon: Icon(Icons.waving_hand),),
          SizedBox(width : 7),
        ],
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').where('Admin_Email', isEqualTo : s).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => SchoolModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class ChatUser extends StatefulWidget {
  final SchoolModel user;

  const ChatUser({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUser> createState() => ChatUserState();
}

class ChatUserState extends State<ChatUser> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, PageTransition(
            child: StudentProfile( user : widget.user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(widget.user.Pic), fit: BoxFit.cover),
                ),
              ),
            ),
            ListTile(
              title: Text(widget.user.Name),
              subtitle: Text(
                widget.user.Address,
                maxLines: 1,
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.Pic_link),
              ),
              trailing: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person_pin),
                  label: Text(widget.user.Students.toString())),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


class Add_School extends StatefulWidget {
  Add_School({super.key});

  @override
  State<Add_School> createState() => _Add_SchoolState();
}

class _Add_SchoolState extends State<Add_School> {

  final List<String> items = [
    'School',
    'College',
    'University',
  ];
  String? selectedValue;

  final List<String> items2 = [
    'Surguja',
    'Surajpur',
    'Balarmpur',
    'Joshpur',
    'Koriya',
    'Manendragarh',
  ];
  String? selectedValue2;

  final TextEditingController Name = TextEditingController();
  final TextEditingController Email = TextEditingController();
  final TextEditingController Address = TextEditingController();
  final TextEditingController AdminEmail = TextEditingController();
  final TextEditingController ClientEmail = TextEditingController();
  final TextEditingController Mobile = TextEditingController();
  final TextEditingController id = TextEditingController();
  final TextEditingController Chief = TextEditingController();
  final TextEditingController Uidse = TextEditingController();




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

  String pic = "https://lh5.googleusercontent.com/p/AF1QipMXCPA_gRTOuJrZLOKgC723ELhqc-U4NlFQhE50=w1080-k-no";
  String pic12 = "https://content.jdmagicbox.com/comp/bilaspur-chhattisgarh/dc/9999p7752.7752.100429114031.y6v6dc/catalogue/m-g-m-english-medium-school-tifra-bilaspur-chhattisgarh-schools-fmhky.jpeg";
  String pic2 = "https://pro-bee-user-content-eu-west-1.s3.amazonaws.com/public/users/Integrators/5eb55a21-9496-46ce-8161-f092fc9def23/bosco/Employee%20Headshots%20and%20Signatures/Christian-De-Larkin-signature.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Add Your Institution"),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Uint8List? _file = await pickImage(ImageSource.gallery);
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('users', _file!, true);
                          setState(() {
                            pic = photoUrl;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Logo Pic uploaded"),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Image.network(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Container(
                        width : 100,
                        child: Padding(
                          padding: const EdgeInsets.only( top :8.0, bottom : 15),
                          child: Text("Upload logo 100cm x 100cm", textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Uint8List? _file = await pickImage(ImageSource.gallery);
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('users', _file!, true);
                          setState(() {
                            pic12 = photoUrl;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Logo Pic uploaded"),
                            ),
                          );
                        },
                        child: Container(
                          height: 90,
                          width: 200,
                          child: Image.network(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                  fit: BoxFit.cover,
                                )
                        ),
                      ),
                      Container(
                        width : MediaQuery.of(context).size.width - 120 ,
                        child: Padding(
                          padding: const EdgeInsets.only( top :8.0, bottom : 15),
                          child: Center(child: Text( textAlign: TextAlign.center ,"Upload School Image 1080px x 720px")),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  Uint8List? _file = await pickImage(ImageSource.gallery);
                  String photoUrl = await StorageMethods()
                      .uploadImageToStorage('users', _file!, true);
                  setState(() {
                    pic2 = photoUrl;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Authrize Signature uploaded"),
                    ),
                  );
                },
                child: Container(
                    height: 90,
                    width: 280,
                    child: Image.network(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                      fit: BoxFit.cover,
                    )
                ),
              ),
              Container(
                width : MediaQuery.of(context).size.width - 60 ,
                child: Padding(
                  padding: const EdgeInsets.only( top :8.0, bottom : 15),
                  child: Center(child: Text( textAlign: TextAlign.center ,"Upload School Principle / Authorize Signature or Stamp 1920 x 720")),
                ),
              ),
              d(
                Name,
                "School Name",
                "MGM ENGLISH SCHOOL",
                false,
              ),
              d(
                ClientEmail,
                "School Email ( for School Login* )",
                "mgm@mgmesrourkela.com",
                false,
              ),

              d(
                Chief,
                "Your Name",
                "AYUSMAN SAMASI",
                false,
              ),
              d(
                Mobile,
                "Mobile Number ( Support for School ) ",
                "7978097489",
                true,
              ),
              d(
                Email,
                "Email ( Support for School )",
                "hariswarsamasi@gmail.com",
                false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children :[
                  Container(
                    width : MediaQuery.of(context).size.width/2 - 40,
                    child :  DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Institution ?',
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
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 250,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width : MediaQuery.of(context).size.width/2 - 40,
                      child :  DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Division',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items2
                              .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                              .toList(),
                          value: selectedValue2,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue2 = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 200,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                  ),
                ]
              ),
              d(
                Uidse,
                "School UIDSE **",
                "THHU66789",
                false,
              ),
              d(
                Address,
                "Address of School",
                "A-20, Jhirpani, Rourkela, Odisha",
                false,
              ),
              Padding(
                padding: const EdgeInsets.only( left : 3.0, right : 3),
                child: Text("* Institute with this Email could Login and Upload Data"),
              ),
              Padding(
                padding: const EdgeInsets.only( left : 3.0, right : 3),
                child: Text("** Parents could find School with this UIDSE Code"),
              ),

            ],
          ),
        ),
      persistentFooterButtons: [
        Padding(
            padding: const EdgeInsets.all(14.0),
            child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Add School Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  String g = FirebaseAuth.instance.currentUser!.email ?? "h" ;
                  String hhh = DateTime.now().millisecondsSinceEpoch.toString() ;
                  SchoolModel sh = SchoolModel(Address: Address.text, Email: Email.text, Name: Name.text,
                    Pic_link: pic, Students: 0, Pic: pic12, id: hhh,
                    Adminemail: g, Phone: Mobile.text, Clientemail: ClientEmail.text, AuthorizeSignature: pic2, b: true,
                    Chief: Chief.text, uidise: Uidse.text, BloodB: true, DepB: true,
                    EmailB: true, MotherB: true, Other1B: true, Other2B: true, Other3B: true,
                    Other4B: true, RegisB: true, );
                  CollectionReference collection = FirebaseFirestore.instance.collection('School');
                  await collection.doc(hhh).set(sh.toJson());
                  CollectionReference collection22 = FirebaseFirestore.instance.collection('Admin');
                  await collection22.doc("Order").update({
                    '$selectedValue': FieldValue.arrayUnion([hhh]),
                    '$selectedValue2': FieldValue.arrayUnion([hhh])
                  });
                  Navigator.pop(context);
                }))
      ],

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
}




class StudentProfile extends StatefulWidget {
 SchoolModel user ;
  StudentProfile({super.key, required this.user});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {

  bool b = true ;
  void initState(){
    setState(() {
      b = widget.user.b ;
    });

  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.Name),
          backgroundColor: Colors.orange,
        ),
        body : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Uint8List? _file = await pickImage(ImageSource.gallery);
                  String photoUrl =  await StorageMethods().uploadImageToStorage('users', _file!, true);
                  await FirebaseFirestore.instance
                      .collection('School')
                      .doc(widget.user.id)
                      .update({
                    "Pic" : photoUrl,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("School Image Updated ! Doing Shortly "),
                    ),
                  );
                },
                child: Container(
                  width : MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image : DecorationImage(
                      image : NetworkImage(widget.user.Pic), fit: BoxFit.cover
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only( top : 90.0, bottom : 10),
                    child: Center(
                      child: InkWell(
                        onTap : () async {
                          Uint8List? _file = await pickImage(ImageSource.gallery);
                          String photoUrl =  await StorageMethods().uploadImageToStorage('users', _file!, true);
                          await FirebaseFirestore.instance
                              .collection('School')
                              .doc(widget.user.id)
                              .update({
                            "Pic_link" : photoUrl,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("School Logo Updated ! Doing Shortly "),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.user.Pic_link),
                          radius: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height : 10),
              ListTile(
                leading: Icon(Icons.circle,color: Colors.black, size: 20),
                title: Text( "Students Functions "),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => On_Off(
                        EmailB: widget.user.EmailB, RegisB: widget.user.RegisB, Other4B: widget.user.Other4B,
                        Other3B: widget.user.Other3B, Other2B: widget.user.Other2B, Other1B: widget.user.Other1B,
                        MotherB: widget.user.MotherB, DepB: widget.user.DepB, BloodB: widget.user.BloodB, school_id: widget.user.id,),
                    ),
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),
                splashColor: Colors.orange.shade300,
                tileColor:  Colors.white ,
              ),
              ListTile(
                  tileColor: Colors.grey.shade50 ,
                leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
                title: Text("Institute Could Edit ?"),
                trailing:  Switch(
                  value: b,
                  onChanged: (value) async {
                    if(b){
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        "On" : false,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Success ! Now NO Teacher could Upload Data from this School'),
                        ),
                      );
                      setState(() {
                        b = value ;
                      });
                    }else{
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        "On" : true,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Success ! Now Every Institution could Upload Data from this School'),
                        ),
                      );
                      setState(() {
                        b = value ;
                      });
                    }
                  }, activeColor: Colors.green,
                ),
              ),

              GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: School_Data_Update(pic: widget.user.Pic_link, school_id: widget.user.id,
                          change_change: 'School Name', to_change: 'Name',) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: s("School Name", widget.user.Name, false, false)),
              s("Your Mail", widget.user.Adminemail, true, true),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: School_Data_Update(pic: widget.user.Pic_link, school_id: widget.user.id,
                          change_change: 'Email', to_change: 'Clientemail',) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: s("School Login Email", widget.user.Clientemail, false, false)),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: School_Data_Update(pic: widget.user.Pic_link, school_id: widget.user.id,
                          change_change: 'Admin Email', to_change: 'Admin_Email',) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: s("School Support Email", widget.user.Email, true, false)),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: School_Data_Update(pic: widget.user.Pic_link, school_id: widget.user.id,
                          change_change: 'Chief Coordinator Name', to_change: 'Chief',) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: s("Chief Coordinator Name", widget.user.Chief, false, false)),
              s("UDISE CODE", widget.user.uidise, true, true),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context, PageTransition(
                        child: School_Data_Update(pic: widget.user.Pic_link, school_id: widget.user.id,
                          change_change: 'Address', to_change: 'Address',) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: s("Address", widget.user.Address, false, false)),
              s("Phone", widget.user.Phone, true, true),
              s("No. of Students", widget.user.Students.toString(), true, true),
              s("Authorize Signature here ", " ", false, true),
              Container(
                width: MediaQuery.of(context).size.width,
                height : 200,
                child : Image.network(widget.user.AuthorizeSignature),
              )
            ],
          ),
        )
    );
  }

  Widget s(String s, String n, bool b, bool f){
    return ListTile(
      leading: f ? Icon(Icons.circle,color: Colors.black, size: 20) : Icon(Icons.edit,color: Colors.red, size: 20),
      title: Text( s + " :"),
      trailing: Text(n, style : TextStyle(fontWeight : FontWeight.w500, fontSize: 15)),
      splashColor: Colors.orange.shade300,
      tileColor: b ? Colors.grey.shade50 : Colors.white,
    );
  }
}


