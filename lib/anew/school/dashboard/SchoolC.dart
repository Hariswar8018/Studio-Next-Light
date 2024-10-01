import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/anew/school/service/requestget/gate_pass.dart';
import 'package:student_managment_app/anew/school/service/requestget/see_all_request.dart';
import 'package:student_managment_app/bus/bus_create.dart';
import 'package:student_managment_app/bus/see_all_buses.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
class SchoolC extends StatefulWidget {
  SchoolModel user;
  SchoolC({super.key,required this.user});

  @override
  State<SchoolC> createState() => _SchoolCState();
}

class _SchoolCState extends State<SchoolC> {
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title:Center(child: Text("Security & Account",style:TextStyle(color:Colors.white))),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/security.gif",width: w,),

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
                        Text("    Login Requests",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q(context,"assets/new/teacher-svgrepo-com.svg","Class Teacher"),
                            q(context,"assets/new/employee-worker-svgrepo-com.svg","Employee"),
                            q(context,"assets/new/bus-svgrepo-com.svg","Bus"),
                            q(context,"assets/new/qr-code-svgrepo-com.svg","Scan"),
                          ],
                        ),
                        SizedBox(height: 9,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              q(context,"assets/new/photo-camera-picture-svgrepo-com.svg","Photographer"),
                              q(context,"assets/border-guard-svgrepo-com.svg","Gate Keeper"),
                              q(context,"assets/hotel-svgrepo-com.svg","Dormitory"),
                              q(context,"assets/new/security-shield-svgrepo-com.svg","History"),
                            ],
                          ),
                      ],
                    ),
                  ),
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
                        Text("    Bus Admin Function",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap:(){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child:BusCreate(userr: widget.user,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 10)));
                                },
                                child: f(context,"assets/newportal/bus-svgrepo-com.svg","Create Bus")),
                            InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child:CheckAllBus1(studentid: widget.user.id, schoolid: widget.user.id,),
                                          type: PageTransitionType.rightToLeft,
                                          duration: Duration(milliseconds: 10)));
                                },
                                child: f(context,"assets/newportal/route-start-svgrepo-com.svg","Manage Bus")),
                            q(context,"assets/newportal/location-pin-svgrepo-com.svg","School Location"),
                            q(context,"assets/new/qr-code-svgrepo-com.svg","Scan"),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                        Text("    Gate/Entry Request",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            h(context,"assets/new/teacher-svgrepo-com.svg","Pending",false),
                            h(context,"assets/new/employee-worker-svgrepo-com.svg","Meeting Fixed",true),
                            h(context,"assets/new/bus-svgrepo-com.svg","Completed",false),
                            h(context,"assets/new/qr-code-svgrepo-com.svg","All",false),
                          ],
                        ),
                        SizedBox(height: 9,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  Widget h(BuildContext context, String asset, String str,bool his) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return InkWell(
      onTap: () async {
        final LocalAuthentication auth = LocalAuthentication();
        final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
        final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        try {
          final bool didAuthenticate = await auth.authenticate(localizedReason: 'Please authenticate to approve Gate/Entry Request of $str');
          print(didAuthenticate);
          if(didAuthenticate){
            Navigator.push(
                context,
                PageTransition(
                    child:Historyy(str: widget.user.id, verify: his,),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 10)));
          }else{
            Send.message(context, "Authentication is Reqired to give Access",false);
          }
        } catch(e) {
          if(!canAuthenticate){
            Send.message(context, "Your Device doesn't support Authentication ! Please install to Android Nougat and above",false);
          }else{
            Send.message(context, "${e}",false);
          }
        }
      },
      child: Column(
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
      ),
    );
  }
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return InkWell(
      onTap: () async {
        final LocalAuthentication auth = LocalAuthentication();
        final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
        final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        try {
          final bool didAuthenticate = await auth.authenticate(localizedReason: 'Please authenticate to approve Login Request of $str');
          print(didAuthenticate);
          if(didAuthenticate){
            Navigator.push(
                context,
                PageTransition(
                    child:SeeAllRequest(id: widget.user.id, tofind: str, history: str=="History",),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 10)));
          }else{
            Send.message(context, "Authentication is Reqired to give Access",false);
          }
        } catch(e) {
          if(!canAuthenticate){
            Send.message(context, "Your Device doesn't support Authentication ! Please install to Android Nougat and above",false);
          }else{
            Send.message(context, "${e}",false);
          }

        }
      },
      child: Column(
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
      ),
    );
  }


  Widget f(BuildContext context, String asset, String str) {
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

