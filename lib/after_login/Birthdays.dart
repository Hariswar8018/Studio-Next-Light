import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/model/birthday_student.dart';

import '../after_login/b2.dart';
import '../model/student_model.dart';

class BDay extends StatelessWidget {
  String id;
  String School ;
  String logo ;
  String address ;
  BDay({super.key, required this.id, required this.School, required this.logo, required this.address });

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Wish Today\'s Birthday'),
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

            return newdob.month == today.month && newdob.day == today.day;
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
                            id: id,
                            School: School,
                            logo: logo,
                            address: address,
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: Text("View Upcoming Birthdays"),
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
                  user: StudentModel.fromJson(data),
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
  StudentModel user;
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
      title: Text(user.Name, style : TextStyle( fontWeight: FontWeight.w700)),
      // subtitle:
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Born on : " + hjk ( user.newdob)),
          Text("Class : " + user.Class+ " (${user.Section})",style: TextStyle(fontSize: 12),),
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Proceed ?'),
              content: Text('Choose Which Language '),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, PageTransition(
                        child: BD( name : user.Name , pic : user.pic, hindi : false, logo : logo, iname : School, number: user.Mobile, address: address, Schoolid: Schoolid, id : user.id) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: Text('ENGLISH'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, PageTransition(
                        child: BD( name : user.Name , pic : user.pic, hindi : true, logo : logo, iname : School, number: user.Mobile, address : address, Schoolid: Schoolid, id : user.id) , type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                  },
                  child: Text('HINDI'),
                ),
              ],
            );
          },
        );

      },
      trailing:   Icon(
        Icons.sentiment_satisfied_alt,
        color: Colors.red,
        size: 25,
      ),
      splashColor: Colors.orange.shade300,
      tileColor:  Colors.white,
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

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Upcoming birthday\'s'),
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
              list = data?.map((e) => StudentModel.fromJson(e.data())).toList() ?? [];
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