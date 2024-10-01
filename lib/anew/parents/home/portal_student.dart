import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/anew/parents/home/profile.dart';
import 'package:student_managment_app/anew/parents/home/sta.dart';
import 'package:student_managment_app/anew/parents/home/ste.dart';
import 'package:student_managment_app/anew/parents/home/studenthome.dart';
import 'package:student_managment_app/anew/parents/home/studentu.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';

import '../../../after_login/class.dart';

class PortalStudent extends StatefulWidget {
  StudentModel st;bool parent;
  PortalStudent({super.key,required this.st,required this.parent});

  @override
  State<PortalStudent> createState() => _PortalStudentState();
}
String mybusid="";
class _PortalStudentState extends State<PortalStudent> {
  int visit = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Are you sure you want to exit?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    // Return false to prevent the app from exiting
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Return true to allow the app to exit
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        );

        // Return the result to handle the back button press
        return exit ?? false;
      },
      child: Scaffold(
        body: as(visit),
        bottomNavigationBar: Container(
          child:  BottomBarDefault(
            items: items,
            backgroundColor: Colors.white,
            color: Colors.black,
            colorSelected: colorSelect,
            indexSelected: visit,

            onTap: (int index) => setState(() {
              visit = index;
            }),
          ),
        ),
      ),
    );
  }
  late SchoolModel userr;
  void initState(){
    f();
    mybusid=widget.st.busid;
  }
  Future<void> f() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Object s= prefs.get("school")??"jhjh";
    print(s.toString());
    String j = s.toString();
    getUserByUid(j);
  }

  void getUserByUid(String uid) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
      QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        SchoolModel usery = SchoolModel.fromSnap(querySnapshot.docs.first);
        setState(() {
          userr=usery;
        });
      } else {
        print("chdhg");
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      print("chdhg");
    }
  }

  Widget as(int i ){
    if( i == 0){
      return StHome(user: widget.st, parent: widget.parent, sch: userr,);
    }else if(i == 1){
      return StA(user: widget.st, parent: widget.parent,);
    }else if(i == 2){
      return StE(user: widget.st, parent: widget.parent,);
    }else if(i == 3){
      return StU(user: widget.st, parent: widget.parent,);
    }else{
      return StProfile(user: widget.st, parent: widget.parent,);
    }
  }

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);
}


const List<TabItem> items = [
  TabItem(
      icon: Icons.dashboard,
      title: "Home"
  ),
  TabItem(
    icon: Icons.accessibility_new,
    title: 'Attendance',
  ),
  TabItem(
      icon: Icons.grade,
      title: "Grades"
  ),
  TabItem(
    icon: Icons.credit_card,
    title: 'Fees',
  ),
  TabItem(
    icon: Icons.person,
    title: 'Profile',
  ),
];
