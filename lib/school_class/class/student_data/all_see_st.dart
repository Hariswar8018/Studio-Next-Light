
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/aextra2/Attendance/class_in_out.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Studentsn extends StatelessWidget {
  String id; bool premium ;
  String session_id;
  String class_id;
  String Class;
  bool rem;   // Not Yet
  String sname ;
  String st ;
  bool h ; // Editing Attendance
  bool parents_verify;
  bool showonly;
  Studentsn({super.key,required this.showonly,
    required this.id, required this.sname,
    required this.session_id, required this.premium,
    required this.class_id,this.parents_verify=false,
    required this.rem, required this.h, required this.st,
    required this.Class,});

  late Map<String, dynamic> userMap;

  List<StudentModel> list = [];

  DateTime now = DateTime.now();

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text('My Class Students'),
        actions: [
          IconButton(onPressed: (){
            print(list);
          }, icon: Icon(Icons.abc_outlined,color: Colors.white,))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('School')
            .doc(id)
            .collection('Session')
            .doc(session_id)
            .collection("Class")
            .doc(class_id)
            .collection("Student")
            .orderBy('Name', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs ?? [];
              list = data
                  ?.map((e) => StudentModel.fromJson(e.data()))
                  .toList() ??
                  [];
              if (list.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.blue, size: 30),
                    SizedBox(height: 10),
                    Center(
                      child: Text("No Student Found"),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return StudentUser(
                      user: list[index],showonly: showonly,
                      id: id,
                      session_id: session_id,
                      class_id: class_id,
                      h: h,
                      r: true,
                      length: list.length,
                      sname: sname,
                      st: st,
                      b: rem, parents_verify: parents_verify,
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}


class StudentUser extends StatelessWidget {
  StudentModel user;bool showonly;
  bool parents_verify;
  int length; bool h ; //attendance edit
  String st ; bool b ; // not yet
  String id;
  bool r ; //message

  String session_id;
  String sname ;
  String class_id;

  StudentUser({
    super.key, required this.h , required this.r,
    required this.user,required this.showonly,
    required this.sname,
    required this.length, required this.st, required this.b,
    required this.id,required this.parents_verify,
    required this.session_id,
    required this.class_id,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return showonly? ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          user.Roll_number.toString() +
          "   Class : " +
          user.Class +" ("+
          user.Section+")"),
      onTap : () async {
        if(parents_verify){
          CustomBottomSheet.show(
            context: context,
            child:  Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  width: w-10,
                  child: Column(
                    children: [
                      SizedBox(height:15),
                      Center(child: Text(textAlign: TextAlign.center,'Parents could Verify using this methods',style: TextStyle(fontWeight:FontWeight.w800,fontSize: 19),)),
                      Center(child: Text(textAlign: TextAlign.center,'Please Login as Parent, use UDISE Code, than find Student and use one of Method to verify Code',style: TextStyle(fontWeight:FontWeight.w300,fontSize: 12),)),
                      SizedBox(height:8),
                      ListTile(
                        leading: Icon(Icons.mail,color: Colors.red,),
                        title: Text(user.Email,style: TextStyle(fontWeight: FontWeight.w800),),
                        subtitle: Text("Use this Email to get OTP and Verify"),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone,color: Colors.green,),
                        title: Text(user.Email,style: TextStyle(fontWeight: FontWeight.w800),),
                        subtitle: Text("Use this Phone to get OTP and Verify"),
                      ),
                      ListTile(
                        leading: Icon(Icons.code,color: Colors.orange,),
                        title: Text(user.backcod.toString(),style: TextStyle(fontWeight: FontWeight.w800),),
                        subtitle: Text("Use the BackUp Codes to Verify"),
                      ),
                      ListTile(
                        leading: Icon(Icons.security,color: Colors.indigo,),
                        title: Text("Not yet Registered",style: TextStyle(fontWeight: FontWeight.w800),),
                        subtitle: Text("Use the Authenticaor App to get Code"),
                      ),
                    ],
                  )),
            ),
          );
        }else{
          Navigator.push(
              context,
              PageTransition(
                  child: StudentProfileN(
                    user: user, schoolid: id, classid: class_id, sessionid:session_id,
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 50)));
        }

      },
      trailing:   acheck(),
      onLongPress: () async {
        Uri uri = Uri.parse("tel:91"+user.Mobile);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    ): InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageTransition(
                child: BackUpCode(
                  user: user, schoolid: id, classid: class_id, sessionid:session_id,
                ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 50)));
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.pic),
              ),
              title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text("Roll no : " +
                  user.Roll_number.toString() +
                  "   Class : " +
                  user.Class +" ("+
                  user.Section+")"),
              splashColor: Colors.orange.shade300,
              tileColor: Colors.grey.shade50,
            ),
            Container(
              width: w-30,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(
                  color: Colors.blue,
                  width: 0.5
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Text("   See / Regenerate Security Codes"),
                  Spacer(),
                  Icon(Icons.arrow_forward,color: Colors.blue,size: 16,),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  Widget acheck(){
    DateTime now = DateTime.now();
    String stm = '${now.day}-${now.month}-${now.year}';
    print(user.Name+user.present.toString()+user.present1.toString());


    if ( user.present.contains(stm)) {
      if(user.present1.contains(stm)){
        return Text("Both Done", style : TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color : Colors.red));
      }
      return Text("Pending Out", style : TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color : Colors.blue));
    }else {
      return Text("Absent", style : TextStyle(fontSize:17, fontWeight: FontWeight.w800, color : Colors.red));
    }
  }

  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) +
          ',' +
          formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    return formattedNumber;
  }
}

class BackUpCode extends StatelessWidget {
  String schoolid, sessionid, classid ;
  StudentModel user;
   BackUpCode({super.key,required this.user, required this.schoolid, required this.classid, required this.sessionid});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Backup Codes"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.pic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(user.Name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
          ),
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("MY BACKUP CODES",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Container(
                width: w-30,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(10)
               ),
                child: Row(
                  children: [
                   c(w,user.backcod[0].toString(),user.backcod[1].toString(),user.backcod[2].toString()),
                    c(w,user.backcod[3].toString(),user.backcod[4].toString(),user.backcod[5].toString()),
                  ],
                ),
              ),
            ),
          ),
          Text("Save this Backup code somewhere Safe ! "),
        ],
      ),
      persistentFooterButtons: [
        SocialLoginButton(
          backgroundColor: Colors.blue,
          height: 40,
          text: 'Regenerate Codes', textColor: Colors.white,
          borderRadius: 20,
          fontSize: 21,
          buttonType: SocialLoginButtonType.generalLogin,
          onPressed: () async {
            final LocalAuthentication auth = LocalAuthentication();
            final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
            final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
            try {
              final bool didAuthenticate = await auth.authenticate(localizedReason: 'Please authenticate to Backup student code');
              print(didAuthenticate);
              if(didAuthenticate){
                List<String> l1=[];
                for(int i=0;i<=5;i++){
                  var random=Random();
                  int randomNumber = 100000+random.nextInt(888888);
                  l1.add(randomNumber.toString());
                  print(randomNumber.toString());
                }
                print(l1);
                CollectionReference collection = FirebaseFirestore.instance.collection(
                    'School').doc(schoolid).collection('Session').doc(sessionid)
                    .collection('Class').doc(classid)
                    .collection("Student");
                await collection.doc(user.Registration_number).update({
                  "backcod":l1,
                });
                Navigator.pop(context);
                Send.message(context, "Done ! Backup Regenerated",true);
              }else{
                Send.message(context, "Authentication is Reqired to regenerate code",false);
              }
            } catch(e) {
              if(!canAuthenticate){
                Send.message(context, "Your Device doesn't support Authentication ! Please install to Android Nougat and above",false);
              }else {
                Send.message(context, "${e}",false);
              }}
            },
        ),
      ],
    );
  }
  Widget c(double w,String s1,String s2, String s3)=> Container(
    width: w/2-15,
    child: Column(
      children: [
        SizedBox(height: 20,),
        code(s1,w),
        SizedBox(height: 10,),
        code(s2,w),
        SizedBox(height: 10,),
        code(s3,w),
        SizedBox(height: 10,),
        SizedBox(height: 10,),
      ],
    ),
  );
  Widget code(String s,double w)=>Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.grey.shade100
      )
    ),
    child: Padding(
    padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 15,right: 15),
    child: Text(s,style: TextStyle(fontSize: w/17,letterSpacing: 5,fontWeight: FontWeight.w800),),
  ),);
}


class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Theme.of(context).canvasColor,
      elevation: elevation ?? 8.0,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => child,
    );
  }
}