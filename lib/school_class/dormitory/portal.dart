import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/loginnow_function/homescreen.dart';
import 'package:student_managment_app/loginnow_function/profile.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/dormitory/chat.dart';
import 'package:student_managment_app/school_class/dormitory/home.dart';
import 'package:student_managment_app/school_class/dormitory/prof.dart';

class DormitoryKeeper extends StatefulWidget {
  UserModel user;
  DormitoryKeeper({super.key,required this.user});

  @override
  State<DormitoryKeeper> createState() => _DormitoryKeeperState();
}

class _DormitoryKeeperState extends State<DormitoryKeeper> {
  int visit = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return widget.user.school.isNotEmpty&&(widget.user.probation)?Scaffold(
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
        title: Text("Dormitory",style:TextStyle(color:Colors.white)),
      ),
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
    ):DefaultHome(user: widget.user, name: "Apply for Dormitory");
  }

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);
  Widget as(int i ){
    if( i == 0){
      return HomeDor(user: widget.user);
    }else if(i == 1){
      return HomeDorw(user:widget.user);
    }else if(i == 2){
      return  HomeDorp(user:widget.user);
    }else{
      return Profile(user: widget.user,);
    }
  }
  Color bgColor = const  Color(0XFF1752FE);
}

const List<TabItem> items = [
  TabItem(
      icon: Icons.dashboard,
      title: "Home"
  ),
  TabItem(
    icon: Icons.history,
    title: 'History',
  ),
  TabItem(
      icon: Icons.credit_card_outlined,
      title: "Finance"
  ),
  TabItem(
      icon: Icons.person,
      title: "Profile"
  ),
];