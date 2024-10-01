import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/school_class/dormitory/chat.dart';
import 'package:student_managment_app/school_class/dormitory/service/add.dart';
import 'package:student_managment_app/school_class/dormitory/service/scan.dart';

import '../../model/usermodel.dart';

class HomeDor extends StatefulWidget {
  UserModel user;

  HomeDor({super.key,required this.user});

  @override
  State<HomeDor> createState() => _HomeDorState();
}

class _HomeDorState extends State<HomeDor> {
  int full=0, inside=0,outside=0;
  void initState(){
    countTotalMfValu();
    countTotalMfValu1();
    countTotalMfValu2();
  }
  void countTotalMfValu() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.schoolid)
        .collection('Students').where("dormitoryid",isEqualTo: widget.user.uid)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      print("Number of documents with  in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      full= count;
    });
  }
  void countTotalMfValu1() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.schoolid)
        .collection('Students').where("dormitoryid",isEqualTo: widget.user.uid).where("dorout",isEqualTo: false)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      print("Number of documents with  in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      inside= count;
    });
  }
  void countTotalMfValu2() async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection('School')
        .doc(widget.user.schoolid)
        .collection('Students').where("dormitoryid",isEqualTo: widget.user.uid).where("dorout",isEqualTo: false)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      print("Number of documents with  in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      outside= count;
    });
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-20,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.user.pic),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.name,style: TextStyle(fontSize: w/25,fontWeight: FontWeight.w800,color: Colors.white),),
                        SizedBox(height: 20,),
                        Text("Under : ${widget.user.school}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                        Text("",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                        Text("Completed : ${full}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                        Text("Inside : ${inside}             Outside : ${outside}",style: TextStyle(fontSize: w/31,fontWeight: FontWeight.w600,color: Colors.white),),
                      ],
                    )
                  ],
                ),
              ),

            ),
            SizedBox(height: 20,),
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
                        Text("    In/Out Related ",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: QRViewExample3(user: widget.user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/new/qr-code-svgrepo-com.svg","Scan")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DormitoryStudent(id: widget.user.schoolid, adding: false, on: true, inn: true, user: widget.user,making: true,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/in-flight-svgrepo-com.svg","Make In")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DormitoryStudent(id: widget.user.schoolid, adding: false, on: true, inn: false, user: widget.user,making: true,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/in-svgrepo-com.svg","Make Out")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DormitoryStudent(id: widget.user.schoolid, adding: true, on: true, inn: false, user: widget.user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/add-square-svgrepo-com.svg","Add Students")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
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
                        Text("    Dormitory Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DormitoryStudent(id: widget.user.schoolid, adding: false, on: false, inn: true, user: widget.user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/persons-in-a-class-svgrepo-com.svg","Students")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child:HomeDorw(user: widget.user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/history-svgrepo-com.svg","History")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DormitoryStudent(id: widget.user.schoolid, adding: false, on: true, inn: true, user: widget.user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/in-flight-svgrepo-com.svg","In Students")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DormitoryStudent(id: widget.user.schoolid, adding: false, on: true, inn: false, user: widget.user,),
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 50)));
                                },
                                child: q(context,"assets/in-svgrepo-com.svg","Out Students")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
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
