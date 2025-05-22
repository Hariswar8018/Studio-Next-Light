import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/classroom_universal/logs/all_students.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';

import '../../model/usermodel.dart';

class Classp extends StatelessWidget {
 SchoolModel c;
  Classp({required this.user,required this.c });
  UserModel user;
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
 @override
 Widget build(BuildContext context) {
   double w = MediaQuery.of(context).size.width;
   return Scaffold(
     drawer:Global.buildDrawer(context),
     key: _scaffoldKey,
     appBar: AppBar(
       leading: CircleAvatar(backgroundImage: NetworkImage(c.Pic_link)),
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
                             Send.message(context, "Not Yet Available on ClassRoom Panel ! Please use School Portal Instead", false);
                           }, child: q(context,"assets/student-svgrepo-com.svg","Marksheets")),

                         InkWell(
                             onTap: (){
                               Send.message(context, "Double Attendance is Not Yet Available", false);
                             }, child: q(context,"assets/new/qr-code-svgrepo-com.svg","Attendance")),
                         InkWell(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => Logs(
                                       showonly: true, id: c.id, session_id: c.csession, premium: c.premium,
                                       sname: user.school, rem: false, class_id: user.classid,
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
                                       showonly: true, id: c.id, session_id: c.csession, premium: c.premium,
                                       sname: user.school, rem: false, class_id: user.classid,
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
