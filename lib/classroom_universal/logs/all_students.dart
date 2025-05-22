import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/results/any_student.dart';
import 'package:student_managment_app/classroom_universal/logs/logs_warnings.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:url_launcher/url_launcher.dart';

enum logtype {Progress, Report, Logs, Warnings, LoginSecurity}
class Logs extends StatelessWidget {
  logtype type;
  Logs({super.key,required this.type,required this.showonly,
    required this.id, required this.sname,
    required this.session_id, required this.premium,
    required this.class_id,
    required this.rem, required this.h, required this.st,
    required this.Class,});

  late Map<String, dynamic> userMap;
  String id; bool premium ;
  String session_id;
  String class_id;
  String Class;
  bool rem;   // Not Yet
  String sname ;
  String st ;
  bool h ; // Editing Attendance
  bool showonly;
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
                      b: rem, type: type,
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
  int length; bool h ; //attendance edit
  String st ; bool b ; // not yet
  String id;
  bool r ; //message

  String session_id;
  String sname ;
  String class_id;
  logtype type;

  StudentUser({
    super.key, required this.h , required this.r,
    required this.user,required this.showonly,
    required this.sname,
    required this.length, required this.st, required this.b,
    required this.id,
    required this.session_id,
    required this.class_id,required this.type
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      onTap: (){
        if(type==logtype.Progress||type==logtype.Report){
          Navigator.push(
              context,
              PageTransition(
                  child:StudentAnyResult(id: id, session_id: session_id, class_id: class_id, admin: false, student: user,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 10)));
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LogsWarnings(
                    h:h, r: r, sname: sname,showonly: showonly,
                    st: st, length: length, b: b, session_id: session_id,
                    class_id: class_id, user: user, type: type.name, id: id,))
          );
        }

      },
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          user.Roll_number.toString() +
          "   Class : " +
          user.Class +" ("+
          user.Section+")"),
      trailing:   Text("0 W  5 Logs"),
      onLongPress: () async {
        Uri uri = Uri.parse("tel:91"+user.Mobile);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
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
