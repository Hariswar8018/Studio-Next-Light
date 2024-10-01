import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/attendance/single_attendance.dart';

import '../../../model/student_model.dart';

class StA extends StatefulWidget {
  StudentModel user; bool parent;
  StA({super.key,required this.parent,required this.user});

  @override
  State<StA> createState() => _StAState();
}

class _StAState extends State<StA> {
  int pre = 0 , abs = 0 , nt = 0;

  Future<List<Date>> fetchDataFromFirestore(String df,String idi) async {
    List<Date> firestoreDates = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('School').doc(df).collection("Students")
        .doc(idi)
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

  @override
  void dispose() {
    // Dispose the timer when the screen is disposed
    super.dispose();
  }




  late final List<Date> dates   ;

  @override
  void initState() {
    super.initState();
   open();
  }
  Future<void> open() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('school') ?? "None";
    final String clas = prefs.getString('class') ?? "None";
    final String session = prefs.getString('session') ?? "None";
    final String regist = prefs.getString('id') ?? "None";
    fetchDataFromFirestore(id,regist).then((firestoreDates) {
      setState(() {
        dates = firestoreDates;
      });
    });
    setState(() {
      idi=regist;
      df=id;
    });
  }
  String idi="",df=" ";


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
    return Scaffold(
      appBar : AppBar(
        automaticallyImplyLeading:false,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title : Text("Student's Attendance", style : TextStyle(color : Colors.white)),
        backgroundColor: Color(0xff50008e),
        actions: [
          IconButton(onPressed: (){
            downloadAttendance(df, idi);
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
                  calendarType: CustomCalendarType.view ,
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
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Sd(user: widget.user,),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width-40,
                      height:90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: "ST"=="ST"?Colors.blue:Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          SizedBox(width: 5,),
                          Image.asset(height: 80,
                              "assets/attendance.jpg"),
                          SizedBox(width: 5,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Full Attendance',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                              SizedBox(height: 3,),
                              Text('Check Full Attendance of',
                                style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                              Text('Students - Gridwise',
                                style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                            ],
                          ),
                          Spacer(),
                          'ST'=="ST"? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                            ),
                          ):SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
