import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/aextra/session.dart';
import 'package:student_managment_app/model/leave_app.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:flutter/material.dart' ;
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/admin/Student_Data_Update.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/student_shift.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'package:student_managment_app/picture.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class fS extends StatefulWidget {
  SchoolModel user ;
   fS({super.key, required this.user});

  @override
  State<fS> createState() => _fSState();
}

class _fSState extends State<fS> {
  Future<Uint8List?> pickImage( ImageSource source) async {
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
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        final Uint8List data = await croppedFile.readAsBytes();
        final Uint8List compressedData = await compressImage(data);
        return compressedData;
      }
    }
    print('No Image Selected');
    return null;
  }

  Future<Uint8List> compressImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 594,
      minWidth:300,
      quality: 60,
      rotate: 0,
    );
    print('Original length: ${list.length}');
    print('Compressed length: ${result.length}');
    return result;
  }
// Create the list with today's date and the date 4 days later
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 4)),
  ];

  String pic = " ", name = " ", classn = " ", sec = " ", cl = " ", rg = " ",phone=" ", pic12=" ";
bool isUploading = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          title:
          Text("Leave Application", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
      body : Column (
        children : [
          _buildDefaultRangeDatePickerWithValue(),
          pic == " "? ListTile(
            onTap: () async {
              StudentModel u = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SessionJust(id: widget.user.id, student: true, reminder : false, sname : widget.user.Name)),
              );
              print(u.Name);
              setState(() {
                pic = u.pic;
                name = u.Name;
                classn = u.Classn ;
                sec = u.Section ;
                cl = u.Class ;
                rg = u.Registration_number ;
                phone=u.Mobile;
              });
            },
            splashColor: Colors.orange,
            tileColor: Colors.greenAccent.shade100,
            leading: Icon(Icons.dataset_rounded),
            title: Text("Add from School Data",
                style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text("Add from already present Student Data"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ) :
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(pic),
            ),
            title: Text(name,style : TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(cl + " (" + sec + ")"), onTap: (){
              setState(() {
                pic = " ";
              });
          },
            trailing: Icon(Icons.verified, color : Colors.green),
          ),
          ListTile(
            onTap:() async {
              setState(() {
                isUploading = true; // Set to true before starting the upload
              });
              Uint8List? _file = await pickImage(ImageSource.camera);
              String photoUrl = await StorageMethods()
                  .uploadImageToStorage('students', _file!, true);
              setState(() {
                pic12 = photoUrl;
                isUploading = false; // Set back to false after upload is complete
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Application Pic uploaded"),
                ),
              );
            },
            onLongPress:() async {
              setState(() {
                isUploading = true; // Set to true before starting the upload
              });
              Uint8List? _file = await pickImage(ImageSource.gallery);
              String photoUrl = await StorageMethods()
                  .uploadImageToStorage('students', _file!, true);
              setState(() {
                pic12 = photoUrl;
                isUploading = false; // Set back to false after upload is complete
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Application Pic uploaded"),
                ),
              );
            },
            leading:CircleAvatar(
              backgroundColor:Colors.blue,
              child:Icon(Icons.upload,color:Colors.white)
            ),
            title:Text("Upload Application form",style : TextStyle(fontWeight: FontWeight.w600)),
            subtitle:Text("Single press for Camera, Long press for Gallery"),
            trailing : pic12==" "?SizedBox(): Icon(Icons.verified, color : Colors.green),
          ),
         isUploading?Center(
           child:  CircularProgressIndicator()
         ) :Padding(
              padding: const EdgeInsets.all(15.0),
              child: SocialLoginButton(
                backgroundColor: (pic==" "||pic12==" ")?Colors.grey: Color(0xff50008e),
                height: 40,
                text: 'Mark Leave ',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  if(pic==" "||pic12==" "){
                    print(pic);
                    print(pic12);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Add Student Data as well as Upload Application Form"),
                      ),
                    );
                    return ;
                  }
                  List j = _generateFormattedDatesInRange( _rangeDatePickerValueWithDefaultValue[0]!  ,
                      _rangeDatePickerValueWithDefaultValue[1]!);
                  print(j);
                  try{
                    _generate( _rangeDatePickerValueWithDefaultValue[0]!  ,
                        _rangeDatePickerValueWithDefaultValue[1]!, rg);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error puttind data in calender"),
                      ),
                    );
                  }
                  try{
                    DateTime my= _rangeDatePickerValueWithDefaultValue[0]!;
                    String year = DateFormat('yyyy').format(my);
                    String month = DateFormat('MM').format(my);
                    String uid = my.microsecondsSinceEpoch.toString();
                    LeaveApp yu = LeaveApp(stName: name, stClass: classn, stSession: widget.user.csession,
                        stId: rg, stPic: pic, startDate: _rangeDatePickerValueWithDefaultValue[0]!.toString(),
                        endDate: _rangeDatePickerValueWithDefaultValue[1]!.toString(), month: month,
                        year: year, appPhoto: pic12, stClassName: uid, stPhone: phone
                    );
                    await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                        .collection("Session")
                        .doc(widget.user.csession).collection("Leave").doc(uid)
                        .set(yu.toJson());
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error ! ${e}"),
                      ),
                    );
                  }
                  try{
                    await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                        .collection("Session")
                        .doc(widget.user.csession).collection("Class").doc(classn).collection("Student").doc(rg)
                        .update({
                      'Leave': FieldValue.arrayUnion(j),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(name + " is set as Leave on the Following Days Success !"),
                      ),
                    );

                    Navigator.pop(context);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error ! Either the Student is not from current session or have bad Registration ID"),
                      ),
                    );
                  }

                }
              ),
            ),
        ]
      )
    );
  }
  void _generate(DateTime start, DateTime end, String reg) async {
    List<String> formattedDates = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime currentDate = DateTime(start.year, start.month, start.day + i);

      // Manually format the date without leading zeros
      String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
      formattedDates.add(formattedDate); // Add the formatted date to the list

      // Use the formatted date in Firestore
      String sj = DateTime.now().microsecondsSinceEpoch.toString();
      await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
          .collection("Students")
          .doc(reg)
          .collection("Colors")
          .doc(formattedDate)
          .set({
        'color': Colors.green.value,
        'date': currentDate, // Save the formatted date
        'st': formattedDate,
      });
    }
  }


  List<String> _generateFormattedDatesInRange(DateTime start, DateTime end) {
    List<String> formattedDates = [];

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime currentDate = DateTime(start.year, start.month, start.day + i);
      String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
      formattedDates.add(formattedDate);
    }

    return formattedDates;
  }

  Widget _buildDefaultRangeDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          value: _rangeDatePickerValueWithDefaultValue,
          onValueChanged: (dates) =>
              setState(() => _rangeDatePickerValueWithDefaultValue = dates),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _rangeDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
  String _getValueText(CalendarDatePicker2Type datePickerType, List<DateTime?> values,) {
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
}



class LSee extends StatefulWidget {
  SchoolModel user;

  LSee({super.key, required this.user});

  @override
  State<LSee> createState() => _LSeeState();
}

class _LSeeState extends State<LSee> {
  List<LeaveApp> list = [];

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
        title: Text('Students on Leave', style: TextStyle(color: Colors.white)),
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
              stream: FirebaseFirestore.instance.collection('School').doc(widget.user.id).
              collection("Session").doc(widget.user.csession)
                  .collection('Leave').where("year",isEqualTo:selectedValue)
                  .snapshots(),
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
                        data?.map((e) => LeaveApp.fromJson(e.data())).toList() ?? [];
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
                          return ChatUserL(user: list[index], id: widget.user.id, session: widget.user.csession,);
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

class ChatUserL extends StatelessWidget {
    ChatUserL({super.key, required this.user,required this.id,required this.session});
    String id, session;
  LeaveApp user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        try {
          // Reference to the 'users' collection
          CollectionReference usersCollection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(session).collection("Class").doc(user.stClass).collection("Student");
          // Query the collection based on uid
          QuerySnapshot querySnapshot = await usersCollection.where('Registration_number', isEqualTo: user.stId).get();
          // Check if a document with the given uid exists
          if (querySnapshot.docs.isNotEmpty) {
            // Convert the document snapshot to a UserModel
            StudentModel user1 = StudentModel.fromSnap(querySnapshot.docs.first);
            Navigator.push(
                context,
                PageTransition(
                    child: StudentProfile(user: user1, parent: false, str: '',
                      class_id: user.stClass, session_id: user.stSession, school_id: '',),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200)));
          } else {
            // No document found with the given uid
            return null;
          }
        } catch (e) {
          print("Error fetching user by uid: $e");
          return null;
        }
      },
      leading: CircleAvatar(
        backgroundImage:NetworkImage(user.stPic),
      ),
      title: Text(user.stName , style : TextStyle(fontWeight : FontWeight.w900, fontSize: 20 )),
      subtitle: Text("From ${yuuu(user.startDate)} to ${yuuu(user.endDate)}", style : TextStyle(fontWeight : FontWeight.w500, fontSize: 14)),
      trailing: Container(
        width:100,
        child:Row(
          mainAxisAlignment:MainAxisAlignment.end,
          children:[
            InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Pic(str: user.appPhoto,
                              name: "Application Pic for "+user.stName),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 400)));
                },
                child: Icon(Icons.image,color:Colors.blue,size:30)),
            SizedBox(width:15),
            Icon(Icons.arrow_forward_ios_outlined),
          ]
        )
      )
    );
  }
  String yuuu(String as){
    DateTime dateTime = DateTime.parse(as);

    // Format the DateTime to get the day and month
    String day = DateFormat('dd').format(dateTime);
    String month = DateFormat('MMMM').format(dateTime);
    return day+"th "+month;
  }
}