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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

class Sd extends StatefulWidget {
  StudentModel user ;
  Sd({super.key, required this.user});

  @override
  State<Sd> createState() => _SdState();
}

class _SdState extends State<Sd> {
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    DateTime now = DateTime.now();
    int Mo = now.month;
    int Ye = now.year;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:  Colors.deepPurple,
            title: Row(
              children: [
                InkWell( onTap : (){ Navigator.pop(context);},child: Icon(Icons.arrow_back_ios, color : Colors.white)),
                SizedBox(width : 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.user.pic),
                ),
                SizedBox(width : 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user.Name, style : TextStyle(color : Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                    Text("Class : " + widget.user.Class + " (" + widget.user.Section+ ")", style : TextStyle(color : Colors.white, fontSize: 14)),
                  ],
                ),
              ],
            ),
        ),
      body :SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children : [
            a(context),
            b(context, "1"),
            b(context, "2"),
            b(context, "3"),
            b(context, "4"),
            b(context, "5"),
            b(context, "6"),
            b(context, "7"),
            b(context, "8"),
            b(context, "9"),
            b(context, "10"),
            b(context, "11"),
            b(context, "12"),
            b(context, "13"),
            b(context, "14"),
            b(context, "15"),
            b(context, "16"),
            b(context, "17"),
            b(context, "18"),
            b(context, "19"),
            b(context, "20"),
            b(context, "21"),
            b(context, "22"),
            b(context, "23"),
            b(context, "24"),
            b(context, "25"),
            b(context, "26"),
            b(context, "27"),
            b(context, "28"),
            b(context, "29"),
            b(context, "30"),
            b(context, "31"),
          ]
        ),
      )
    );
  }
  Widget b(BuildContext context, String sf){
    return Padding(
      padding: const EdgeInsets.only(left : 8.0, right : 8),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        // Add border to the table
        columnWidths: {
          0: FlexColumnWidth(3),
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
                    sf,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(1, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(2, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(3, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(4, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(5, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(6, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(7, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(8, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(9, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(10, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(11, sf)
                ),
              ),
              TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: re(12, sf)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget re(int y, String m) {
    String s = "${m}-${y}-${2024}";
    int gh = int.parse(m);
    String n1 = " ";
    String n2 = " ";
    if (y < 10) {
      n1 = "0${m}";
    } else {
      n1 = m;
    }
    if (gh < 10) {
      n2 = "0${y.toString()}";
    } else {
      n2 = y.toString();
    }
    String sh = "$n2-$n1-2024 19:52:55.245586";
    /*print(s);
    if (isSunday(sh)){
      return Text(" ", style: TextStyle(
          fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w800));
    }
    else*/ if( widget.user.present.contains(s)){
      return Text("P", style: TextStyle(
          fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w800));
    }else{
      return Text("A", style: TextStyle(
          fontSize: 13, color: Colors.red, fontWeight: FontWeight.w600));
    }
  }

  bool isSunday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.weekday == DateTime.sunday;
  }
  Widget a(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        // Add border to the table
        columnWidths: {
          0: FlexColumnWidth(3),
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
                     "  ",
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
            ],
          ),
        ],
      ),
    );
  }
}
