import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';

class FormCode extends StatefulWidget {
  StudentModel user;

  bool google;
  FormCode({super.key,required this.google,required this.user});

  @override
  State<FormCode> createState() => _FormCodeState();
}

class _FormCodeState extends State<FormCode> {
  bool done=true;bool round=false;
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ),
        title: Text("Security Question",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Center(
            child: Container(
                width:w-40,height:300,
                decoration:BoxDecoration(
                    image:DecorationImage(
                        image:AssetImage(widget.google?"assets/images/school/principal.png":"assets/images/login/Back-to-School-Illustration.jpg"),
                        fit: BoxFit.contain
                    )
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
            child: Text("Type "+(widget.google?"Phone Number":"Email")+" to Verify",
              style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0,right: 14),
            child: Center(
              child: Text("Put the Number / Email as presented in ID Card",
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ),
          ),
          SizedBox(height: 12,),
          InkWell(
            child: round?Center(child: CircularProgressIndicator(),):Center(
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
                child: Center(child: Text("Confirm the "+(widget.google?"Phone":"Email"),style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget c(TextEditingController c,String str){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: str,  isDense: true,
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
    );
  }
}

