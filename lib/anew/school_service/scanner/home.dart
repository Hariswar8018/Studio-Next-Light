import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/attendance/sc.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/loginnow_function/school_find.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';

class HomePhoto extends StatefulWidget {
  UserModel  user ;
  HomePhoto({super.key,required this.user});

  @override
  State<HomePhoto> createState() => _HomePhotoState();
}

class _HomePhotoState extends State<HomePhoto> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      drawer:Global.buildDrawer(context),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff029A81),
        leading:InkWell(
          onTap:() {
            _scaffoldKey.currentState?.openDrawer();  // Opens the drawer
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.more_vert,color: Color(0xff029A81),size: 22,)),
            ),
          ),
        ),
        title: Text("Student ID Card Scanner",style:TextStyle(color:Colors.white)),
      ),
      body: Column(
        children: [
          Image.asset("assets/images/school/6a722891e9c4d619362b66c545f9d0d2567543cb-853x480.gif",width: w),
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
              if(widget.user.schoolid.isEmpty){
                Send.message(context, "No School Id Attached. First find School, and request Access",false);
              }else if(!widget.user.probation){
                Send.message(context, "School have not yet given you Request to Scan",false);
              }else{
                soop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.user.probation?Colors.blue:Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    Image.asset(height: 80,
                        "assets/images/school/7994392.gif"),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scan to Mark Attendance',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Scan Student Card to mark Present',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('to Students Directly',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40,),
          InkWell(
            onTap: () async {
                SchoolModel user = await Navigator.push(
                    context, PageTransition(
                    child: FindSchool(str:"Apply for Photographer"),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 50)
                ));
                try{
                if(user!=null){
                  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                    "school":user.Name,
                    "schoolid":user.id,
                    "pic":user.Pic,
                  });
                  Send.message(context, "Success : Your Request sent to School for Approval",true);
                }
              }catch(e){
                Send.message(context, "$e",false);
              }
            },
            child: widget.user.schoolid.isEmpty?Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.user.probation?Colors.blue:Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.perm_identity_sharp,color: Colors.blue,),
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request School',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Now ask Permission from School',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('to be added as Scanner',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ):Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.user.pic),
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.school,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text("Waiting for Approval from School",
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.red),),
                        Text('Do Contact if delay !',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.red),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.user.probation?Colors.blue:Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                   CircleAvatar(
                     backgroundColor: Colors.red,
                     radius: 30,
                   ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Complete Profile',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Add basic Details like Phone, Adhaar',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('and basic other Details',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void soop(BuildContext context){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("What are the Student's doing ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 19)),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:[
                        FlutterSwitch(
                          showOnOff: true,
                          activeTextColor: Colors.black,
                          inactiveTextColor: Colors.blue,
                          value: smsend,
                          onToggle: (val) {
                            if(widget.user.smsend){
                              setState(() {
                                smsend = val;
                              });
                              Navigator.pop(context);
                              soop(context);
                            }else{
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("You don't have SMS Sending Premium Service"),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(width: 12.0,),
                        Text('Send SMS : $smsend', style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0
                        ),)
                      ]
                  ),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QRViewExample(
                                          str: widget.user.school,
                                          id: widget.user.sessionid,sms:smsend,
                                          status: "In")),
                            );
                          },
                          child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(
                                  context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        "https://img.freepik.com/premium-vector/outside-building-boys-student-back-school_24911-48530.jpg"),
                                    Text("Check IN",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w700))
                                  ])),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QRViewExample(
                                          str: widget.user.school,
                                          id: widget.user.schoolid,sms: smsend,
                                          status: "Out")),
                            );
                          },
                          child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(
                                  context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  3 -
                                  30,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        "https://static.vecteezy.com/system/resources/thumbnails/005/710/735/small_2x/cartoon-the-children-going-home-after-school-vector.jpg"),
                                    Text("Check OUT",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w700))
                                  ])),
                        )
                      ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool smsend = false ;
}
