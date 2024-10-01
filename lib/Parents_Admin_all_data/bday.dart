import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/after_login/b2.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:url_launcher/url_launcher.dart';

class BDay extends StatelessWidget {
  String id;
  String School ;
  String logo ;
  String address ;
  bool todayg ;
  bool tomorrow ;
  BDay({super.key, required this.id, required this.School, required this.logo, required this.address, required this.todayg, required this.tomorrow });

  List<StudentModel2> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: todayg ? Text("Wish Today's Birthday") : ( tomorrow ? Text("Wish Tomorroww's Birthday") : Text("Wish Day After Tomorrows Birthday") ) ,
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(id).collection('Students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          DateTime today = DateTime.now();
          DateTime tomorrowg = today.add(Duration(days: 1));
          DateTime yesterday = today.add(Duration(days: 2));
          List<DocumentSnapshot> birthdayDocs = snapshot.data!.docs.where((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            dynamic newdobField = data['newdob']; // Assuming 'newdob' can be either String or Timestamp

            DateTime newdob;
            if (newdobField is Timestamp) {
              newdob = newdobField.toDate();
            } else if (newdobField is String) {
              newdob = DateTime.parse(newdobField);
            } else {
              // Handle the case where 'newdob' has an unexpected type
              return false;
            }

            if (todayg ) {
              return newdob.month == today.month && newdob.day == today.day;
            } else if ( tomorrow ) {
              return newdob.month == today.month && newdob.day == tomorrowg.day;
            } else {
              // Check for yesterday
              return newdob.month == today.month && newdob.day == yesterday.day;
            }
          }).toList();

          if (birthdayDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://static.vecteezy.com/system/resources/previews/029/250/026/original/cartoon-style-birthday-cake-dessert-no-background-applicable-to-any-context-perfect-for-print-on-demand-merchandise-ai-generative-png.png",
                  ),
                  Text(
                    "Relax! No Students' Birthday Today",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Looks like no student has a birthday today!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: BDay2(
                                logo: logo,
                                id :  id ,
                                School: School, address: address,                          ),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400)));
                    },
                    child: Text("View All"),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            );
          } else {
            return ListView(
              children: birthdayDocs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ChatUser(
                  user: StudentModel2.fromJson(data),
                  logo: logo,
                  School: School,
                  address: address,
                  Schoolid : id ,
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class ChatUser extends StatelessWidget {
  StudentModel2 user;
  String logo ;
  String School ;
  String Schoolid ;
  String address ;
  ChatUser({super.key, required this.user, required this.logo, required this.School, required this.address, required this.Schoolid});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style : TextStyle( fontWeight: FontWeight.w600)),
      subtitle: Text("Born on : " + hjk ( user.newdob)),
      onTap: () async {
        String phoneNumber = "91" + user.Mobile ;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Proceed ?'),
              content: Text('Choose Which Language '),
              actions: [
                TextButton(
                  onPressed: () async {
                    String message = "प्रिय ${user.Name}, \n\nआपका जन्मदिन जल्दी ही आ रहा है! हम आपको आपके जन्मदिन की पूर्व-अग्रिम शुभकामनाएं देना चाहेंगे। \n\nहम जानते हैं कि यह आपका विशेष दिन है, इसलिए हम आपको यह बताना चाहते हैं कि हम आपकी खुशी में शामिल होना चाहते हैं और हम आपके साथ हैं।\n\nआपके जन्मदिन के अवसर पर, हम आपको कई स्वादिष्ट केक्स की कैटलॉग प्रदान कर रहे हैं। हम चाहते हैं कि आपका जन्मदिन मंगलमय हो। \n\nआपको जन्मदिन की ढेर सारी शुभकामनाएं!\n\nसादर,\nस्टूडियो नेक्स्ट लाइट";
                    String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";

                    await FirebaseFirestore.instance.collection('School').doc(Schoolid).collection('Students').doc(user.id).update({
                      "par" : true ,
                    });
                    // Launch the WhatsApp URL
                    if (await canLaunch(whatsappUrl)) {
                    await launch(whatsappUrl);
                    } else {
                    print("Could not launch WhatsApp.");
                    }
                  },
                  child: Text('HINDI'),
                ),
                TextButton(
                  onPressed: () async {
                    String message = "Dear ${user.Name},\n\nYour birthday is coming soon! We would like to wish you an advance of your birthday.\n\nWe know that this is your special day, so we want to let you know that we care about you and we want to be involved in your happiness.\n\nOn the occasion of your birthday, we are offering you many delicious cakes. We want your birthday to be memorable.\n\nHappy birthday to you!\n\nRegards,\nStudio Next Light";
                    String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";

                    await FirebaseFirestore.instance.collection('School').doc(Schoolid).collection('Students').doc(user.id).update({
                      "par" : true ,
                    });
                    // Launch the WhatsApp URL
                    if (await canLaunch(whatsappUrl)) {
                    await launch(whatsappUrl);
                    } else {
                    print("Could not launch WhatsApp.");
                    }
                  },
                  child: Text('ENGLISH'),
                ),
              ],
            );
          },
        );


      },
      trailing: user.par ?   Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
        size: 25,
      ) :  Icon(
        Icons.sentiment_satisfied_alt,
        color: Colors.red,
        size: 25,
      ),
      splashColor: Colors.orange.shade300,
      tileColor: user.par ? Colors.grey.shade100 : Colors.white,
    );
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
}


class BDay2 extends StatelessWidget {
  String id;
  String School ;
  String logo ;
  String address ;
  BDay2({super.key, required this.id, required this.School, required this.logo, required this.address });

  List<StudentModel2> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('All Birthday\s '),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(id).collection('Students').orderBy(
          "newdob",
          descending: false, // Set to true if you want descending order
        ).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => StudentModel2.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                    logo : logo,
                    School : School ,
                    address : address ,
                    Schoolid : id ,
                  );
                },
              );
          }
        },
      ),
    );
  }
}