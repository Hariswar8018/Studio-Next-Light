import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/model/fee.dart';
import 'package:student_managment_app/model/student_model.dart';
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
import 'package:student_managment_app/admin/Student_Data_Update.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/student_shift.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/attendance/single_attendance.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:student_managment_app/model/school_model.dart';

class MyFRr extends StatefulWidget {
  List<StudentModel> list = [];
  SchoolModel sch;
  int u;
  String name, sname, cname, csection;
  var selectedValue;
  String mo;
  MyFRr({
    super.key,
    required this.list,
    required this.u,
    required this.sch,
    required this.selectedValue,
    required this.mo,
    required this.name,
    required this.csection,
    required this.cname,
    required this.sname,
  });

  @override
  State<MyFRr> createState() => _MyFRrState();
}

class _MyFRrState extends State<MyFRr> {
  DateTime now = DateTime.now();


  Widget se(double w,int op) {
    return Container(
      width: w/48,
      height: 20,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.2),
          color: Colors.white),
      child: Center(
          child: Text(op.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: w/65,
                  fontWeight: FontWeight.w800))),
    );
  }

  Widget st(double w,String h) {
    return Container(
        width: w/48,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2)),
        child: Center(
            child: Text(h.toString(),
                style: TextStyle(
                    color: h == "P" ? Colors.blue : Colors.red,
                    fontSize: w/55,
                    fontWeight: FontWeight.w800))));
  }

  bool up = false;

  int i = 1;
  double lowerValue = 1;
  double upperValue = 2;

  List<int> rowCounts = [];
  List<int> columnCounts = List.filled(31, 0);
void as(){
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        height: 210,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 10),
                Text("Filter No. of Students",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize:20)),
                FlutterSlider(
                  values: [lowerValue, upperValue],
                  max: widget.list.length.toDouble(),
                  min: 1,
                  rangeSlider: true,
                  onDragging: (handlerIndex, lower, upper) {
                    setState(() {
                      lowerValue = lower;
                      upperValue = upper;
                    });
                  },
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SocialLoginButton(
                    backgroundColor: Colors.blue,
                    height: 40,
                    text: 'Okay :)',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

}
int opp=0;
  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }
  String mui(String str){
    int iu=16;
    if(str.length>iu){
      return str.substring(0,iu);
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int startIndex = lowerValue.round() - 1;
    int endIndex = upperValue.round() - 1;
    calculateCounts();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            actions:[
              IconButton(onPressed:()=>as(), icon: Icon(Icons.settings_input_component))
            ],
            title: Text("Class Attendance Report")),
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
                try {
                  // export the frame to a PDF Page
                  final ExportOptions overrideOptions = ExportOptions(
                    textFieldOptions: TextFieldOptions.uniform(
                      interactive: false,
                    ),
                    pageFormatOptions:
                    PageFormatOptions.custom(width: w, height: w*1.35,
                        clip: true,marginAll: 0,marginBottom: 0,marginLeft: 0,marginRight: 0,marginTop: 0),
                    checkboxOptions: CheckboxOptions.uniform(
                      interactive: false,
                    ),
                  );
                  final pdf = await exportDelegate.exportToPdfDocument(
                      "someFrameId",
                      overrideOptions: overrideOptions);
                  final filePath = await saveFile(pdf, widget.name + "( $opp )"+ " Attendance");
                  opp+=1;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Success ! File saved on Android>Data>com.starwish.student>data>My.pdf'),
                    ),
                  );
                  if (filePath != null) {
                    Share.shareXFiles([XFile(filePath)],
                        text: 'Here is your PDF file.');
                  }
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e}'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
        body: ExportFrame(
            frameId: 'someFrameId',
            exportDelegate: exportDelegate,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 2)),
                width: w,
                height: w*1.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color:Color(0xff00CE9D),
                      width: w,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 10,),
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.sch.Pic_link),
                            radius: w/14,
                          ),
                          SizedBox(width: 12,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.sch.Name,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w900,fontSize: w/27)),
                              Text("Attendance for : "+"${widget.selectedValue} / "+widget.mo,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w800,fontSize: w/32)),
                              Text("Class : "+widget.cname+ " ("+widget.csection+")                   Total Students :- ${widget.list.length}",style:TextStyle(color:Colors.white,fontWeight: FontWeight.w600,fontSize: w/31)),

                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: w,
                      height: 2,
                      color:Colors.black,
                    ),
                    s(),
                    Text("ATTENDANCE SHEET",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: w/31,
                            wordSpacing: 2,
                            letterSpacing: 5)),

                    s(),
                    Container(
                      color: Colors.white,
                      width: w - 30,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                              width: w / 2 - 110,
                              height: 20,
                              color: Colors.blue,
                              child: Text("  Name",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: w/40))),
                          se(w,1), se(w,2), se(w,3), se(w,4), se(w,5), se(w,6),
                          se(w,7), se(w,8), se(w,9),se(w,10), se(w,11),
                          se(w,12), se(w,13),
                          se(w,14), se(w,15), se(w,16), se(w,17), se(w,18), se(w,19),
                          se(w,20), se(w,21), se(w,22),
                          se(w,23), se(w,24),
                          se(w,25),
                          se(w,26),
                          se(w,27),
                          se(w,28),
                          se(w,29),
                          se(w,30),
                          se(w,31),
                          SizedBox(width: 0.2,),
                          Container(
                              width: w/48,
                              height: 20,
                              decoration: BoxDecoration(
                                  color:Colors.blue,
                                  border: Border.all(color: Colors.black, width: 0.2)),
                              child: Center(
                                  child: Text( "T",
                                      style: TextStyle(
                                          color:  Colors.white,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w800)))),
                          Container(
                              width: w/48,
                              height: 20,
                              decoration: BoxDecoration(
                                  color:Colors.red,
                                  border: Border.all(color: Colors.black, width: 0.2)),
                              child: Center(
                                  child: Text( "A",
                                      style: TextStyle(
                                          color:  Colors.white,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w800)))),
                        ],
                      ),
                    ),
                    Container(
                      height: (endIndex - startIndex + 1) * 15.0,
                      width: w,
                      child: ListView.builder(
                        itemCount: endIndex - startIndex + 1,
                        itemBuilder: (context, index) {
                          int actualIndex = startIndex + index;
                          return Padding(
                            padding: const EdgeInsets.only(left: 13.0, right: 13),
                            child: Container(
                              color: Colors.white,
                              width: w - 30,
                              height: 15,
                              child: Row(
                                children: [
                                  Container(
                                      width: w / 2 - 110,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 0.2),
                                          color: Colors.white),
                                      child: Text(
                                          " ${actualIndex+1}. ${mui(widget.list[actualIndex].Name)}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w/56))),
                                  st(w,sd(1, widget.list[actualIndex])),
                                  st(w,sd(2, widget.list[actualIndex])),
                                  st(w,sd(3, widget.list[actualIndex])),
                                  st(w,sd(4, widget.list[actualIndex])),
                                  st(w,sd(5, widget.list[actualIndex])),
                                  st(w,sd(6, widget.list[actualIndex])),
                                  st(w,sd(7, widget.list[actualIndex])),
                                  st(w,sd(8, widget.list[actualIndex])),
                                  st(w,sd(9, widget.list[actualIndex])),
                                  st(w,sd(10, widget.list[actualIndex])),
                                  st(w,sd(11, widget.list[actualIndex])),
                                  st(w,sd(12, widget.list[actualIndex])),
                                  st(w,sd(13, widget.list[actualIndex])),
                                  st(w,sd(14, widget.list[actualIndex])),
                                  st(w,sd(15, widget.list[actualIndex])),
                                  st(w,sd(16, widget.list[actualIndex])),
                                  st(w,sd(17, widget.list[actualIndex])),
                                  st(w,sd(18, widget.list[actualIndex])),
                                  st(w,sd(19, widget.list[actualIndex])),
                                  st(w,sd(20, widget.list[actualIndex])),
                                  st(w,sd(21, widget.list[actualIndex])),
                                  st(w,sd(22, widget.list[actualIndex])),
                                  st(w,sd(23, widget.list[actualIndex])),
                                  st(w,sd(24, widget.list[actualIndex])),
                                  st(w,sd(25, widget.list[actualIndex])),
                                  st(w,sd(26, widget.list[actualIndex])),
                                  st(w,sd(27, widget.list[actualIndex])),
                                  st(w,sd(28, widget.list[actualIndex])),
                                  st(w,sd(29, widget.list[actualIndex])),
                                  st(w,sd(30, widget.list[actualIndex])),
                                  st(w,sd(31, widget.list[actualIndex])),
                                  SizedBox(width: 0.2,),
                                  Container(
                                      width: w/48,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.black, width: 0.2)),
                                      child: Center(
                                          child: Text(rowCounts[actualIndex].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6,
                                                  fontWeight: FontWeight.w800)))),
                                  Container(
                                      width: w/48,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.all(color: Colors.black, width: 0.2)),
                                      child: Center(
                                          child: Text((31-rowCounts[actualIndex]).toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6,
                                                  fontWeight: FontWeight.w800)))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: w - 30,
                      height: 16,
                      child: Row(
                        children: [
                          Container(
                              width: w / 2 - 110,
                              height: 16,
                              color: Colors.blue,
                              child: Text(" Per Day ( P )",
                                  style: TextStyle(color: Colors.white, fontSize: w/43))),
                          for (int i = 0; i < columnCounts.length; i++)
                            Container(
                              width: w/48,
                              height: 16,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 0.2),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(columnCounts[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w/68,
                                          fontWeight: FontWeight.w800))),
                            ),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: w - 30,
                      height: 16,
                      child: Row(
                        children: [
                          Container(
                              width: w / 2 - 110,
                              height: 16,
                              color: Colors.red.shade400,
                              child: Text(" Per Day ( A )",
                                  style: TextStyle(color: Colors.white, fontSize: w/43))),
                          for (int i = 0; i < columnCounts.length; i++)
                            Container(
                              width: w/48,
                              height: 16,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 0.2),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(((endIndex-startIndex)-columnCounts[i]+1).toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w/68,
                                          fontWeight: FontWeight.w800))),
                            ),

                        ],
                      ),
                    ),
                    Spacer(),
            ( widget.list.length>=(upperValue-1).toDouble())?Row(
                      children: [
                        ss(),
                        ss(),
                        Text("Thanks",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: w/34)),
                        Spacer(),
                        Text("Teacher Signature",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: w/34)),
                        ss(),
                        ss(),
                      ],
                    ):SizedBox(),
                    InkWell(
                      onTap:(){
                        print(widget.list.length);
                        print(upperValue);
                      },
                      child:Container(
                        color: Color(0xff00CE9D),
                        width: w - 40,
                        height: 5,
                      ),
                    ),

                    s(),
                    s(),
                  ],
                ))));
  }
  final ExportDelegate exportDelegate = ExportDelegate();

  Future<String?> saveFile(document, String name) async {
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
  void calculateCounts() {
    rowCounts.clear();
    columnCounts = List.filled(31, 0);

    for (var student in widget.list) {
      int rowCount = 0;

      for (int day = 1; day <= 31; day++) {
        String attendance = sd(day, student);
        if (attendance == "P") {
          rowCount++;
          columnCounts[day - 1]++;
        }
      }

      rowCounts.add(rowCount);
    }
  }

  var dict = {"dic": 3};

  String sd(int y, StudentModel s6) {
    int gh = int.parse(widget.mo);
    String g = " ";
    if (y < 10) {
      g = "0${y.toString()}";
    } else {
      g = y.toString();
    }
    String s = "${widget.selectedValue}-${widget.mo}-${g} 19:52:55.245586";
    if (isSunday(s)) {
      return " ";
    } else if (s6.present
        .contains("${y.toString()}-${gh.toString()}-${widget.selectedValue}")) {
      return "P";
    } else {
      return "A";
    }
  }

  Widget r(String s, String s2, String s3, String s4) {
    return Row(
      children: [
        ss(),
        ss(),
        t1("$s - " + s2),
        Spacer(),
        t1("$s3 - " + s4),
        ss(),
        ss(),
      ],
    );
  }

  bool isSunday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.weekday == DateTime.sunday;
  }

  Widget s() => SizedBox(height: 10);

  Widget ss() => SizedBox(width: 10);

  Widget t1(String s) =>
      Text(s, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14));


}


/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/model/fee.dart';
import 'package:student_managment_app/model/student_model.dart';
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
import 'package:student_managment_app/admin/Student_Data_Update.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/student_shift.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/attendance/single_attendance.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:student_managment_app/model/school_model.dart';

class MyFRr extends StatefulWidget {
  List<StudentModel> list = [];
  int u;
  String name, sname, cname, csection;
  var selectedValue;
  String mo;
  MyFRr({
    super.key,
    required this.list,
    required this.u,
    required this.selectedValue,
    required this.mo,
    required this.name,
    required this.csection,
    required this.cname,
    required this.sname,
  });

  @override
  State<MyFRr> createState() => _MyFRrState();
}

class _MyFRrState extends State<MyFRr> {
  DateTime now = DateTime.now();


  Widget se(double w,int op) {
    return Container(
      width: w/48,
      height: 20,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.2),
          color: Colors.white),
      child: Center(
          child: Text(op.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: w/65,
                  fontWeight: FontWeight.w800))),
    );
  }

  Widget st(double w,String h) {
    return Container(
        width: w/48,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2)),
        child: Center(
            child: Text(h.toString(),
                style: TextStyle(
                    color: h == "P" ? Colors.blue : Colors.red,
                    fontSize: w/55,
                    fontWeight: FontWeight.w800))));
  }

  bool up = false;

  int i = 1;
  double lowerValue = 1;
  double upperValue = 2;

  List<int> rowCounts = [];
  List<int> columnCounts = List.filled(31, 0);
  void as(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 210,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("Filter No. of Students",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize:20)),
                  FlutterSlider(
                    values: [lowerValue, upperValue],
                    max: widget.list.length.toDouble(),
                    min: 1,
                    rangeSlider: true,
                    onDragging: (handlerIndex, lower, upper) {
                      setState(() {
                        lowerValue = lower;
                        upperValue = upper;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SocialLoginButton(
                      backgroundColor: Colors.blue,
                      height: 40,
                      text: 'Okay :)',
                      borderRadius: 20,
                      fontSize: 21,
                      buttonType: SocialLoginButtonType.generalLogin,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }
  int opp=0;
  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int startIndex = lowerValue.round() - 1;
    int endIndex = upperValue.round() - 1;
    calculateCounts();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            actions:[
              IconButton(onPressed:()=>as(), icon: Icon(Icons.settings_input_component))
            ],
            title: Text("Class Attendance Report")),
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
                try {
                  // export the frame to a PDF Page
                  final ExportOptions overrideOptions = ExportOptions(
                    textFieldOptions: TextFieldOptions.uniform(
                      interactive: false,
                    ),
                    pageFormatOptions:
                    PageFormatOptions.custom(width: w, height: w*1.35,
                        clip: true,marginAll: 0,marginBottom: 0,marginLeft: 0,marginRight: 0,marginTop: 0),
                    checkboxOptions: CheckboxOptions.uniform(
                      interactive: false,
                    ),
                  );
                  final pdf = await exportDelegate.exportToPdfDocument(
                      "someFrameId",
                      overrideOptions: overrideOptions);
                  final filePath =
                  await saveFile(pdf, widget.name + "( $opp )"+ " Attendance");
                  opp+=1;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Success ! File saved on Android>Data>com.starwish.student>data>My.pdf'),
                    ),
                  );
                  if (filePath != null) {
                    Share.shareXFiles([XFile(filePath)],
                        text: 'Here is your PDF file.');
                  }
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e}'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
        body: ExportFrame(
            frameId: 'someFrameId',
            exportDelegate: exportDelegate,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 2)),
                width: w,
                height: w*1.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w,
                      height: 30,
                      color: Colors.black,
                    ),
                    s(),
                    s(),
                    Text("ATTENDANCE SHEET",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            wordSpacing: 2,
                            letterSpacing: 5)),
                    s(),s(),
                    r("Class Name ", " Class " + widget.cname, "Date",
                        now.day.toString() +
                            "/" +
                            now.month.toString() +
                            "/" +
                            now.year.toString()),
                    r("Section", widget.csection, "Time",
                        now.hour.toString() + ":" + now.minute.toString()),
                    r("Attendance for","${widget.selectedValue}, ${widget.mo}", "Total Students",
                        widget.list.length.toString()),
                    s(),
                    Container(
                      color: Colors.white,
                      width: w - 30,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                              width: w / 2 - 110,
                              height: 20,
                              color: Colors.blue,
                              child: Text("  Name",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: w/40))),
                          se(w,1), se(w,2), se(w,3), se(w,4), se(w,5), se(w,6),
                          se(w,7), se(w,8), se(w,9),se(w,10), se(w,11),
                          se(w,12), se(w,13),
                          se(w,14), se(w,15), se(w,16), se(w,17), se(w,18), se(w,19),
                          se(w,20), se(w,21), se(w,22),
                          se(w,23), se(w,24),
                          se(w,25),
                          se(w,26),
                          se(w,27),
                          se(w,28),
                          se(w,29),
                          se(w,30),
                          se(w,31),
                          SizedBox(width: 0.2,),
                          Container(
                              width: w/48,
                              height: 20,
                              decoration: BoxDecoration(
                                  color:Colors.blue,
                                  border: Border.all(color: Colors.black, width: 0.2)),
                              child: Center(
                                  child: Text( "T",
                                      style: TextStyle(
                                          color:  Colors.white,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w800)))),
                          Container(
                              width: w/48,
                              height: 20,
                              decoration: BoxDecoration(
                                  color:Colors.red,
                                  border: Border.all(color: Colors.black, width: 0.2)),
                              child: Center(
                                  child: Text( "A",
                                      style: TextStyle(
                                          color:  Colors.white,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w800)))),
                        ],
                      ),
                    ),
                    Container(
                      height: (endIndex - startIndex + 1) * 15.0,
                      width: w,
                      child: ListView.builder(
                        itemCount: endIndex - startIndex + 1,
                        itemBuilder: (context, index) {
                          int actualIndex = startIndex + index;
                          return Padding(
                            padding: const EdgeInsets.only(left: 13.0, right: 13),
                            child: Container(
                              color: Colors.white,
                              width: w - 30,
                              height: 15,
                              child: Row(
                                children: [
                                  Container(
                                      width: w / 2 - 110,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 0.2),
                                          color: Colors.white),
                                      child: Text(
                                          "  ${widget.list[actualIndex].Name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w/49))),
                                  st(w,sd(1, widget.list[actualIndex])),
                                  st(w,sd(2, widget.list[actualIndex])),
                                  st(w,sd(3, widget.list[actualIndex])),
                                  st(w,sd(4, widget.list[actualIndex])),
                                  st(w,sd(5, widget.list[actualIndex])),
                                  st(w,sd(6, widget.list[actualIndex])),
                                  st(w,sd(7, widget.list[actualIndex])),
                                  st(w,sd(8, widget.list[actualIndex])),
                                  st(w,sd(9, widget.list[actualIndex])),
                                  st(w,sd(10, widget.list[actualIndex])),
                                  st(w,sd(11, widget.list[actualIndex])),
                                  st(w,sd(12, widget.list[actualIndex])),
                                  st(w,sd(13, widget.list[actualIndex])),
                                  st(w,sd(14, widget.list[actualIndex])),
                                  st(w,sd(15, widget.list[actualIndex])),
                                  st(w,sd(16, widget.list[actualIndex])),
                                  st(w,sd(17, widget.list[actualIndex])),
                                  st(w,sd(18, widget.list[actualIndex])),
                                  st(w,sd(19, widget.list[actualIndex])),
                                  st(w,sd(20, widget.list[actualIndex])),
                                  st(w,sd(21, widget.list[actualIndex])),
                                  st(w,sd(22, widget.list[actualIndex])),
                                  st(w,sd(23, widget.list[actualIndex])),
                                  st(w,sd(24, widget.list[actualIndex])),
                                  st(w,sd(25, widget.list[actualIndex])),
                                  st(w,sd(26, widget.list[actualIndex])),
                                  st(w,sd(27, widget.list[actualIndex])),
                                  st(w,sd(28, widget.list[actualIndex])),
                                  st(w,sd(29, widget.list[actualIndex])),
                                  st(w,sd(30, widget.list[actualIndex])),
                                  st(w,sd(31, widget.list[actualIndex])),
                                  SizedBox(width: 0.2,),
                                  Container(
                                      width: w/48,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.black, width: 0.2)),
                                      child: Center(
                                          child: Text(rowCounts[actualIndex].toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6,
                                                  fontWeight: FontWeight.w800)))),
                                  Container(
                                      width: w/48,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.all(color: Colors.black, width: 0.2)),
                                      child: Center(
                                          child: Text((31-rowCounts[actualIndex]).toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6,
                                                  fontWeight: FontWeight.w800)))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: w - 30,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                              width: w / 2 - 110,
                              height: 20,
                              color: Colors.blue,
                              child: Text(" Per Day ( P )",
                                  style: TextStyle(color: Colors.white, fontSize: w/35))),
                          for (int i = 0; i < columnCounts.length; i++)
                            Container(
                              width: w/48,
                              height: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 0.2),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(columnCounts[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w800))),
                            ),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: w - 30,
                      height: 20,
                      child: Row(
                        children: [
                          Container(
                              width: w / 2 - 110,
                              height: 20,
                              color: Colors.red.shade400,
                              child: Text(" Per Day ( A )",
                                  style: TextStyle(color: Colors.white, fontSize: w/35))),
                          for (int i = 0; i < columnCounts.length; i++)
                            Container(
                              width: w/48,
                              height: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 0.2),
                                  color: Colors.white),
                              child: Center(
                                  child: Text(((endIndex-startIndex)-columnCounts[i]+1).toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 6,
                                          fontWeight: FontWeight.w800))),
                            ),

                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        ss(),
                        ss(),
                        Text("Thanks",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17)),
                        Spacer(),
                        Text("Teacher Signature",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17)),
                        ss(),
                        ss(),
                      ],
                    ),
                    Container(
                      color: Color(0xff00CE9D),
                      width: w - 40,
                      height: 5,
                    ),
                    s(),
                    s(),
                  ],
                ))));
  }
  final ExportDelegate exportDelegate = ExportDelegate();

  Future<String?> saveFile(document, String name) async {
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
  void calculateCounts() {
    rowCounts.clear();
    columnCounts = List.filled(31, 0);

    for (var student in widget.list) {
      int rowCount = 0;

      for (int day = 1; day <= 31; day++) {
        String attendance = sd(day, student);
        if (attendance == "P") {
          rowCount++;
          columnCounts[day - 1]++;
        }
      }

      rowCounts.add(rowCount);
    }
  }

  var dict = {"dic": 3};

  String sd(int y, StudentModel s6) {
    int gh = int.parse(widget.mo);
    String g = " ";
    if (y < 10) {
      g = "0${y.toString()}";
    } else {
      g = y.toString();
    }
    String s = "${widget.selectedValue}-${widget.mo}-${g} 19:52:55.245586";
    if (isSunday(s)) {
      return " ";
    } else if (s6.present
        .contains("${y.toString()}-${gh.toString()}-${widget.selectedValue}")) {
      return "P";
    } else {
      return "A";
    }
  }

  Widget r(String s, String s2, String s3, String s4) {
    return Row(
      children: [
        ss(),
        ss(),
        t1("$s - " + s2),
        Spacer(),
        t1("$s3 - " + s4),
        ss(),
        ss(),
      ],
    );
  }

  bool isSunday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.weekday == DateTime.sunday;
  }

  Widget s() => SizedBox(height: 10);

  Widget ss() => SizedBox(width: 10);

  Widget t1(String s) =>
      Text(s, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14));


}*/
