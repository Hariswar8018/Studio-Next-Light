import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/bus/make_route.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/bus.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusCreate extends StatelessWidget {
   BusCreate({super.key,required this.userr});
  SchoolModel userr;

  TextEditingController email=TextEditingController();
   TextEditingController password=TextEditingController();
   TextEditingController name=TextEditingController();
   TextEditingController name2=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BusModel.color,
        title: Text("Create Bus Login "),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          Row(
            children: [
              SizedBox(width: 19,),
              Icon(Icons.email,color: Colors.red,),
              Text(" Credentials"),
            ],
          ),
          SizedBox(height: 4,),
          Send.fg(email, "Bus Login Email", ""),
          Send.fg(password, "Bus Login Password", ""),
          SizedBox(height: 15,),
          Row(
            children: [
              SizedBox(width: 19,),
              Icon(Icons.bus_alert,color: Colors.red,),
              Text(" Bus Details"),
            ],
          ),
          SizedBox(height: 4,),
          Send.fg(name, "Bus Name", "A3"),
          Send.fg(name2, "Bus Route Name", "Delhi, South Delhi, Haziabad"),
          InkWell(
              onTap: () async {
                try {
                  final cred = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: email.text, password: password.text);
                  final id = cred.user!.uid;
                  print(id);
                  print(userr.id);
                  await FirebaseAuth.instance.signOut();
                  BusModel user = BusModel(uid: id,
                      id: id,
                      name: name.text,
                      number: userr.id,
                      timing: "",
                      timing2: "",
                      pic: "",
                      routeId: name2.text, iseditable: true, couldadd: true, sessionid: userr.csession, schoolname: userr.Name, people: [], tokens: [], date: DateTime.now());
                  await FirebaseFirestore.instance.collection("Bus").doc(id).set(user.toJson());
                  Navigator.push(
                      context,
                      PageTransition(
                          child:BusRouteScreen(routeid: id, neww: true, id: id,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 10)));
                  Send.message(context, "Now Create Route", true);
                }catch(e){
                  try{
                    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                    final id = cred.user!.uid;
                    BusModel user = BusModel(uid: id, date: DateTime.now(),
                        id: id,
                        name: name.text,
                        number: userr.id,
                        timing: "",
                        timing2: "",
                        pic: "",
                        routeId: name2.text,
                        iseditable: true, couldadd: true,
                        sessionid: userr.csession,
                        schoolname: userr.Name, people: [], tokens: []);
                    await FirebaseFirestore.instance.collection("Bus").doc(id).set(user.toJson());
                    Navigator.push(
                        context,
                        PageTransition(
                            child:BusRouteScreen(routeid: id, neww: true, id: id,),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 10)));
                    Send.message(context, "Now Create Route", true);
                  }catch(e1){
                    Send.message(context, "$e1", false);
                  }
                  Send.message(context, "$e", false);
                }finally{
                  as(context);
                }
              },
              child: Send.button(context, "Create Bus"))
        ],
      ),
    );
  }

  void as(BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? emaill = prefs.getString('Email') ?? "NONE";
      String? passwordd = prefs.getString('Password') ?? "NONE";
      print(emaill);
      print(passwordd);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emaill,
        password: passwordd,
      );
      print(credential);
      Send.message(context, "Currently your School Listening.........Continue Creating Account", true);
    }catch(e){
     await  FirebaseAuth.instance.signOut();
     prefs.setBool('Admin',false)  ;
     prefs.setBool('Parent',false) ;
     prefs.setString('What',"None") ;
     Send.message(context, "School Listening Failed......You may need to Login again", false);
    }
  }
}
