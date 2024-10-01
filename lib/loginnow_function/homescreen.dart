import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';

import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/loginnow_function/profile.dart';
import 'package:student_managment_app/loginnow_function/school_find.dart';
import 'package:student_managment_app/main.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/class/classH.dart';
import 'package:student_managment_app/school_class/class/classP.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

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
      icon: Icons.person,
      title: "Profile"
  ),
];

class DefaultHome extends StatefulWidget {
  UserModel user;
  String name;
  DefaultHome({super.key,required this.user,required this.name});

  @override
  State<DefaultHome> createState() => _DefaultHomeState();
}

class _DefaultHomeState extends State<DefaultHome> {
  int visit = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
          title: Text("${widget.name}",style:TextStyle(color:Colors.white)),
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
      ),
    );
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

  Widget as(int i ){
    if( i == 0){
      return HomeM(name: widget.name, user: widget.user);
    }else if(i == 1){
      return History(user:widget.user);
    }else{
      return Profile(user: widget.user,);
    }
  }

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);


  void initState(){
    super.initState();
    message();
    fg();
  }
  Future<void> message() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
        await _firestore.collection('Users').doc(widget.user.uid).update({
          'token': token,
        });
    }
  }
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    Navigator.push(
        context, PageTransition(
        child:History(user: widget.user,),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 50)
    ));
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void fg() async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message in foreground: ${message.notification?.title}");
      _showNotification(message);
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'your_channel_name', // Replace with your channel name
      channelDescription: 'Your channel description', // Replace with your channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


}

class HomeM extends StatelessWidget {
   HomeM({super.key,required this.name,required this.user});
  UserModel user;
   final List<String> imgList = [
     'https://ipbindia.com/wp-content/uploads/2023/08/Untitled-design-7-1.png',
     'https://wallacefoundation.org/sites/default/files/2023-10/PrincipalBlake12_3668-2938x1918.jpg',
     'https://www.happierhuman.com/wp-content/uploads/2020/10/Printable-Kindness-Coloring-Pages-Children-Students.jpg',
     'https://i0.wp.com/avenuemail.in/wp-content/uploads/2021/09/3-1.jpg?fit=1600%2C1067&ssl=1',
     'https://www.gettingsmart.com/wp-content/uploads/2017/08/Parent-helping-student-with-homework-using-tablet-feature-image.jpg',
     'https://www.who.int/images/default-source/departments/food-safety_children.jpg?sfvrsn=fdfd8c23_18'
   ];

   final List<String> listh = [
     '70% Schools use Student Next Lights for Class 1 to 12 with QR Attendance, Marksheets,etc',
     'Principals & Board Members are communicating with recommended Feedbacks to make it #1',
     'Student could use the App for All Communication related to School & Friends',
     'Our App have well defined Security System for School Managment. You are 100% Safe',
     'We will be reaching Millions Schools by 2026 Thanks to promoters like you and many others',
     'We donate 5% Profits to UN Food Health Organisation and save Thousand childrens from Hunger',
   ];

   final CarouselSliderController _controller = CarouselSliderController();
  String name;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 15,),
          CarouselSlider.builder(
            itemCount: imgList.length,
            options: CarouselOptions(
              height: 180.0,
              enlargeCenterPage: true,   // Enlarge the middle image
              autoPlay: true,            // Auto-play scrolling
              aspectRatio: 16 / 9,
              autoPlayInterval: Duration(seconds: 3), // Time between slides
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              enableInfiniteScroll: true// Enable infinite scroll
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(
                      imgList[index],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(7),
                          bottomLeft: Radius.circular(7),
                        )
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 9.0,right: 9,top: 3,bottom: 3),
                        child: Text(listh[index],
                          style: TextStyle(fontSize: 10.0,color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 40,),
          InkWell(
            onTap: () async {
              SchoolModel user = await Navigator.push(
                  context, PageTransition(
                  child: FindSchool(str: name,),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)
              ));
              try{
                if(user!=null){
                  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                    "school":user.Name,
                    "schoolid":user.id,
                    "schoolpic":user.Pic,
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final bool Admin = prefs.getBool('Admin') ?? false ;
                  final bool Parent = prefs.getBool('Parent') ?? false ;
                  final String Position = prefs.getString('What') ?? "None";
                  Navigator.pushReplacement(
                      context, PageTransition(
                      child: MyApp(Admin: Admin, Parent: Parent, position: Position,),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 50)
                  ));
                  Send.message(context, "Success : Your Request sent to School for Approval",true);
                }
              }catch(e){
                Send.message(context, "$e",false);
              }
            },
            child: user.schoolid.isEmpty?Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: user.probation?Colors.blue:Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.perm_identity_sharp,color: Colors.blue,),
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request School',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Now ask Permission from School',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('to be added as ${name}',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ):Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.schoolpic),
                    ),
                    SizedBox(width: 8,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("School : "+user.school,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text("Waiting for Approval from School",
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.red),),
                        Text('Do Contact if delay !',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.red),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.push(
                  context, PageTransition(
                  child: Profile(user: user,),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)
              ));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: user.probation?Colors.blue:Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.pic),
                      radius: 30,
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Complete Profile',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Add basic Details like Phone, Adhaar',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('and basic other Details',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class History extends StatelessWidget {
  UserModel user;
  History({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').doc(user.uid).
        collection("History").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => MyHistory.fromJson(e.data())).toList() ?? [];
              if(list.isEmpty){
                return Column(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Center(child: Text("No Notification found !",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500))),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(textAlign:TextAlign.center,"No Notification sended by School to you for Complaint",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
                        ),
                      ),
                      SizedBox(height:40),
                    ]
                );
              }
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUserR(
                    user: list[index],
                  );
                },
              );
          }
        },
      ),
    );
  }
  List<MyHistory> list = [];
  late Map<String, dynamic> userMap;
}

class ChatUserR extends StatelessWidget {
  MyHistory user;
   ChatUserR({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(""),
    );
  }
}

class MyHistory {
  String id;
  String topic;
  String description;
  String type;
  String applyFor;
  String collection1;
  String doc1;
  String collection2;
  String doc2;
  String collection3;
  String doc3;
  String collection4;
  String doc4;
  String collection5;
  String doc5;
  bool view;

  // Constructor
  MyHistory({
    required this.id,
    required this.topic,
    required this.description,
    required this.type,
    required this.applyFor,
    required this.collection1,
    required this.doc1,
    required this.collection2,
    required this.doc2,
    required this.collection3,
    required this.doc3,
    required this.collection4,
    required this.doc4,
    required this.collection5,
    required this.doc5,
    this.view = false, // Default value for view
  });

  // Convert from JSON
  factory MyHistory.fromJson(Map<String, dynamic> json) {
    return MyHistory(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      applyFor: json['applyFor'] ?? '',
      collection1: json['collection1'] ?? '',
      doc1: json['doc1'] ?? '',
      collection2: json['collection2'] ?? '',
      doc2: json['doc2'] ?? '',
      collection3: json['collection3'] ?? '',
      doc3: json['doc3'] ?? '',
      collection4: json['collection4'] ?? '',
      doc4: json['doc4'] ?? '',
      collection5: json['collection5'] ?? '',
      doc5: json['doc5'] ?? '',
      view: json['view'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'description': description,
      'type': type,
      'applyFor': applyFor,
      'collection1': collection1,
      'doc1': doc1,
      'collection2': collection2,
      'doc2': doc2,
      'collection3': collection3,
      'doc3': doc3,
      'collection4': collection4,
      'doc4': doc4,
      'collection5': collection5,
      'doc5': doc5,
      'view': view,
    };
  }
}
