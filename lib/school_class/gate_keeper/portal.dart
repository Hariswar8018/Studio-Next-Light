import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/loginnow_function/homescreen.dart';
import 'package:student_managment_app/loginnow_function/profile.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/gate_keeper/history.dart';
import 'package:student_managment_app/school_class/gate_keeper/home.dart';
import 'package:student_managment_app/school_class/gate_keeper/qr.dart';

class GateKeeper extends StatefulWidget {
  UserModel user;
  GateKeeper({super.key,required this.user});

  @override
  State<GateKeeper> createState() => _GateKeeperState();
}

class _GateKeeperState extends State<GateKeeper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return widget.user.school.isNotEmpty&&(widget.user.probation)?
    Scaffold(
      drawer:Global.buildDrawer(context),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(backgroundImage: NetworkImage(widget.user.pic)),
        ),
        title: Text(widget.user.name,style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            _scaffoldKey.currentState?.openDrawer();
          }, icon: Icon(Icons.more_vert_outlined,color: Colors.white,))
        ],
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
    ) :
    DefaultHome(user: widget.user, name: "Apply for GateKeeper");
  }

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
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return Column(
      children: [
        Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: d-50,
              ),
            )),
        SizedBox(height: 7),
        Text(str, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
      ],
    );
  }

  int visit = 0;

  Widget as(int i ){
    if( i == 0){
      return GatekeeperHome(user: widget.user,);
    }else if(i == 1){
      return GateHistory(user: widget.user,);
    }else if(i == 2){
      return QRSchool(str: "");
    }else if(i == 3){
      return Profile(user: widget.user);
    }else{
      return Profile(user: widget.user);
    }
  }

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);
}
