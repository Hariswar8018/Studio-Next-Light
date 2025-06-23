import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/anew/school/service/duty_form.dart';
import 'package:student_managment_app/classroom_universal/academis/student_attendance.dart';
import 'package:student_managment_app/classroom_universal/logs/all_students.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';

import '../../model/usermodel.dart';

class Classp extends StatefulWidget {
 SchoolModel c;
  Classp({required this.user,required this.c });
  UserModel user;

  @override
  State<Classp> createState() => _ClasspState();
}

class _ClasspState extends State<Classp> {
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

 String getRandomImage() {
   final quotes = [
     "https://www.teachermagazine.com/assets/images/teacher/Planning-student-group-work.jpg",
     "https://www.eschoolnews.com/files/2024/04/studet-teachers-student-teaching.jpeg",
     "https://peartree.school/wp-content/uploads/2020/07/Lehrerin-oder-Dozent-steht-im.jpg.webp",
     "https://rockwoodsinternationalschool.com/auth/uploads/pages/OUBaiDW63S7jkvkzOPyDqKpMb0HtUWED.png"
   ];
   final random = Random();
   return quotes[random.nextInt(quotes.length)];
 }

 void initState(){
   countStudentAttendance(widget.c.id, widget.c.csession, widget.user.classid,);
 }
 Future<Map<String, dynamic>> countStudentAttendance(String id, String session_id, String class_id) async {
   // Format current day as "dd/MM/yyyy"
   final String day = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

   int containsDayCount = 0;
   int notContainsDayCount = 0;
   int totalScanned = 0;

   try {
     final querySnapshot = await FirebaseFirestore.instance
         .collection('School').doc(id)
         .collection('Session').doc(session_id)
         .collection("Class").doc(class_id)
         .collection("Student")
         .get();

     totalScanned = querySnapshot.size;

     for (final doc in querySnapshot.docs) {
       final data = doc.data();

       if (data['schoollist'] != null && data['schoollist'] is List) {
         final List<dynamic> schoollist = data['schoollist'];
         if (schoollist.contains(day)) {
           containsDayCount++;
         } else {
           notContainsDayCount++;
         }
       } else {
         // If schoollist field doesn't exist or isn't a list
         notContainsDayCount++;
       }
     }

     setState(() {
       all=totalScanned;
       leaves=notContainsDayCount;
       ins=containsDayCount;
     });
     return {
       'contains_day_count': containsDayCount,
       'not_contains_day_count': notContainsDayCount,
       'total_scanned': totalScanned,
       'day_checked': day,
       'success': true,
     };
   } catch (e) {
     return {
       'error': e.toString(),
       'success': false,
     };
   }
 }

 @override
 Widget build(BuildContext context) {
   double w = MediaQuery.of(context).size.width;
   return Scaffold(
     drawer:Global.buildDrawer(context),
     key: _scaffoldKey,
     appBar: AppBar(
       leading: CircleAvatar(backgroundImage: NetworkImage(widget.c.Pic_link)),
       title: Text("Class Teacher Portal"),
       actions: [
         IconButton(onPressed: (){
           _scaffoldKey.currentState?.openDrawer();
         }, icon: Icon(Icons.more_vert_outlined))
       ],
     ),
     body: Column(
       children: [
         SizedBox(height: 10,),
         Center(
           child: Container(
             width: w-20,
             height: 190,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(2),
                 image: DecorationImage(image: NetworkImage(getRandomImage()),fit: BoxFit.cover)
             ),
           ),
         ),
         SizedBox(height: 10,),
         InkWell(
           onTap: (){
             Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => StudentSSS(
                     showonly: true, id:widget.c.id, session_id: widget.c.csession, premium: widget.c.premium,
                     sname: widget.user.school, rem: false, class_id: widget.user.classid,
                     h: false, st: '', Class: '',)),
             );
           },
           child: Container(
             width: w-20,height: 80,
             decoration: BoxDecoration(
               border: Border.all(
                 color: Colors.blue,
                 width: 2,
               ),
               borderRadius: BorderRadius.circular(6),
               color: Colors.white,
             ),
             child: Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   t1(w,"Total","Students",all),
                   c1(),
                   t1(w,"Present","Students",ins),
                   c1(),
                   t1(w,"Absent","Students",leaves),
                   c1(),
                   t1(w,"Leave","Students",all-(ins+leaves)),
                 ],
               ),
             ),
           ),
         ),
         SizedBox(height: 5,),
         SizedBox(height: 10,),
         Center(
           child: Container(
             width: w-15,
             decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(10)
             ),
             child: Padding(
               padding: const EdgeInsets.only(top: 10.0,bottom: 15),
               child: Center(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     Text("    Student Progress",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                     SizedBox(height: 9,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         InkWell(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>DutyForm(id: widget.c.id, teacher: false)),
                               );
                             },
                             child: q(context,"assets/images/school/lecture-class-svgrepo-com.svg","Duty Form")),

                         InkWell(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => StudentSSS(
                                       showonly: true, id:widget.c.id, session_id: widget.c.csession, premium: widget.c.premium,
                                       sname: widget.user.school, rem: false, class_id: widget.user.classid,
                                       h: false, st: '', Class: '',)),
                               );
                             }, child: q(context,"assets/new/qr-code-svgrepo-com.svg","Attendance")),
                         InkWell(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => Logs(
                                       showonly: true, id: widget.c.id, session_id: widget.c.csession, premium: widget.c.premium,
                                       sname: widget.user.school, rem: false, class_id: widget.user.classid,
                                       h: false, st: '', Class: '', type: logtype.Logs,)),
                               );
                             },
                             child: q(context,"assets/first/print-warn-svgrepo-com.svg","LOGs")),
                         InkWell(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => Logs(
                                       showonly: true, id: widget.c.id, session_id: widget.c.csession, premium: widget.c.premium,
                                       sname: widget.user.school, rem: false, class_id: widget.user.classid,
                                       h: false, st: '', Class: '', type: logtype.Warnings,)),
                               );
                             },
                             child: q(context,"assets/first/customer-complaint-svgrepo-com.svg","Warnings")),
                       ],
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
       ],
     ),
   );
 }

 int ins=0, outs=0,leaves=0, all=0;

 Widget t1(double w,String s1,String s2, int y)=>Container(
   width: w/5-10,
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Text(s1,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 9),),
       Text(s2,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 7),),
       SizedBox(height: 2,),
       Text(y.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 22),),
     ],
   ),
 );

 Widget c1()=>Container(
   width: 3,
   height: 40,
   decoration: BoxDecoration(
       color: Colors.blue,
       borderRadius: BorderRadius.circular(20)
   ),
 );

 Widget t(double w,String s1,String s2, int y)=>Container(
   width: w/3-10,
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Text(s1,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 9),),
       Text(s2,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 9),),
       SizedBox(height: 2,),
       Text(y.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 27),),
     ],
   ),
 );

 Widget q(BuildContext context, String asset, String str) {
   double d = MediaQuery.of(context).size.width / 4 - 35;
   return Column(
     children: [
       Container(
           width: d,
           height: d,
           decoration: BoxDecoration(
             color: Colors.white,

             borderRadius: BorderRadius.circular(10),
           ),
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: SvgPicture.asset(
               asset,
               semanticsLabel: 'Acme Logo',
               height: d-50,
             ),
           )),
       SizedBox(height: 7),
       Text(str, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
     ],
   );
 }
}
