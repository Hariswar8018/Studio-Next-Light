import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======
import 'package:studio_next_light/Parents_Admin_all_data/search_school.dart';
import 'package:studio_next_light/before_check/admin.dart';
import 'package:studio_next_light/before_check/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/before_check/student_data.dart';
import 'package:studio_next_light/before_check/super_admin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class First2 extends StatelessWidget {
  const First2({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Close ?'),
              content: Text('Do you really want to close the app ?'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Pop the dialog
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        );
        // Return false to prevent the app from being closed immediately
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String phoneNumber = '917000994158';
            String message = 'Hi, Studio Next Light! We are contacting you regarding your App';

            String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

            if (await canLaunch(url)) {
            await launch(url);
            } else {
// Handle error
            print('Could not launch WhatsApp');
            }
          },
          tooltip: 'Open WhatsApp',
          child: Icon(Icons.chat),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 40,
                child: Image(
                  image: AssetImage(
                    'assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png', ),
                ),
              ),
              SizedBox(height: 10,),
              Icon(Icons.login, size : 44, color : Colors.greenAccent),
              Text("Login to Our App based on your Position", style : TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 18
              )),
          
              SizedBox(height: 20,),
              ListTile(
                leading: Icon(Icons.people_outline_sharp,color: Colors.orange, size: 30),
                title: Text("Parents Entry"),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Panel_School(b : false),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 400)));
                },
                subtitle: Text("Check children status or modify data"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.orange, size: 20,),
                splashColor: Colors.orange.shade300,
                tileColor: Colors.grey.shade50,
              ),
              ListTile(
                leading: Icon(Icons.school,color: Colors.blueAccent, size: 30),
                title: Text("School / College / University"),
                onTap: () {
                  Navigator.push(
                      context, PageTransition(
                      child: LoginScreen(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                  ));
                },
                subtitle: Text("Upload Students data to Institute Database"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.blueAccent, size: 20,),
                splashColor: Colors.orange.shade300,
                tileColor: Colors.grey.shade50,
              ),
              ListTile(
                leading: Icon(Icons.admin_panel_settings_sharp,color: Colors.greenAccent, size: 30),
                title: Text("Admin"),
                onTap: () {
                  Navigator.push(
                      context, PageTransition(
                      child: Admin(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                  ));
                },
                subtitle: Text("Make & Manage Institute Profile"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.greenAccent, size: 20,),
                splashColor: Colors.orange.shade300,
                tileColor: Colors.grey.shade50,
              ),
              ListTile(
                leading: Icon(Icons.security,color: Colors.redAccent, size: 30),
                title: Text("SuperAdmin"),
                onTap: () {
                  Navigator.push(
                      context, PageTransition(
                      child: SuperAdmin(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                  ));
                },
                subtitle: Text("Lock, Unlock, Export School Data"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.redAccent, size: 20,),
                splashColor: Colors.orange.shade300,
                tileColor: Colors.grey.shade50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
>>>>>>> 4579457a5684b5d607585bb7c8e7a996717b7056
