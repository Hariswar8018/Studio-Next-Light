
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/model/school_model.dart';

import '../function/send.dart';

class FindSchool extends StatefulWidget {
  String str;
  FindSchool({super.key,required this.str});

  @override
  State<FindSchool> createState() => _FindSchoolState();
}

class _FindSchoolState extends State<FindSchool> {
  final _emailController = TextEditingController();

  bool Stream=false;
  String photo="",name="",address="";

  SchoolModel user1 = SchoolModel(Address: "Address", csession: "csession", Email: "Email", Name: "Name", Pic_link: "Pic_link", Students: 0,
    Pic: "Pic", id: "id", Adminemail: "Adminemail", Clientemail: "Clientemail", Phone: "Phone", AuthorizeSignature: "AuthorizeSignature", uidise: "uidise", Chief: "Chief",
    b: false, EmailB: false, BloodB: false, DepB: false, MotherB: false, RegisB: false, Other1B: false, Other2B: false, Other3B: false, Other4B: false,
    TReceice: [], TPaid: [], TMonth: [], TYear: [], total: 0, complete: 0, pending: 0, receive: 0, premium: false,
    SpName: "SpName", totse: 0, stampp: "stampp", paidp: "paidp",
    smsend: false, weatherlastupdate: '', lon: 566, lat: 878, weather: '', wind: 0.0, temp: 0.0,
    humidity: 0.0, pressure: 0.0, j: 0, token1: "", token2:"huk",
  );

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Stream?Scaffold(
      backgroundColor:Colors.white,
      body:Center(child: Image.asset("assets/images/login/search.gif")),
    ):Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
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
        title: Text("Find School"),
      ),
      body: Container(
        width: w,height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90,),
            Center(
              child: Container(
                  width:w-40,height:300,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          image:AssetImage("assets/images/login/search2.gif"),
                          fit: BoxFit.contain
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text("Search by UDISE of School",
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text("Find the School by Typing UDISE of School",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 12,),
            name.isEmpty?Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'School UDISE',  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your School email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {

                },
              ),
            ):Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blue,
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
                      backgroundImage: NetworkImage(photo),
                      radius: 30,
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text(user1.Address,
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
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
            SizedBox(height: 10.0),
            InkWell(
              onTap: () async {
                setState(() {
                  Stream=true;
                });
                if(name.isEmpty){
                  try {
                    CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                    QuerySnapshot querySnapshot = await usersCollection.where('UIDSE', isEqualTo: _emailController.text).get();
                    if (querySnapshot.docs.isNotEmpty) {
                      SchoolModel user = SchoolModel.fromSnap(querySnapshot.docs.first);
                      Send.message(context, "Found ${user.Name}",true);
                      setState(() {
                        user1=user;
                        Stream=false;
                        photo=user.Pic_link;
                        name=user.Name;
                        address=user.Address;
                      });

                    } else {
                      Send.message(context, "No School found with Current UDISE",false);
                      setState(() {
                        Stream=false;
                      });
                    }
                  } catch (e) {
                    print("Error fetching user by uid: $e");
                    Send.message(context, "${e}",false);
                    setState(() {
                      Stream=false;
                    });
                  }
                }else{
                  setState(() {
                    Stream=false;
                  });
                  gh();
                  Navigator.pop(context,user1);
                }
              },
              child: Center(
                child: Container(
                  height:45,width:w-20,
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
                  child: Center(child: Text(name.isEmpty?"Search School":"Confirm this School",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Container(
                width: w-100,height: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login/design.png"),
                    )
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  void gh(){
    try{
      Send.sendNotification("Noticiate for Request of Access !", "Someone had ${widget.str}", user1.token2);
    }catch(e){

    }
    try{
      Send.sendNotification("Noticiate for Request of Access !", "Someone had ${widget.str}", user1.token1);
    }catch(e){

    }
  }
}
