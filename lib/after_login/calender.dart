import 'dart:async';

import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_managment_app/attendance/single_attendance.dart';
import 'package:student_managment_app/model/student_model.dart';

class MyCalenderPage extends StatefulWidget {
  const MyCalenderPage({super.key, required this.idi, required this.df, required this.classi, required this.sessioni, required this.user});
  final String df ;
  final String idi; final StudentModel user ;
  final String classi ;
  final String sessioni ;
  @override
  State<MyCalenderPage> createState() => _MyCalenderPageState();
}

class _MyCalenderPageState extends State<MyCalenderPage> {
  int pre = 0 , abs = 0 , nt = 0;

  Future<List<Date>> fetchDataFromFirestore() async {
    List<Date> firestoreDates = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('School').doc(widget.df).collection("Students")
        .doc(widget.idi)
        .collection("Colors")
        .get();
    querySnapshot.docs.forEach((doc) {
      print(doc);
      // Convert Timestamp to DateTime
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          (doc['date'] as Timestamp).millisecondsSinceEpoch);
      firestoreDates.add(Date(
        date: date,
        color: Color(doc['color']),
      ));
      if (doc['color'] == 4280391411) {
        setState(() {
          pre++ ;
        });
      } else if ( doc['color'] == 4294198070){
        setState(() {
          abs++ ;
        });
      }else{
        setState(() {
          nt++ ;
        });
      }
    });
    return firestoreDates;
  }
  late Timer _timer;

  @override
  void dispose() {
    // Dispose the timer when the screen is disposed
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Code to execute every 5 seconds
      fetchDataFromFirestore().then((firestoreDates) {
        setState(() {
          dates = firestoreDates;
        });
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }


  late final List<Date> dates   ;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore().then((firestoreDates) {
      setState(() {
        dates = firestoreDates;
      });
    });
  }


  String local = 'en';

  Future<void> downloadAttendance(String df, String idi) async {
    try {
      List<List<dynamic>> rows = [];
      List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
        'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      rows.add(['Month', ...List.generate(31, (index) => index + 1)]);
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('School').doc(df).collection("Students")
          .doc(idi).collection("Colors")
          .doc("Attendance") // Assuming attendance is stored under a document named "Attendance"
          .get();
      if (snapshot.data() is Map<String, dynamic>) {
        Map<String, dynamic> attendanceData = snapshot.data() as Map<String, dynamic>;
        for (String month in months) {
          List<dynamic> row = [month];
          for (int day = 1; day <= 31; day++) {
            String dayKey = '$month $day';
            bool isPresent = attendanceData.containsKey(dayKey) && attendanceData[dayKey] == true;
            row.add(isPresent ? 'P' : '');
          }
          rows.add(row);
        }
      }

      // Convert the rows to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Request permission to write to external storage
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // If permission is granted, write CSV to file
      if (status.isGranted) {
        String dir = (await getExternalStorageDirectory())!.path;
        String filePath = "$dir/attendance_${idi}.csv";
        File file = File(filePath);
        await file.writeAsString(csv);
        print("File saved to: $filePath");
      } else {
        print("Permission denied for storage.");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: local == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar : AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title : Text("Student's Attendance", style : TextStyle(color : Colors.white)),
          backgroundColor: Color(0xff50008e),
          actions: [
            IconButton(onPressed: (){
              downloadAttendance(widget.df, widget.idi);
            }, icon: Icon(Icons.download)),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomCalendarViewer(
                    local: local,
                    dates: dates,
                    ranges: ranges ,
                    calendarType: CustomCalendarType.multiDatesAndRanges ,
                    calendarStyle: CustomCalendarStyle.normal ,
                    animateDirection: CustomCalendarAnimatedDirection.vertical ,
                    movingArrowSize: 24 ,
                    spaceBetweenMovingArrow: 20 ,
                    closeDateBefore: DateTime.now().subtract(Duration(days: 405)),
                    closedDatesColor: Colors.grey.withOpacity(0.7),
                    //showHeader: false ,
                    showBorderAfterDayHeader: true,
                    showTooltip: true,
                    toolTipMessage: '',
                    //headerAlignment: MainAxisAlignment.center,
                    calendarStartDay: CustomCalendarStartDay.monday,
                    onCalendarUpdate: (date) {
                      // Handel your code here.
                      print('onCalendarUpdate');
                      print(date);
                    },
                    onDayTapped: (date) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Select Status'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Store selected color in Firestore (blue)
                                    _storeColorInFirestore(date, Colors.blue);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Present'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Store selected color in Firestore (red)
                                    _storeColorInFirestore(date, Colors.red);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Absent'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Store selected color in Firestore (red)
                                    _storeColorInFirestore(date, Colors.green);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Holiday'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    onDatesUpdated: (newDates) {
                      print('onDatesUpdated');
                      print(newDates.length);
                    },
                    onRangesUpdated: (newRanges) {
                      print('onRangesUpdated');
                      print(newRanges.length);
                    },
                    //showCurrentDayBorder: false,
                  ),
                  SizedBox(height : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children : [
                     TextButton.icon(onPressed: (){

                     },
                         icon: Icon(Icons.person_add_alt_rounded, color : Colors.blue),
                         label: Text(pre.toString())
                     ),
                      TextButton.icon(onPressed: (){

                      },
                          icon: Icon(Icons.person_remove_alt_1, color : Colors.red),
                          label: Text(abs.toString())
                      ),
                      TextButton.icon(onPressed: (){

                      },
                          icon: Icon(Icons.view_in_ar, color : Colors.green),
                          label: Text(nt.toString())
                      ),
                    ]
                  ),
                  SizedBox(height : 20),
                 TextButton.icon(
                    icon : Icon(Icons.pattern_sharp), label : Text("Full Attendance"), onPressed : (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => Sd(user: widget.user,),
                     ),
                   );
                  }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _storeColorInFirestore(DateTime date, Color color) async {
    try {
      String st = '${date.day}-${date.month}-${date.year}';
      await FirebaseFirestore.instance
          .collection('School').doc(widget.df).collection("Students")
          .doc(widget.idi)
          .collection("Colors")
          .doc(st).set({
        'color': color.value, // Store color as integer value
        'date' : date,
        "st" : st,
      });
      if( color == Colors.blue){
        await FirebaseFirestore.instance.collection('School').doc(widget.df)
            .collection("Session")
            .doc(widget.sessioni).collection("Class").doc(widget.classi).collection("Student").doc(widget.idi)
            .update({
          'Present': FieldValue.arrayUnion([st]),
        });
      }else{
        await FirebaseFirestore.instance.collection('School').doc(widget.df)
            .collection("Session")
            .doc(widget.sessioni).collection("Class").doc(widget.classi).collection("Student").doc(widget.idi)
            .update({
          'Absent': FieldValue.arrayUnion([st]),
        });
      }

    } catch (error) {
      print(error);
    }
  }
}