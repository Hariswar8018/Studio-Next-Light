import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/loginnow_function/homescreen.dart';
import 'package:student_managment_app/model/usermodel.dart';

class GatePortal extends StatefulWidget {
  UserModel user;
  GatePortal({super.key,required this.user});

  @override
  State<GatePortal> createState() => _GatePortalState();
}

class _GatePortalState extends State<GatePortal> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
        title: Text("Apply Gate Pass",style:TextStyle(color:Colors.white)),
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
    );
  }
  int visit=0;

  Widget as(int i ){
      return History(user:widget.user);

  }

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);

  List<TabItem> items = [
    TabItem(
        icon: Icons.dashboard,
        title: "Home"
    ),
    TabItem(
      icon: Icons.history,
      title: 'History',
    ),
    TabItem(
        icon: Icons.qr_code,
        title: "QR"
    ),
    TabItem(
        icon: Icons.person,
        title: "Profile"
    ),
  ];
}

class HomeS extends StatelessWidget {
  const HomeS({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
