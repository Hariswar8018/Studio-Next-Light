import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/attendance/notice.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePa extends StatefulWidget {
   HomePa({super.key});

  @override
  State<HomePa> createState() => _HomePaState();
}

class _HomePaState extends State<HomePa> {
  String school = "h", clas = "u", session = "j", id = "j";
   /* */
  a() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id")!;
    clas = prefs.getString("class")!;
    session = prefs.getString("session")!;
    school = prefs.getString("school")!;
    setState((){

    });
  }

  void initState(){
    a();
  }
   List<StudentModel> list = [];

   late Map<String, dynamic> userMap;

   TextEditingController ud = TextEditingController();

   final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Show an alert dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Close ?'),
                content: Text('Do you really want to close the app ?'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false); // Pop the dialog
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            },
          );

          // Return false to prevent the app from being closed immediately
          return false;
        },
      child: Scaffold(
        drawer: Global.buildDrawer(context),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Color(0xff50008e),
          title: Text('Parents Portal', style : TextStyle(color : Colors.white)),
        ),
        body : StreamBuilder(
          stream: Fire.collection('School').doc(school).collection('Session').doc(session).collection("Class").doc(clas).collection("Student").where("Registration_number", isEqualTo: id).snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => StudentModel.fromJson(e.data())).toList() ?? [];
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index],st:school,
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class ChatUser extends StatefulWidget {
  StudentModel user ; String st;
  ChatUser({super.key, required this.user,required this.st});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  int pre = 0 , abs = 0 , nt = 0;

  Future<List<Date>> fetchDataFromFirestore() async {
    List<Date> firestoreDates = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('School').doc(widget.user.School_id_one).collection("Students")
        .doc(widget.user.Registration_number)
        .collection("Colors")
        .get();
    querySnapshot.docs.forEach((doc) {
      print(doc);
      // Convert Timestamp to DateTime
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          (doc['date'] as Timestamp).millisecondsSinceEpoch);
      firestoreDates.add(Date(
        date: date,
        color: Color(doc['color']),
      ));
      if (doc['color'] == 4280391411) {
        setState(() {
          pre++ ;
        });
      } else if ( doc['color'] == 4294198070){
        setState(() {
          abs++ ;
        });
      }else{
        setState(() {
          nt++ ;
        });
      }
    });
    return firestoreDates;
  }

  late List<Date> dates  ;
 late final String id,clas,session,school;
  Future<void> gh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id")!;
    clas = prefs.getString("class")!;
    session = prefs.getString("session")!;
    school = prefs.getString("school")!;

    CollectionReference collection = FirebaseFirestore.instance.collection(
        'School').doc(school).collection('Session').doc(session)
        .collection('Class').doc(clas)
        .collection("Student");
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
     final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await collection.doc(id).update({
        'token': token,
      });
    }
  }
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Handle background message
  }
  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore().then((firestoreDates) {
      setState(() {
        dates = firestoreDates;
      });
    });
    gh();
  }
  String hjk( String g ) {
    String dateTimeString = g; // Replace with your DateTime string
    print(g);
    // Convert DateTime string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate ;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      height: MediaQuery.of(context).size.height + 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1/3 + 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.pic,),
                      radius: 70,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              Container(
                width: MediaQuery.of(context).size.width * 2/3 - 50,
                child : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),),
                    Text( "Mobile : " + widget.user.Mobile, style: TextStyle(fontWeight: FontWeight.w500),),
                    Text( "Address : " + widget.user.Address, style: TextStyle(fontWeight: FontWeight.w500),),
                    Text( "Class : " + widget.user.Class + " (" + widget.user.Section + ")", style: TextStyle(fontWeight: FontWeight.w500),)
                  ],
                ),
              )
            ],
          ),
          SizedBox(height : 25),
          a(context, "Blood Group" , widget.user.BloodGroup, "Date of Birth", hjk(widget.user.newdob)),
          a(context, "Father Name" , widget.user.Father_Name, "Mother Name", widget.user.Mother_Name),
          a(context, "Roll No." , widget.user.Roll_number.toString(), "Registration No.", widget.user.Registration_number),
          SizedBox(height : 25),
          Divider(),
          SizedBox(height : 15),
          Text("Attendance Registery", style : TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          SizedBox(height : 15),
          CustomCalendarViewer(
            dates: dates,
            ranges: ranges ,
            calendarType: CustomCalendarType.multiDatesAndRanges ,
            calendarStyle: CustomCalendarStyle.normal ,
            animateDirection: CustomCalendarAnimatedDirection.vertical ,
            movingArrowSize: 24 ,
            spaceBetweenMovingArrow: 20 ,
            closeDateBefore: DateTime.now().subtract(Duration(days: 405)),
            closedDatesColor: Colors.grey.withOpacity(0.7),
            //showHeader: false ,
            showBorderAfterDayHeader: true,
            showTooltip: true,
            toolTipMessage: '',
            //headerAlignment: MainAxisAlignment.center,
            calendarStartDay: CustomCalendarStartDay.monday,
            onCalendarUpdate: (date) {
              // Handel your code here.
              print('onCalendarUpdate');
              print(date);
            },
            onDayTapped: (date) {

            },
            onDatesUpdated: (newDates) {
              print('onDatesUpdated');
              print(newDates.length);
            },
            onRangesUpdated: (newRanges) {
              print('onRangesUpdated');
              print(newRanges.length);
            },
            //showCurrentDayBorder: false,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children : [
                TextButton.icon(onPressed: (){

                },
                    icon: Icon(Icons.circle, color : Colors.blue),
                    label: Text("Present")
                ),
                TextButton.icon(onPressed: (){

                },
                    icon: Icon(Icons.circle, color : Colors.red),
                    label: Text("Absent")
                ),
                TextButton.icon(onPressed: (){

                },
                    icon: Icon(Icons.circle, color : Colors.green),
                    label: Text("Holiday")
                ),
              ]
          ),
          SizedBox(height : 25),
          Divider(),
          SizedBox(height : 15),
          Text("Notices", style : TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          SizedBox(height : 15),
        ],
      ),
    );
  }
  List<Notice> list = [];
  late Map<String, dynamic> userMap;
  Widget a(BuildContext context, String s1, String s2, String s3, String s4){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width : MediaQuery.of(context).size.width/2 - 10,
            child : Text(s1+  " : " + s2, style : TextStyle(fontSize: 16)),
          ),
          Container(
            width : MediaQuery.of(context).size.width/2 - 10,
            child : Text(s3 + " : " + s4,  style : TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> saveToken(String userId) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _firestore.collection('Users').doc(userId).update({
        'token': token,
      });
    }
  }
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Handle background message
  }
}
