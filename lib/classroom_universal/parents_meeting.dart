import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_managment_app/attendance/notice.dart';
import 'package:student_managment_app/classroom_universal/add/add_enym_meeting_etc.dart';
import 'package:student_managment_app/classroom_universal/notice.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeMeeting extends StatelessWidget {
  bool teacher;
  type_class type;
  NoticeMeeting({super.key,required this.clas,required this.school,required this.id,required this.session,required this.teacher,required this.type});
  String school,id,session,clas;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Color(0xff029A81),
        title: Text("My Class ${fd(type.name.toString())}",style:TextStyle(color:Colors.white)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School').doc(school).
        collection('Session').doc(session).collection("Class").doc(clas)
            .collection(fd(type.name.toString())).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => Notice1.fromJson(e.data())).toList() ?? [];
              if(list.isEmpty){
                return Column(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Center(child: Text("No ${fd(type.name.toString())} found",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500))),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(textAlign:TextAlign.center,"Look likes ${fd(type.name.toString())} still not decided by Teacher",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
                        ),
                      ),
                      SizedBox(height:40),
                    ]
                );
              }
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  Notice1 user=list[index];
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        width: w-50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                            Row(
                              children: [
                                Text(user.namet,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                                Spacer(),
                                user.date2.isNotEmpty?SizedBox():Text("Due : "+getDayAndMonth(user.date).toString(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                              ],
                            ),
                            user.date2.isNotEmpty?Text("From : "+getDayAndMonth(user.date).toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.red),):SizedBox(),
                            user.date2.isNotEmpty?Text("To : "+getDayAndMonth(user.date2).toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.red),):SizedBox(),

                            SizedBox(height: 4,),
                            Text(user.description,style: TextStyle(fontWeight: FontWeight.w300),maxLines: 3,),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: user.link.isEmpty?MainAxisAlignment.start:MainAxisAlignment.spaceEvenly,
                              children: [
                                user.link.isEmpty?SizedBox():Container(
                                  width: w/2-30,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: InkWell(
                                      onTap: () async {
                                        Uri url=Uri.parse(user.link);
                                        await launchUrl(url);
                                      },
                                      child: Center(child: Text(user.link,style: TextStyle(fontSize: 8,fontWeight: FontWeight.w200),maxLines: 1,))),
                                ),
                                Container(
                                  width: w/2-30,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: color(user.date),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Center(child: Text(calculateTimeDifference(user.date),style: TextStyle(fontSize: 8,fontWeight: FontWeight.w200,color: Colors.white),maxLines: 1,)),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton:teacher? FloatingActionButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Notice1Form(
                clas: clas, school: school, session: session,
                 type: type,)),
        );
      },child: Icon(Icons.add,),):SizedBox(),
    );
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

  List<Notice1> list = [];
  late Map<String, dynamic> userMap;
  String fd(String g){
    String s1=g.substring(0,1).toUpperCase();
    String s2=g.substring(1);
    return s1+s2;
  }

}
