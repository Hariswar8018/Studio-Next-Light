
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/anew/parents/home/gatepass/gatepass.dart';
import 'package:student_managment_app/function/send.dart';

class Historyy extends StatelessWidget {
  String str;bool verify;
  Historyy({super.key,required this.str,required this.verify});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text(!verify?"Gate Pass Onboarding":"Gate Pass Pending Status",style: TextStyle(color: Colors.white),),
      ),
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School').doc(str).collection("Pass").snapshots() ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network("https://cdn-icons-png.freepik.com/512/7486/7486744.png", width : MediaQuery.of(context).size.width - 200),
                  Text(
                    "No found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks like there's isn't any History", textAlign : TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => GatePassForm.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Noticec(user: _list[index],id: str);
            },
          );
        },
      ) ,
    );
  }
  List<GatePassForm> _list = [];
}

class Noticec extends StatelessWidget {
  GatePassForm user;String id;
  Noticec({super.key,required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        donee(context, w);
      },
      child: Card(
        color: user.accepted?Colors.green.shade50:Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user.stname.isEmpty?ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    user.stpic
                ),
              ),
              title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13),),
              subtitle: Text("Reason opted for "+user.reason,style: TextStyle(fontSize: 11),),
              trailing: Text(user.status,style: TextStyle(color: Colors.red,fontSize: 10,fontWeight: FontWeight.w700),),
            ):ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    user.stpic
                ),
              ),
              title: Text(user.name + " as parent of "+user.stname,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),),
              subtitle: Text("Reason for Visiting : "+user.reason,style: TextStyle(fontSize: 11),),
              trailing: Text(user.status,style: TextStyle(color: Colors.red,fontSize: 10,fontWeight: FontWeight.w700),),
            ),
            user.stname.isEmpty?Row(
              children: [
                Text("    "),
                Icon(Icons.settings_accessibility,size: 15,color: Colors.red,),
                Text(" Guest Request",style: TextStyle(color: Colors.red,fontSize: 9),),
                Text("    "),
                user.verified?Icon(Icons.verified_user_rounded,size: 15,color: Colors.green,):Icon(Icons.close,size: 15,color: Colors.red,),
                user.verified?Text(" Verified : YES",style: TextStyle(color: Colors.green,fontSize: 9),):Text(" Verified : NO",style: TextStyle(color: Colors.red,fontSize: 9),)
              ],
            ):Row(
              children: [
                Text("    "),
                Icon(Icons.child_friendly_outlined,size: 15,color: Colors.green,),
                Text(" Parents Request",style: TextStyle(color: Colors.green,fontSize: 9),),
                Text("    "),
                Icon(Icons.verified_user_rounded,size: 15,color: Colors.green,),
                Text(" Verified : YES",style: TextStyle(color: Colors.green,fontSize: 9),)
              ],
            ),
            Text("      Date & Time opted for : ${s(user.time)}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 10),),
            gt(),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  Widget gt(){
    if(user.status=="Accepted for that Time"){
      return SizedBox();
    }else{
      try {
        DateTime dateTime = DateTime.parse(user.time2);
        String formattedTime = DateFormat('dd/MM/yy on HH:mm').format(dateTime);
        if(user.status=="Video Verification Required"){
          return Text("     Date & Time video verification for : ${formattedTime}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 12),);
        }else{
          return Text("     Date & Time accepted for : ${formattedTime}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 12),);
        }
        } catch (e) {
        return SizedBox(); // Return "NA" if parsing fails
      }
    }
  }
  String s(String entry) {
    try {
      DateTime dateTime = DateTime.parse(entry);
      String formattedTime = DateFormat('dd/MM/yy on HH:mm').format(dateTime);
      return formattedTime;
    } catch (e) {
      return "NA"; // Return "NA" if parsing fails
    }
  }

  void donee(BuildContext context,double w){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: SizedBox(
            height: 650,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Icon(Icons.verified_rounded,size:100,color:Colors.green),
                  Text("Confirm to give GatePass?",style:TextStyle(fontWeight: FontWeight.w800,fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(textAlign: TextAlign.center,"By Confirming Access, The Parent / User could access frontier of School subjected to Terms & Condition"),
                  ),
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SocialLoginButton(
                      backgroundColor:  Color(0xff6001FF),
                      height: 40,
                      text: 'Accept the DateTime',
                      borderRadius: 20,
                      fontSize: 21,
                      buttonType: SocialLoginButtonType.generalLogin,
                      onPressed: ()async{
                        try {
                          await FirebaseFirestore.instance.collection("School")
                              .doc(id).collection("Pass").doc(user.id)
                              .update({
                            "accepted": true,
                            "status":"Accepted for that Time",
                          });
                          Navigator.pop(context);
                          Send.sendNotificationsToTokens("Gate Request Accepted", "Your Request was Just accepted by Principal/School", user.token);
                          Send.message(context, "Done ! Notifying", true);
                        }catch(e){
                          Send.message(context, "${e}",false);
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: w/2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SocialLoginButton(
                            backgroundColor: Colors.blue,
                            height: 40,
                            text: 'Change DateTime',
                            borderRadius: 20,
                            fontSize: 19,
                            buttonType: SocialLoginButtonType.generalLogin,
                            onPressed: ()async{
                              try{
                              Navigator.pop(context);
                              DateTime? dateTimeList =
                              await showOmniDateTimePicker(
                                context: context,
                                is24HourMode: false,
                                isShowSeconds: false,
                                minutesInterval: 1,
                                secondsInterval: 1,
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                constraints: const BoxConstraints(
                                  maxWidth: 350,
                                  maxHeight: 650,
                                ),
                                transitionBuilder: (context, anim1, anim2, child) {
                                  return FadeTransition(
                                    opacity: anim1.drive(
                                      Tween(
                                        begin: 0,
                                        end: 1,
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 200),
                                barrierDismissible: true,
                                selectableDayPredicate: (dateTime) {
                                  // Disable 25th Feb 2023
                                  if (dateTime == DateTime(2023, 2, 25)) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                },
                              );
                              await FirebaseFirestore.instance.collection("School")
                                  .doc(id).collection("Pass").doc(user.id)
                                  .update({
                                "accepted": true,
                                "status":"Time Changed",
                                "time2":dateTimeList.toString(),
                              });
                              Send.sendNotificationsToTokens("Gate Request Accepted but Time changed", "Your Request was Just accepted by Principal/School but time had changed", user.token);
                              Send.message(context, "Parent confirmed ! Will be Notified same for GatePass",true);
                              }catch(e){
                                Send.message(context, "${e}",false);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: w/2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SocialLoginButton(
                            backgroundColor:  Colors.green,
                            height: 40,
                            text: 'Verify Required',
                            borderRadius: 20,
                            fontSize: 19,
                            buttonType: SocialLoginButtonType.generalLogin,
                            onPressed: ()async{
                              try{
                                Navigator.pop(context);
                                DateTime? dateTimeList =
                                await showOmniDateTimePicker(
                                  context: context,
                                  is24HourMode: false,
                                  isShowSeconds: false,
                                  minutesInterval: 1,
                                  secondsInterval: 1,
                                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                                  constraints: const BoxConstraints(
                                    maxWidth: 350,
                                    maxHeight: 650,
                                  ),
                                  transitionBuilder: (context, anim1, anim2, child) {
                                    return FadeTransition(
                                      opacity: anim1.drive(
                                        Tween(
                                          begin: 0,
                                          end: 1,
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 200),
                                  barrierDismissible: true,
                                  selectableDayPredicate: (dateTime) {
                                    // Disable 25th Feb 2023
                                    if (dateTime == DateTime(2023, 2, 25)) {
                                      return false;
                                    } else {
                                      return true;
                                    }
                                  },
                                );
                                await FirebaseFirestore.instance.collection("School")
                                    .doc(id).collection("Pass").doc(user.id)
                                    .update({
                                  "accepted":false,
                                  "status":"Video Verification Required",
                                  "time2":dateTimeList.toString(),
                                });
                                Send.sendNotificationsToTokens("Video Verification Required for Gate Pass", "Your Request needs Video Verification Required for Gate Pass", user.token);
                                Send.message(context, "Time Video Verification Sent Invitation ! Will be Notified same for GatePass",true);
                              }catch(e){
                                Send.message(context, "${e}",false);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SocialLoginButton(
                      backgroundColor:  Colors.red,
                      height: 40,
                      text: 'Reject / Cancel',
                      borderRadius: 20,
                      fontSize: 21,
                      buttonType: SocialLoginButtonType.generalLogin,
                      onPressed: ()async{
                        try{
                          await FirebaseFirestore.instance.collection("School")
                              .doc(id).collection("Pass").doc(user.id)
                              .update({
                            "accepted": false,
                            "status":"Rejected",
                          });
                          Send.sendNotificationsToTokens("Gate Request Rejected", "Your Request was Just rejected", user.token);
                          Send.message(context, "Rejected",true);
                        }catch(e){
                          Send.message(context, "${e}",false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}