import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/search_school.dart';
import 'package:student_managment_app/anew/class_teacher/login/login.dart';
import 'package:student_managment_app/anew/parents/parents_login.dart';
import 'package:student_managment_app/anew/school/login/login.dart';
import 'package:student_managment_app/before_check/admin.dart';
import 'package:student_managment_app/before_check/first2.dart';
import 'package:student_managment_app/before_check/login.dart';
import 'package:student_managment_app/before_check/super_admin.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/l10n/app_localization.dart';
import 'package:student_managment_app/new_login/profile.dart';

class New_S extends StatelessWidget {
  const New_S({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/main_top.png",height: 200,),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset("assets/main_bottom.png",height: 100,),
                    Spacer(),
                    Image.asset("assets/login_bottom.png",height: 150,),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text(AppLocalizations.of(context)!.translate('New1'),
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text(AppLocalizations.of(context)!.translate('New2'),
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      c(true,w),c(false,w),c(false,w),
                    ],
                  ),
                ),
                SizedBox(height: 33,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: N1(),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/parents-svgrepo-com.svg",AppLocalizations.of(context)!.translate('Parents1'), AppLocalizations.of(context)!.translate('Parents2'))),
                    InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: N2(),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 10)));
                        },child: q(context,"assets/new/school-svgrepo-com (2).svg","School Service", "Gate/Bus/Hostel/etc")),
                  ],
                ),
                SizedBox(height: 13,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: N3(),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 10)));
                        },child: q(context,"assets/new/school-svgrepo-com (2).svg",AppLocalizations.of(context)!.translate('School'), AppLocalizations.of(context)!.translate('School2'))),
                    InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: N4(),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/security-guard-svgrepo-com.svg",AppLocalizations.of(context)!.translate('Admin'),AppLocalizations.of(context)!.translate('Admin2')))

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
              Text(str1, style: TextStyle(fontWeight: FontWeight.w300,fontFamily: "RobotoS",fontSize: 7)),
            ]));
  }
}


class N1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/main_top.png",height: 200,),
                Spacer(),
                Row(
                  children: [
                    Image.asset("assets/main_bottom.png",height: 20,),
                    Spacer(),
                    Image.asset("assets/login_bottom.png",height: 150,),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text("Parents/Guardian Login",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text("Please click on your Profile",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      c(true,w),c(true,w),c(false,w),
                    ],
                  ),
                ),
                SizedBox(height: 33,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Parents_Login(student: false,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 200)));
                        },
                        child: q(context,"assets/new/family-svgrepo-com.svg","Parents", "Parents")),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Parents_Login(student: true,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 200)));
                        },
                        child: q(context,"assets/new/graduation-student-hand-raised-svgrepo-com.svg","Students","Bus/Auto/Scan"))
                  ],
                ),
                SizedBox(height: 13,),
               /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    q(context,"assets/new/person-boy-svgrepo-com.svg","Guest", "Parents/Guardian/Students"),
                    q(context,"assets/new/person-holding-a-glass-of-milk-svgrepo-com.svg","Guardian","Bus/Auto/Scan")
                  ],
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
            ]));
  }
}


class N2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/main_top.png",height: 200,),
                Spacer(),
                Row(
                  children: [
                    Image.asset("assets/main_bottom.png",height: 20,),
                    Spacer(),
                   SizedBox(width:10),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 95,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text("School Service Login",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text("Please click on your Profile",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      c(true,w),c(true,w),c(false,w),
                    ],
                  ),
                ),
                SizedBox(height: 33,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          Send.message(context,"Will work from Next Update",false);
                        },
                        child: q(context,"assets/new/gate-entrance-svgrepo-com.svg","Gate Entry","Bus/Auto/Scan")),
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: 'Photo',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/qr-code-svgrepo-com.svg","Scan", "Parents/Guardian/Students")),
                  ],
                ),
                SizedBox(height: 13,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){

                            Send.message(context,"Will work from Next Update",false);

                      /*    Navigator.push(
                              context,
                              PageTransition(
                                  child: N6(bus: true,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));*/
                        },
                        child: q(context,"assets/new/bus-svgrepo-com.svg","Bus/Auto", "Parents/Guardian/Students")),
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: 'Photographer',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/photo-camera-picture-svgrepo-com.svg","Photographer","Bus/Auto/Scan"))
                  ],
                ),
                SizedBox(height: 13,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: N6(bus: false,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));

                        },
                        child: q(context,"assets/hotel-svgrepo-com.svg","Hostel / Dormitory", "Parents/Guardian/Students")),
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: 'Gate Keeper',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/border-guard-svgrepo-com.svg","Gate Keeper","Bus/Auto/Scan"))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
            ]));
  }
}


class N3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/main_top.png",height: 200,),
                Spacer(),
                Row(
                  children: [
                    Image.asset("assets/main_bottom.png",height: 20,),
                    Spacer(),
                    Image.asset("assets/login_bottom.png",height: 150,),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text("School Login",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text("Please click on your Profile",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      c(true,w),c(true,w),c(false,w),
                    ],
                  ),
                ),
                SizedBox(height: 33,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SchoolM(principal: true,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/principal-svgrepo-com.svg","Principal","Bus/Auto/Scan")),
                    InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SchoolM(principal: false,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/school-svgrepo-com (3).svg","Managment","Bus/Auto/Scan"))
                  ],
                ),
                SizedBox(height: 13,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          Send.message(context,"Will work from Next Update",false);
                        },
                        child: q(context,"assets/new/employee-worker-svgrepo-com.svg","Employee", "Parents/Guardian/Students")),
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: 'Class Teacher',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/teacher-svgrepo-com.svg","Class Teacher", "Parents/Guardian/Students")),
                  ],
                ),             ],
            ),
          ),
        ],
      ),
    );
  }
  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
            ]));
  }
}


class N4 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/main_top.png",height: 200,),
                Spacer(),
                Row(
                  children: [
                    Image.asset("assets/main_bottom.png",height: 20,),
                    Spacer(),
                    Image.asset("assets/login_bottom.png",height: 150,),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text("Admin Login",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text("Please click on your Profile",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      c(true,w),c(true,w),c(false,w),
                    ],
                  ),
                ),
              SizedBox(height: 33,),
             /*   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: 'Managment',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/finance-business-analytics-graph-donuts-svgrepo-com.svg","Managment", "Parents/Guardian/Students")),
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: "Finance"),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/finance-coin-businesswoman-career-svgrepo-com.svg","Finance","Bus/Auto/Scan"))
                  ],
                ),
                SizedBox(height: 13,),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap:(){
                          Navigator.push(
                              context, PageTransition(
                              child: Admin(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                          ));
                        },
                        child: q(context,"assets/new/university-svgrepo-com.svg","Admin", "Parents/Guardian/Students")),
                  InkWell(
                        onTap: () {
                          Navigator.push(
                              context, PageTransition(
                              child: SuperAdmin(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                          ));
                        },
                        child: q(context,"assets/new/security-shield-svgrepo-com.svg","Super Panel","Bus/Auto/Scan"))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
            ]));
  }
}