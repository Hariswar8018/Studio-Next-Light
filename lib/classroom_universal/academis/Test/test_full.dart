import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_model.dart';

class TestFull extends StatefulWidget {
  TestModel user;int j;bool admin;
  String session,school,clas;
   TestFull({super.key,required this.user,required this.j,required this.school,required this.clas,required this.session,required this.admin});

  @override
  State<TestFull> createState() => _TestFullState();
}

class _TestFullState extends State<TestFull> {
  void initState(){
    j=widget.j;
  }
  late int j;
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Color(0xff029A81),
        title: Text("About Test/Exam",style:TextStyle(color:Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22),),
            Text(widget.user.subtitle,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
            widget.user.startdate.isNotEmpty?Text("Start Date : "+getDayAndMonth(widget.user.startdate).toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.red),):SizedBox(),
            widget.user.enddate.isNotEmpty?  Text("End Date   : "+getDayAndMonth(widget.user.enddate).toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.red),):SizedBox(),
           SizedBox(height: 20,),
            AppinioAnimatedToggleTab(
              callback: (int i) {
                setState(() {
                  j=i;
                });
              },
              tabTexts: const [
                'Note',
                'Syllabus',
                'DateSheet',
                'Results',
              ],
              height: 40,
              width: w*9/10,
              boxDecoration: BoxDecoration(color: Colors.red.shade100,),
              animatedBoxDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFc3d2db).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
                color: Colors.red,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              activeStyle: const TextStyle( color: Colors.white,),
              inactiveStyle: const TextStyle( color: Colors.black,),
            ),
            SizedBox(height: 10,),
            col(j, w),
          ],
        ),
      ),
    );
  }

  Widget col(int i,double w){
    if(i==0){
      return Text(widget.user.notes);
    }else if(i==1){
      return Text(widget.user.syllabus);
    }else if(i==2){
      return Container(
        width: w,
        child: Row(
          children: [
            SizedBox(width: 10,),
            Container(
              width: w/2-60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  a(widget.user.s1),
                  a(widget.user.s2),
                  a(widget.user.s3),
                  a(widget.user.s4),
                  a(widget.user.s5),
                  a(widget.user.s6),
                  a(widget.user.s7),
                  a(widget.user.s8),
                  a(widget.user.s9),
                  a(widget.user.s10),
                ],
              ),
            ),
            Container(
              width: w/2+20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  a(widget.user.d1),
                  a(widget.user.d2),
                  a(widget.user.d3),
                  a(widget.user.d4),
                  a(widget.user.d5),
                  a(widget.user.d6),
                  a(widget.user.d7),
                  a(widget.user.d8),
                  a(widget.user.d9),
                  a(widget.user.d10),
                ],
              ),
            ),
          ],
        ),
      );
    }else{
      return SizedBox();
    }
  }

  Widget a(String str){
    try{
      DateTime dateTime = DateTime.parse(str);

      String dayName = DateFormat('EEEE').format(dateTime); // Full day name
      String monthName = DateFormat('MMMM').format(dateTime); // Full month name

      return Text('${dateTime.day}/$monthName on ${dateTime.hour}:${dateTime.minute} ($dayName) ' );
    }catch(e){
      return  Text(str);
    }
  }

  String getDayAndMonth(String dateTimeString) {
    try {
      // Parse the input string to DateTime
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Format day name (e.g., "Monday")
      String dayName = DateFormat('EEEE').format(dateTime); // Full day name

      // Format month name (e.g., "January")
      String monthName = DateFormat('MMMM').format(dateTime); // Full month name

      return '${dateTime.day} ($dayName), $monthName';
    } catch (e) {
      return "Invalid date format";
    }
  }

  Color color(String dateTimeString){
    DateTime inputDateTime;
    try {
      inputDateTime = DateTime.parse(dateTimeString);
    } catch (e) {
      return Colors.black;
    }

    // Get current DateTime
    DateTime now = DateTime.now();

    // Handle case where date is in the past
    if (now.isAfter(inputDateTime)) {
      return Colors.black;
    }

    // Calculate total difference
    Duration difference = inputDateTime.difference(now);

    // Calculate components
    int totalMinutes = difference.inMinutes;
    int days = difference.inDays;
    int months = ((inputDateTime.year - now.year) * 12) + (inputDateTime.month - now.month);

    // Adjust for day overflow
    if (inputDateTime.day < now.day) {
      months--;
    }

    // Calculate remaining days after months
    DateTime tempDate = DateTime(now.year, now.month + months, now.day);
    if (tempDate.isAfter(inputDateTime)) {
      months--;
      tempDate = DateTime(now.year, now.month + months, now.day);
    }
    int remainingDays = inputDateTime.difference(tempDate).inDays;

    // Calculate remaining minutes after days
    int remainingMinutes = difference.inMinutes % (24 * 60);

    // Build the result string dynamically
    List<String> parts = [];

    if (months > 0) {
      return Colors.green;
    }
    if (remainingDays > 0) {
      return Colors.deepOrange;
    }
    if (remainingMinutes > 0) {
      return Colors.red;
    }

    // Handle case where all components are 0 (less than a minute remaining)
    if (parts.isEmpty) {
      return Colors.redAccent;
    }

    return Colors.redAccent;
  }

  String calculateTimeDifference(String dateTimeString) {
    // Parse the input string to DateTime
    DateTime inputDateTime;
    try {
      inputDateTime = DateTime.parse(dateTimeString);
    } catch (e) {
      return "Invalid date format";
    }

    // Get current DateTime
    DateTime now = DateTime.now();

    // Handle case where date is in the past
    if (now.isAfter(inputDateTime)) {
      return "Date already passed";
    }

    // Calculate total difference
    Duration difference = inputDateTime.difference(now);

    // Calculate components
    int totalMinutes = difference.inMinutes;
    int days = difference.inDays;
    int months = ((inputDateTime.year - now.year) * 12) + (inputDateTime.month - now.month);

    // Adjust for day overflow
    if (inputDateTime.day < now.day) {
      months--;
    }

    // Calculate remaining days after months
    DateTime tempDate = DateTime(now.year, now.month + months, now.day);
    if (tempDate.isAfter(inputDateTime)) {
      months--;
      tempDate = DateTime(now.year, now.month + months, now.day);
    }
    int remainingDays = inputDateTime.difference(tempDate).inDays;

    // Calculate remaining minutes after days
    int remainingMinutes = difference.inMinutes % (24 * 60);

    // Build the result string dynamically
    List<String> parts = [];

    if (months > 0) {
      parts.add('$months M');
    }
    if (remainingDays > 0) {
      parts.add('$remainingDays D');
    }
    if (remainingMinutes > 0) {
      parts.add('${remainingMinutes%60} M');
    }

    // Handle case where all components are 0 (less than a minute remaining)
    if (parts.isEmpty) {
      return "Less than a minute";
    }

    return parts.join(' ');
  }

  String fd(String g){
    String s1=g.substring(0,1).toUpperCase();
    String s2=g.substring(1);
    return s1+s2;
  }
}
