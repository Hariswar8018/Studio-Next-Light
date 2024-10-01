import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/anew/parents/verify/email.dart';
import 'package:student_managment_app/model/student_model.dart';

class Verification_Center extends StatelessWidget {
  StudentModel u;
   Verification_Center({super.key,required this.u});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4489C7),
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
        title: Text("2 Factor Authentication",style:TextStyle(color:Colors.white)),
      ),
      body: Column(
        children: [
          Image.asset("assets/images/login/1696249535129.gif",width: w),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: EmailCode(google:true, user: u,),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 10)));
            },
            child: s(w,"Verify by Phone OTP","Verify by sending SMS","to ${u.Mobile}","assets/images/login/sms-svgrepo-com.svg"),
          ),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: EmailCode(google:false, user: u,),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 10)));
            },
            child: s(w,"Verify by Email OTP","Verify by sending Email","to ${u.Email}","assets/images/login/email-inbox-letter-svgrepo-com.svg"),
          ),
        ],
      ),
    );
  }
  Widget s(double w,String name, String n1,String n2,String asset)=>Padding(
    padding: const EdgeInsets.only(left: 6.0,right: 6,top: 10),
    child: Container(
      width: w-20,
      height:90,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          SizedBox(width: 5,),
          SvgPicture.asset(
            asset,
            semanticsLabel: 'Acme Logo',
            height: 55,width: 55,
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
              SizedBox(height: 3,),
              Text(n1,
                style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
              Text(n2,
                style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
            ],
          ),
          Spacer(),
          "QR"=="QR"? Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
            ),
          ):SizedBox(),
          SizedBox(width: 10,),
        ],
      ),
    ),
  );
}
