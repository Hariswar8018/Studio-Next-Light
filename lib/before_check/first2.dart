import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/new_login/profile.dart';

class N6 extends StatelessWidget {
bool bus;
N6({required this.bus});
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
               bus? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProfileM(str: 'Bus',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 10)));
                        },
                        child: q(context,"assets/new/bus-svgrepo-com.svg","Bus", "Parents")),
                    InkWell(
                        onTap: () {
                          Send.message(context, "This function will be Available after 2.3 Update !", false);
                        },
                        child: q(context,"assets/new/auto-ricksaw-svgrepo-com.svg","Auto","Bus/Auto/Scan"))
                  ],
                ):Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   InkWell(
                       onTap: () {
                         Navigator.push(
                             context,
                             PageTransition(
                                 child: ProfileM(str: 'Dormitory',),
                                 type: PageTransitionType.rightToLeft,
                                 duration: Duration(milliseconds: 10)));
                       },
                       child: q(context,"assets/hotel-svgrepo-com.svg","Dormitory", "Dormitory")),
                   InkWell(
                       onTap: () {
                         Send.message(context, "This function will be Available after 2.3 Update !", false);
                       },
                       child: q(context,"assets/hotel-svgrepo-com (1).svg","Hostel","Bus/Auto/Scan"))
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