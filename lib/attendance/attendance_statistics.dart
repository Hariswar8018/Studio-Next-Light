import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:page_transition/page_transition.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/attendance/attendace_statistics_pdf.dart';
import 'package:student_managment_app/attendance/single_attendance.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_to_pdf/flutter_to_pdf.dart';

class StudentsJust8 extends StatefulWidget {
  String id;
  String session_id;
  String class_id;

  String name , sname, cname, csection ;

  StudentsJust8({
    super.key, required this.name, required this.csection, required this.cname, required this.sname,
    required this.id,
    required this.session_id,
    required this.class_id,
  });

  @override
  State<StudentsJust8> createState() => _StudentsJust8State();
}

class _StudentsJust8State extends State<StudentsJust8> {
  List<StudentModel> list = [];

  late Map<String, dynamic> userMap;

  @override
  void dispose() {
    // Reset orientations when exiting the screen

    super.dispose();
  }

  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    int Mo = now.month;
    int Ye = now.year;
    i = 0;
    setState(() {
    selectedValue = Ye.toString();
    });
    setState(() {

    if( Mo < 10){
    mo = "0" + Mo.toString();
    }else{
    mo = Mo.toString();
    }

    });
  }

  final List<String> items = [
    '2019',
    '2020',
    '2021',
    '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029',
  ];
  final List<String> items1 = [
    '01',
    '02',
    '03',
    '04', // This value is causing the error
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  TextEditingController ud = TextEditingController();
  String selectedValue = "2023";
  String mo = "1";

  final ExportDelegate exportDelegate = ExportDelegate();
  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text("Hello World", style: pw.TextStyle(font: ttf)),
        ),
      ),
    );

    return pdf;
  }

  Future<String?> saveFile( document, String name) async {
    try {
      final Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        final String downloadsPath = '${dir.path}';
        final String filePath = '$downloadsPath/$name.pdf';

        final File file = File(filePath);
        await file.writeAsBytes(await document.save());

        debugPrint('Saved exported PDF at: $filePath');
        return filePath;
      } else {
        debugPrint('Could not access external storage directory.');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  final Fire = FirebaseFirestore.instance;
  final GlobalKey boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor:  Colors.deepPurple,
          title: Text('Students Data'),
          actions: [
            Container
              (height: 60, width: MediaQuery
                .of(context)
                .size
                .width, color: Colors.deepPurple.shade200,
                child: Center(
                    child: Row(
                        children: [
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 2 - 20,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Year',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                ),
                                items: items
                                    .map((String item) =>
                                    DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 2 -  20,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Month',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                ),
                                items: items1
                                    .map((String item) =>
                                    DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black
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
                          ),
                          IconButton(
                            onPressed : () async {
                              try{
                                ScaffoldMessenger.of(context).showSnackBar(

                                  SnackBar(
                                    content: Text(
                                        'Exporting....'),
                                  ),
                                );
                                await downloadCollection(list);
                                ScaffoldMessenger.of(context).showSnackBar(

                                  SnackBar(
                                    content: Text(
                                        'Done ! File saved '),
                                  ),
                                );
                              }catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(

                                  SnackBar(
                                    content: Text(
                                        '${e}'),
                                  ),
                                );
                              }
                            },
                            icon : Icon(Icons.download)
                          ),
                        ]
                    )
                )
            ),
          ]
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Download PDF now' ,
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              try {
                // Reference to the 'users' collection
                CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                // Query the collection based on uid
                QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: widget.id).get();
                // Check if a document with the given uid exists
                if (querySnapshot.docs.isNotEmpty) {
                  // Convert the document snapshot to a UserModel
                  SchoolModel userr = SchoolModel.fromSnap(querySnapshot.docs.first);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MyFRr( list: list, u: i.toInt(), selectedValue: selectedValue, mo: mo, name: widget.name,
                            csection: widget.csection, cname: widget.cname, sname: widget.sname, sch: userr,
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                } else {
                  // No document found with the given uid
                  return null;
                }
              } catch (e) {
                print("Error fetching user by uid: $e");
                return null;
              }

            },
          ),
        ),
      ],
      body: ExportFrame(
        frameId: 'someFrameId',
        exportDelegate: exportDelegate,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                // Add border to the table
                columnWidths: {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                  6: FlexColumnWidth(1),
                  7: FlexColumnWidth(1),
                  8: FlexColumnWidth(1),
                  9: FlexColumnWidth(1),
                  10: FlexColumnWidth(1),
                  11: FlexColumnWidth(1),
                  12: FlexColumnWidth(1),
                  13: FlexColumnWidth(1),
                  14: FlexColumnWidth(1),
                  15: FlexColumnWidth(1),
                  16: FlexColumnWidth(1),
                  17: FlexColumnWidth(1),
                  18: FlexColumnWidth(1),
                  19: FlexColumnWidth(1),
                  20: FlexColumnWidth(1),
                  21: FlexColumnWidth(1),
                  22: FlexColumnWidth(1),
                  23: FlexColumnWidth(1),
                  24: FlexColumnWidth(1),
                  25: FlexColumnWidth(1),
                  26: FlexColumnWidth(1),
                  27: FlexColumnWidth(1),
                  28: FlexColumnWidth(1),
                  29: FlexColumnWidth(1),
                  30: FlexColumnWidth(1),
                  31: FlexColumnWidth(1),
                  32: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors
                            .black), // Add border to the bottom of the row
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("1")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("2")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("3")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("4")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("5")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("6")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("7")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("8")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("9")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("10")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("11")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("12")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("13")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("14")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("15")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("16")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("17")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("18")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("19")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("20")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("21")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("22")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("23")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("24")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("25")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("26")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("27")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("28")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("29")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("30")
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("31")
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Fire.collection('School')
                    .doc(widget.id)
                    .collection('Session')
                    .doc(widget.session_id)
                    .collection("Class")
                    .doc(widget.class_id)
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
                      list =
                          data?.map((e) => StudentModel.fromJson(e.data()))
                              .toList() ??
                              [];
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(top: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser(
                            user: list[index],
                            id: widget.id,
                            session_id: widget.session_id,
                            class_id: widget.class_id,
                            length: list.length,
                            year: selectedValue,
                            month: mo,
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future downloadCollection(List<StudentModel>? docs) async{
    docs = docs ?? [] ;
    String fileContent = "name, brand";
    List<List<dynamic>> rows = [];
    rows.add([" "]);
    rows.add(["School", widget.name, " ", "Session", widget.sname]);
    rows.add(["Class", widget.cname, " ", "Section", widget.csection ]);
    rows.add([" "]);
    rows.add([" "]);
    rows.add(["Name", "1", "2", "3", "4", "5", "6", "7",
      "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27",
      "28", "29", "30", "31"
    ]);
    docs.asMap().forEach((index, record){
      fileContent = fileContent + "\n" +record.Name.toString() + "," + record.Pic_Name.toString();
      print("\n" +record.Name.toString() + "," + record.Pic_Name.toString());
      rows.add([record.Name,
        sd(1, record ), sd(2, record ), sd(3, record ), sd(4, record ), sd(5, record ), sd(6, record ), sd(7, record ), sd(8, record ), sd(9, record ), sd(10, record ),
        sd(11, record ), sd(12, record ), sd(13, record ), sd(14, record ), sd(15, record ), sd(16, record ), sd(17, record ), sd(18, record ), sd(19, record ), sd(20, record ),
        sd(21, record ), sd(22, record ), sd(23, record ), sd(24, record ), sd(25, record ), sd(26, record ), sd(27, record ), sd(28, record ), sd(29, record ), sd(30, record ), sd(31, record )
      ]);
    } );
    print(rows);
    String csv = const ListToCsvConverter().convert(rows);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      String dir = (await getExternalStorageDirectory())!.path;
      String filePath2 = "$dir/id_${widget.class_id}_list.csv";
      File fileb = File(filePath2);
      await fileb.writeAsString(csv);
      print("File saved ");
      try{
      Directory appDocDir = await getApplicationDocumentsDirectory();

      String customDirectory = '${appDocDir.path}/Esd';

      Directory(customDirectory).create(recursive: true);

      String filePath = '$customDirectory/${widget.class_id}_list.csv';

      File file = File(filePath);
      await file.writeAsString(csv);
      }
          catch(e){
        print(e);
          }
    } else {
      print("Permission denied for storage.");
    }

  }

  String sd(int y, StudentModel s6){
    int gh = int.parse(mo);
    String g = " ";
    if (y < 10) {
      g = "0${y.toString()}";
    } else {
      g = y.toString();
    }
    String s = "${selectedValue}-${mo}-${g} 19:52:55.245586";
    if (isSunday(s)) {
      return " ";
    }
    else if (s6.present.contains("${y.toString()}-${gh.toString()}-${selectedValue}")) {
      return "P";
    } else {
      return "A";
    }
  }
  bool isSunday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.weekday == DateTime.sunday;
  }

  late int i;
}


class ChatUser extends StatefulWidget {
  StudentModel user;
  int length;

  String id;

  String session_id;
  String class_id;
  String year;

  String month;

  ChatUser({
    super.key,
    required this.user,
    required this.length, required this.year, required this.month,
    required this.id,
    required this.session_id,
    required this.class_id,
  });

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  bool rem = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left : 8.0, right : 8, bottom : 3),
      child: InkWell(
        onTap : (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Sd(user: widget.user,),
            ),
          );
        },
        child: Table(
          border: TableBorder.all(color: Colors.black), // Add border to the table
          columnWidths: {
            0: FlexColumnWidth(5),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
            7: FlexColumnWidth(1),
            8: FlexColumnWidth(1),
            9: FlexColumnWidth(1),
            10: FlexColumnWidth(1),
            11: FlexColumnWidth(1),
            12: FlexColumnWidth(1),
            13: FlexColumnWidth(1),
            14: FlexColumnWidth(1),
            15: FlexColumnWidth(1),
            16: FlexColumnWidth(1),
            17: FlexColumnWidth(1),
            18: FlexColumnWidth(1),
            19: FlexColumnWidth(1),
            20: FlexColumnWidth(1),
            21: FlexColumnWidth(1),
            22: FlexColumnWidth(1),
            23: FlexColumnWidth(1),
            24: FlexColumnWidth(1),
            25: FlexColumnWidth(1),
            26: FlexColumnWidth(1),
            27: FlexColumnWidth(1),
            28: FlexColumnWidth(1),
            29: FlexColumnWidth(1),
            30: FlexColumnWidth(1),
            31: FlexColumnWidth(1),
            32: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.black), // Add border to the bottom of the row
                ),
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.user.Name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(1)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(2)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(3)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(4)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(5)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(6)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(7)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(8)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(9)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(10)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(11)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(12)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(13)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(14)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(15)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(16)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(17)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(18)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(19)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(20)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(21)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(22)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(23)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(24)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(25)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(26)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(27)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(28)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(29)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(30)
                  ),
                ),
                TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: re(31)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget re(int y) {
   int gh = int.parse(widget.month);
    String g = " ";
    if (y < 10) {
      g = "0${y.toString()}";
    } else {
      g = y.toString();
    }
    String s = "${widget.year}-${widget.month}-${g} 19:52:55.245586";
    if (isSunday(s)) {
      return Text(" ", style: TextStyle(
          fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w800));
    }
    else if (widget.user.present.contains("${y.toString()}-${gh.toString()}-${widget.year}")) {
      return Text("P", style: TextStyle(
          fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w800));
    } else if(widget.user.Leave.contains("${y.toString()}-${gh.toString()}-${widget.year}")) {
      return Text("L", style: TextStyle(
          fontSize: 20, color: Colors.purpleAccent, fontWeight: FontWeight.w800));
    }
    else{
        return Text("A", style: TextStyle(fontSize: 15, color: Colors.red));
      }
  }

  bool isSunday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.weekday == DateTime.sunday;
  }

  // Function to check if the given date is a holiday (You need to implement your own logic here

  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) +
          ',' +
          formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    return formattedNumber;
  }


}
