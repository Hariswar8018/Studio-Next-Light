import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Class_In_Out extends StatefulWidget {
  String id; bool r ; String name ; bool premium ;
  String session_id; bool rem;  String sname ;
  bool showonly;
  Class_In_Out({super.key, required this.id,required this.showonly, required this.r, required this.premium,  required this.name, required this.sname,required this.session_id,  required this.rem});

  @override
  State<Class_In_Out> createState() => _Class_In_OutState();
}

class _Class_In_OutState extends State<Class_In_Out> {
  List<SessionModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.orange,
          title: Text(widget.sname+" ( Check In / Check Out )"),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(widget.id).collection('Session').doc(widget.session_id).collection("Class").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => SessionModel.fromJson(e.data()))
                  .toList() ??
                  [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                      user: list[index], id: widget.id, sessionid: widget.session_id, r : widget.r , name : widget.name,
                      rem : widget.rem, sname : widget.sname, pr : widget.premium,showonly: widget.showonly,
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class ChatUser extends StatefulWidget {
  SessionModel user; bool pr ;
  String id ;  String sname ; bool showonly;
  String sessionid;  bool rem ; bool r ; String name ;
  ChatUser({super.key, required this.user,required this.sname, required this.showonly,required this.pr,  required this.r, required this.name,  required this.id, required this.sessionid,  required this.rem});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int i = 0 ; int j = 0 ;

  void initState(){
    countDocumentsWithPresent();
    countDocumentsWithPresent1();
  }

  void as() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('School')
        .doc(widget.id).collection('Session')
        .doc(widget.sessionid).collection('Class');
    await collection.doc(widget.user.id).update({
      "pcount" : i,
    });
  }
  void countDocumentsWithPresent() async {
    int count = 0;
    DateTime date = DateTime.now();
    String str = '${date.day}-${date.month}-${date.year}';

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc(widget.sessionid)
          .collection("Class")
          .doc(widget.user.id)
          .collection("Student")
          .where("Present", arrayContains: str)
          .get();

      count = querySnapshot.docs.length;

      setState(() {
        i = count;
      });

      CollectionReference collection = FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc(widget.sessionid)
          .collection('Class');

      await collection.doc(widget.user.id).update({
        "pcount": count,
      });

    } catch (error) {
      print("Error counting documents: $error");
    }
  }

  void countDocumentsWithPresent1() async {
    int count = 0;
    DateTime date = DateTime.now();
    String str = '${date.day}-${date.month}-${date.year}';

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc(widget.sessionid)
          .collection("Class")
          .doc(widget.user.id)
          .collection("Student")
          .where("Present1", arrayContains: str)
          .get();

      count = querySnapshot.docs.length;

      setState(() {
        ij = count;
      });

      CollectionReference collection = FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Session')
          .doc(widget.sessionid)
          .collection('Class');

      await collection.doc(widget.user.id).update({
        "pcount1": count,
      });

    } catch (error) {
      print("Error counting documents: $error");
    }
  }

  int ij=0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Class : " + widget.user.Name),
      onTap: () async {
        print(widget.rem);
        if ( widget.rem ){
          print("Gone be");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>Students(sname : widget.sname, rem : widget.rem,id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
                Class : widget.user.Name, h: widget.r, st: widget.name , premium : widget.pr,showonly: widget.showonly,
            )),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>Students(sname : widget.sname, rem : widget.rem,id: widget.id, session_id: widget.sessionid, class_id: widget.user.id,
                Class : widget.user.Name, h: widget.r, st: widget.name , premium : widget.pr,showonly: widget.showonly,
            )),
          );
        }

      },
      trailing : RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            widget.user.id=="hg"?
            TextSpan(
              text: addCommas(i),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.blue, fontSize : 23),
            ):TextSpan(
              text: addCommas(ij),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.red, fontSize : 23),
            ),
            TextSpan(
              text: " out",
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.blue, fontSize : 13),
            ),
            TextSpan(
              text: ' / ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: addCommas(i),
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.blue, fontSize : 18),
            ),
            TextSpan(
              text: " in",
              style: TextStyle(fontWeight: FontWeight.bold, color : Colors.blue, fontSize : 13),
            ),
          ],
        ),
      ),
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }
  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return  formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) + ',' + formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    formattedNumber =  formattedNumber ;
    return formattedNumber;
  }
}

class Students extends StatefulWidget {
  String id; bool premium ;
  String session_id;
  String class_id;
  String Class;
  bool rem;   // Not Yet
  String sname ;
  String st ;
  bool h ; // Editing Attendance
  bool showonly;
   Students({super.key,required this.showonly,
     required this.id, required this.sname,
     required this.session_id, required this.premium,
     required this.class_id,
     required this.rem, required this.h, required this.st,
     required this.Class,});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
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
          backgroundColor: Colors.orange,
          title: Text('Students Data'),
        actions: [
          IconButton(onPressed: (){
            print(list);
            }, icon: Icon(Icons.abc_outlined))
        ],
      ),
      body:widget.showonly?
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('School')
            .doc(widget.id)
            .collection('Session')
            .doc(widget.session_id)
            .collection("Class")
            .doc(widget.class_id)
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
              DateTime now = DateTime.now();
              String currentDate = '${now.day}-${now.month}-${now.year}';

              final filteredData = data.where((e) {
                bool containsTodayInPresent = false;
                bool notContainsTodayInPresent1 = true;

                if (e.data().containsKey('Present') && e['Present'] is List) {
                  containsTodayInPresent = (e['Present'] as List).contains(currentDate);
                }

                if (e.data().containsKey('Present1') && e['Present1'] is List) {
                  notContainsTodayInPresent1 = !(e['Present1'] as List).contains(currentDate);
                }

                return containsTodayInPresent && notContainsTodayInPresent1;
              }).toList();

              final list = filteredData.map((e) => StudentModel.fromJson(e.data())).toList();
              if (list.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.blue, size: 30),
                    SizedBox(height: 10),
                    Center(
                      child: Text("No Student Present Today"),
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
                      user: list[index],showonly: widget.showonly,
                      id: widget.id,
                      session_id: widget.session_id,
                      class_id: widget.class_id,
                      h: widget.h,
                      r: true,
                      length: list.length,
                      sname: widget.sname,
                      st: widget.st,
                      b: widget.rem,
                    );
                  },
                );
              }
          }
        },
      )
          :
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('School')
            .doc(widget.id)
            .collection('Session')
            .doc(widget.session_id)
            .collection("Class")
            .doc(widget.class_id)
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
              DateTime now = DateTime.now();
              String currentDate = '${now.day}-${now.month}-${now.year}';

              final filteredData = data.where((e) {
                if (e.data().containsKey('Present') && e['Present'] is List) {
                  return (e['Present'] as List).contains(currentDate);
                }
                return false; // Ignore documents that don't have the "Present" field or don't contain the current date.
              }).toList();

              final list = filteredData.map((e) => StudentModel.fromJson(e.data())).toList();
              if(list.isEmpty){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline,color: Colors.blue,size: 30,),
                    SizedBox(height: 10,),
                    Center(
                      child: Text("No Student Present Today"),
                    ),
                  ],
                );
              }else{
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return StudentUser(
                      user: list[index],
                      id: widget.id,
                      session_id: widget.session_id,
                      class_id: widget.class_id,
                      h: widget.h,
                      r: true,
                      length: list.length,
                      sname: widget.sname,
                      st: widget.st,showonly: widget.showonly,
                      b: widget.rem,
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

  StudentUser({
    super.key, required this.h , required this.r,
    required this.user,required this.showonly,
    required this.sname,
    required this.length, required this.st, required this.b,
    required this.id,
    required this.session_id,
    required this.class_id,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        Navigator.push(
            context,
            PageTransition(
                child: StudentProfileN(
                  user: user, schoolid: id, classid: class_id, sessionid:session_id,
                ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 800)));
      },
      trailing:   acheck(),
      onLongPress: () async {
        Uri uri = Uri.parse("tel:91"+user.Mobile);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
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
