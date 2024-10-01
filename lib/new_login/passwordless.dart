import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/Parents_Admin_all_data/Admin/homeportal.dart';
import 'package:student_managment_app/Parents_Admin_all_data/finance/home_p.dart';
import 'package:student_managment_app/Parents_Admin_all_data/managment/home.dart';
import 'package:student_managment_app/Parents_Admin_all_data/search_school.dart';
import 'package:student_managment_app/admin/admin_panel.dart';
import 'package:student_managment_app/anew/school_service/bus/portal.dart';
import 'package:student_managment_app/anew/school_service/click_photo/portal.dart';
import 'package:student_managment_app/anew/school_service/gate_pass/gate.dart';
import 'package:student_managment_app/anew/school_service/scanner/home.dart';

import 'package:student_managment_app/before_check/admin.dart';
import 'package:student_managment_app/before_check/forgot_password.dart';
import 'package:student_managment_app/before_check/login.dart';
import 'package:student_managment_app/before_check/super_admin.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/new_login/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:student_managment_app/school_class/class/home.dart';
import 'package:student_managment_app/school_class/employee/home.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_login/twitter_login.dart';

class Passwordless extends StatefulWidget {
  String str;
  Passwordless({super.key,required this.str});

  @override
  State<Passwordless> createState() => _ProfileState();
}

class _ProfileState extends State<Passwordless> {

  bool signup=false;

  siugn()async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:(){
            Navigator.pop(context);
            siugn();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text("Password Less Login",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text("Login with password by clicking in Email Link",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                Image.asset("assets/password.gif",width: w,height: 300,),
                SizedBox(height: 7,),
                fg(email,"Type your Email","Type your Email"),
                SizedBox(height: 15,),
                InkWell(
                  onTap: () async {
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    if(signup){

                    }else{
                      final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
                        url: 'https://yourapp.page.link/emailSignIn', // Your deep link
                        handleCodeInApp: true,
                        iOSBundleId: 'com.example.ios',
                        androidPackageName: 'com.example.android',
                        androidInstallApp: true,
                        androidMinimumVersion: '12',
                      );
                      try {
                        await _auth.sendSignInLinkToEmail(
                          email: email.text,
                          actionCodeSettings: actionCodeSettings,
                        );
                        print('Email sign-in link sent!');
                      } catch (e) {
                        print('Error sending email sign-in link: $e');
                      }
                    }
                  },
                  child: Center(
                    child: Container(
                      height:45,width:w-40,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                            spreadRadius: 5, // The extent to which the shadow spreads
                            blurRadius: 7, // The blur radius of the shadow
                            offset: Offset(0, 3), // The position of the shadow
                          ),
                        ],
                      ),
                      child: Center(child: Text(signup?"Verify OTP":"Send Login link",style: TextStyle(
                          color: Colors.white,
                          fontFamily: "RobotoS",fontWeight: FontWeight.w800
                      ),)),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
    );
  }
  void loginnow(String uid)async{
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).where("position",isEqualTo: widget.str).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Convert the document snapshot to a UserModel
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        Send.message(context, "Login Success !",true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('What', widget.str);
        navigatenow(widget.str, user);
      }
      else {
        QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
        if(querySnapshot.docs.isEmpty){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('What', widget.str);
          UserModel user = UserModel(name: name.text,
              email: email.text, uid:uid,
              pic: "", position: widget.str, last: "",
              verified: false, probation: false,
              school: "", schoolid: "",
              sessionid:"", classid: "", smsend: false, whatsend: false,
              apisend: false, scan: true, update: true, notify: false, admin: false, admin2: false, schoolpic: '', token: '');
          await FirebaseFirestore.instance.collection("Users").doc(uid).set(user.toJson());
          navigatenow(widget.str, user);
        }else{
          Send.message(context, "OOOPs! Looks Like you have Login with Wrong Access",false);
          await FirebaseAuth.instance.signOut();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('What', "Photo");
        }
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      Send.message(context, "$e",false);
      await FirebaseAuth.instance.signOut();
    }
  }

  void navigatenow(String name,UserModel user){
    if(name=="Photo"){
      Navigator.push(
          context, PageTransition(
          child: HomePhoto(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Gate"){
      Navigator.push(
          context, PageTransition(
          child: GatePortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Bus"){
      Navigator.push(
          context, PageTransition(
          child: BusPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Photographer"){
      Navigator.push(
          context, PageTransition(
          child: ClickPicPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Class Teacher"){
      Navigator.push(
          context, PageTransition(
          child: ClassHome(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Employee"){
      Navigator.push(
          context, PageTransition(
          child: Employeeome(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Managment"){
      Navigator.push(
          context, PageTransition(
          child: ManagmentPPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Finance"){
      Navigator.push(
          context, PageTransition(
          child: FinancePPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Admin"){
      Navigator.push(
          context, PageTransition(
          child: AdminPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="SuperAdmin"){
      Navigator.push(
          context, PageTransition(
          child: AdminP(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }
  }

  Widget fg(TextEditingController ha,String str, String str2)=> Padding(
    padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 10),
    child: TextFormField(
      controller: ha,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: str,
        hintText: str2,
        enabled: !signup,
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please type It';
        }
        return null;
      },
    ),
  );

  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController verify=TextEditingController();
  TextEditingController password=TextEditingController();

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

