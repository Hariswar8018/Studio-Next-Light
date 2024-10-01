import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import "package:awesome_bottom_bar/widgets/inspired/inspired.dart";
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/services.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/anew/school/dashboard/SchoolC.dart';
import 'package:student_managment_app/anew/school/dashboard/SchoolP.dart';
import 'package:student_managment_app/anew/school/dashboard/attendance.dart';
import 'package:student_managment_app/anew/school/dashboard/fees.dart';
import 'package:student_managment_app/anew/school/dashboard/home.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolName extends StatefulWidget {
  bool principal;
  SchoolName({super.key,required this.principal});

  @override
  State<SchoolName> createState() => _SchoolNameState();
}

class _SchoolNameState extends State<SchoolName> {

  List<SchoolModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  String s = FirebaseAuth.instance.currentUser!.email ?? " ";


  final Fire = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: Fire.collection('School')
          .where('Clientemail', isEqualTo: s)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final data = snapshot.data?.docs;
            list = data?.map((e) => SchoolModel.fromJson(e.data())).toList() ??
                    [];
            if (list.isEmpty) {
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
                  drawer:Global.buildDrawer(context),
                  key: _scaffoldKey,
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: (){
                          _scaffoldKey.currentState?.openDrawer();
                          },
                        icon: Icon(Icons.more_vert_outlined)),
                    title: Text("Add School"),
                  ),
                  body:Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50),
                          Image.network(
                              "https://assets-v2.lottiefiles.com/a/92920ca4-1174-11ee-9d90-63f3a87b4e3d/c6NYERU5De.png"),
                          Text("No School found for your Email / Account", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                          Text(
                              "Looks like Admin of Institution haven't add your Email for School Upload. Please double check your Email or Please contact either Admin or SuperAdmin",
                              textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          Center(
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
                              child: Center(child: Text("New here ! Add New School for me",style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "RobotoS",fontWeight: FontWeight.w800
                              ),)),
                            ),
                          ),
                          SizedBox(height: 13,),
                          Center(
                            child: InkWell(
                              onTap: () async {
                                final Uri _url = Uri.parse(
                                    'https://wa.me/917000994158?text=Hello!%20We%20are%20contacting%20you%20for%20Students%20ID%20Card%20Services!');
                                if (!await launchUrl(_url)) {
                                  throw Exception('Could not launch $_url');
                                }
                              },
                              child: Container(
                                height:45,width:w-20,
                                decoration:BoxDecoration(
                                  borderRadius:BorderRadius.circular(7),
                                  color:Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                                      spreadRadius: 5, // The extent to which the shadow spreads
                                      blurRadius: 7, // The blur radius of the shadow
                                      offset: Offset(0, 3), // The position of the shadow
                                    ),
                                  ],
                                ),
                                child: Center(child: Text("Troubleshoot ? Contact Us here",style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                                ),)),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            } else {
              return S(user:list.first,principal: widget.principal,);
            }
        }
      },
    );
  }
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
    icon: Icons.security,
    title: "Security"
  ),
  TabItem(
    icon: Icons.credit_card,
    title: 'Fee',
  ),
  TabItem(
    icon: Icons.person,
    title: 'Profile',
  ),
];

class S extends StatefulWidget {
  SchoolModel user;bool principal;
   S({super.key,required this.user,required this.principal});

  @override
  State<S> createState() => _SState();
}

class _SState extends State<S> {

int visit = 0;
void initState(){
  super.initState();
  message();
}
Future<void> message() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  String? token = await _firebaseMessaging.getToken();
  if (token != null) {
    if(widget.principal){
      await _firestore.collection('School').doc(widget.user.id).update({
        'principaltoken': token,
      });
      print("jhcjhkjhdfjfkjjgk"+token);
    }else{
      await _firestore.collection('School').doc(widget.user.id).update({
        'schooltoken': token,
      });
      print("qw45466433765947"+token);
    }
  }
}
static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

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
          child:  BottomBarCreative(
            items: items,
            backgroundColor: Colors.white,
            color: Colors.black,
            colorSelected: colorSelect,
            indexSelected: visit,
            isFloating: true,
            highlightStyle:const HighlightStyle(sizeLarge: true, isHexagon: true, elevation: 2),
            onTap: (int index) => setState(() {
              visit = index;
            }),
          ),
        ),
      ),
    );
  }

  Widget as(int i ){
    if( i == 0){
      return SchholH(user: widget.user,);
    }else if(i == 1){
      return SchoolA(user: widget.user,b:false);
    }else if(i == 2){
      return SchoolC(user: widget.user,);
    }else if(i == 3){
      return SchoolF(user: widget.user,b:false);
    }else{
      return SchoolP(user: widget.user,);
    }
  }

   Color colorSelect =const Color(0XFF0686F8);

   Color color = const Color(0XFF7AC0FF);

   Color color2 = const Color(0XFF96B1FD);

   Color bgColor = const  Color(0XFF1752FE);
}
