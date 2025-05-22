import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/results/all_students.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/results/student_result.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_full.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_model.dart';
import 'package:student_managment_app/classroom_universal/add/add_test.dart';
import 'package:url_launcher/url_launcher.dart';

class AllTest extends StatefulWidget {
  bool given;int j;
  bool admin,exam;
  String session,school,clas;
  AllTest({super.key,required this.j,required this.school,required this.admin,required this.clas,required this.exam,required this.session,this.given=false});

  @override
  State<AllTest> createState() => _AllTestState();
}

class _AllTestState extends State<AllTest> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Color(0xff029A81),
        title: Text("My Class "+(widget.exam?"Exams":"Tests"),style:TextStyle(color:Colors.white)),
      ),
      body: Container(
        width: w,height: h,
        child: Column(
          children: [
            widget.given?SizedBox(height: 10,):SizedBox(),
            widget.given?AppinioAnimatedToggleTab(
              callback: (int i) {
                setState(() {
                  widget.exam=!widget.exam;
                });
              },
              tabTexts: const [
                'Test',
                'Exam',
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
            ):SizedBox(),
            Container(
              width: w,height:widget.given?h: h-264,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('School').doc(widget.school).
                collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
                    .collection(widget.exam?"Exams":"Tests").snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data?.map((e) => TestModel.fromJson(e.data())).toList() ?? [];
                      if(list.isEmpty){
                        return Column(
                            crossAxisAlignment:CrossAxisAlignment.center,
                            mainAxisAlignment:MainAxisAlignment.center,
                            children:[
                              Center(child: Text("No ${(widget.exam?"Exams":"Tests")}",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500))),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(textAlign:TextAlign.center,"You are Lucky ! No ${(widget.exam?"Exams":"Tests")} upcoming",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
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
                          TestModel user=list[index];
                          return InkWell(
                            onTap: (){
                              if(widget.given){
                                if(widget.j==3){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultAll(user: user, id: widget.school, class_id: widget.clas, session_id: widget.session, admin: widget.admin,)),
                                  );
                                }else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TestFull(user: user, j:widget.j, school: widget.school, clas: widget.clas, session: widget.session, admin: widget.admin,)),
                                  );
                                }
                              }else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestFull(user: user, j: 0, school: widget.school, clas: widget.clas, session: widget.session, admin: widget.admin,)),
                                );
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Container(
                                  width: w-50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                      Row(
                                        children: [
                                          Text(user.subtitle,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                                          Spacer(),
                                          user.enddate.isNotEmpty?SizedBox():Text("Due : "+getDayAndMonth(user.startdate).toString(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                                        ],
                                      ),
                                      user.startdate.isNotEmpty?Text("Start Date : "+getDayAndMonth(user.startdate).toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.red),):SizedBox(),
                                      user.enddate.isNotEmpty?  Text("End Date   : "+getDayAndMonth(user.enddate).toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.red),):SizedBox(),
                                      SizedBox(height: 4,),
                                      Text(user.notes,style: TextStyle(fontWeight: FontWeight.w300),maxLines: 3,),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: user.attachment.isEmpty?MainAxisAlignment.start:MainAxisAlignment.spaceEvenly,
                                        children: [
                                          user.attachment.isEmpty?SizedBox():Container(
                                            width: w/2-30,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: InkWell(
                                                onTap: () async {
                                                  Uri url=Uri.parse(user.attachment);
                                                  await launchUrl(url);
                                                },
                                                child: Center(child: Text(user.attachment,style: TextStyle(fontSize: 8,fontWeight: FontWeight.w200),maxLines: 1,))),
                                          ),
                                          Container(
                                            width: w/2-30,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: color(user.startdate),
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Center(child: Text(calculateTimeDifference(user.startdate),style: TextStyle(fontSize: 8,fontWeight: FontWeight.w200,color: Colors.white),maxLines: 1,)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
      floatingActionButton: widget.admin?FloatingActionButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddTests(clas: widget.clas, school: widget.school, test: !widget.exam, session: widget.session,)),
        );
      },child: Icon(Icons.add,),backgroundColor: Colors.orangeAccent,):SizedBox(),
    );
  }

  List<TestModel> list = [];

  late Map<String, dynamic> userMap;

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
