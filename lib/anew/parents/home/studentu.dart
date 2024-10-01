import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/after_login/my_fee_report_report.dart';
import 'package:student_managment_app/function/send.dart';

import '../../../model/student_model.dart';

class StU extends StatefulWidget {
  StudentModel user; bool parent;
  StU({super.key,required this.parent,required this.user});

  @override
  State<StU> createState() => _StUState();
}

class _StUState extends State<StU> {

  void initState(){
    df();
  }
  int i=0;

  Future<void> df() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('school') ?? "None";
    final String clas = prefs.getString('class') ?? "None";
    final String session = prefs.getString('session') ?? "None";
    final String regist = prefs.getString('id') ?? "None";

    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(session).collection("Class");
      QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: clas).get();

      if (querySnapshot.docs.isNotEmpty) {
        SessionModel user = SessionModel.fromSnap(querySnapshot.docs.first);
        setState(() {
          i=int.parse(user.Total_Fee);
        });
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.blue,
        title:Center(child: Text("Fee Report",style:TextStyle(color:Colors.white))),
      ),
      body: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.start,
          children:[
            Image.asset("assets/fee_report.png",width: w,),
            Card(
              color: Colors.white,
              child: Container(
                width: w-15,
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Total Fee Pending",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                           ],
                      ),
                      Text("₹"+widget.user.Myfee.toString(),style: TextStyle(fontSize: 29,fontWeight: FontWeight.w800,color: Colors.green),),
                      SizedBox(height: 12,),
                      Row(
                        children: [
                          Container(
                            width: w/2-20,
                            child:  Text("Monthly Fees",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                          ),
                          Container(
                            width: w/2-25,
                            child:  Text("Annual Fees",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: w/2-20,
                            child:    Text("₹"+i.toString(),style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.green),),
                          ),
                          Container(
                            width: w/2-25,
                            child:   Text("₹"+(i*12).toString(),style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.green),),
                          ),
                        ],
                      )
                       ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Send.message(context, "School haven't allowed Online Payment now", false);
                  },
                  child: Center(
                    child: Container(
                      height:45,width:w/2-20,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                            spreadRadius: 5, // The extent to which the shadow spreads
                            blurRadius: 7, // The blur radius of the shadow
                            offset: Offset(0, 3), // The position of the shadow
                          ),
                        ],
                      ),
                      child: Center(child: Text("PAY NOW",style: TextStyle(
                          color: Colors.white,
                          fontFamily: "RobotoS",fontWeight: FontWeight.w800
                      ),)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final String id = prefs.getString('school') ?? "None";
                    final String clas = prefs.getString('class') ?? "None";
                    final String session = prefs.getString('session') ?? "None";
                    final String regist = prefs.getString('id') ?? "None";
                    Navigator.push(
                        context,
                        PageTransition(
                            child: MyFR(user:widget.user, school: id,),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 40)));
                  },
                  child: Center(
                    child: Container(
                      height:45,width:w/2-20,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:Colors.deepOrange,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                            spreadRadius: 5, // The extent to which the shadow spreads
                            blurRadius: 7, // The blur radius of the shadow
                            offset: Offset(0, 3), // The position of the shadow
                          ),
                        ],
                      ),
                      child: Center(child: Text("All Transactions",style: TextStyle(
                          color: Colors.white,
                          fontFamily: "RobotoS",fontWeight: FontWeight.w800
                      ),)),
                    ),
                  ),
                ),
              ],
            )
          ]
      ),
    );
  }
}
