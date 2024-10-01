import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/bday.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:student_managment_app/model/birthday_student.dart';

class Birthdayv extends StatelessWidget {
  String logo ;
  String id ;
  String School ;
  String address ;

  Birthdayv({super.key, required this.logo, required this.id, required this.School, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text("Choose Birthday"),
      ),
      body : Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: BDay(
                        logo: logo,
                        id :  id ,
                        School: School, address: address, todayg: true, tomorrow: true,                            ),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 400)));
            },
            leading :  Icon( Icons.card_giftcard, color : Colors.red ),
            title : Text("Today\s Birthday"),
            subtitle: Text("Wish Student who have birthday Today"),
            trailing : Icon(Icons.arrow_forward_ios)
          ),
          ListTile(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: BDay(
                          logo: logo,
                          id :  id ,
                          School: School, address: address, todayg: false, tomorrow: true,                            ),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400)));
              },
              leading :  Icon( Icons.card_giftcard, color : Colors.blue ),
              title : Text("Tomorrow\s Birthday"),
              subtitle: Text("Wish Student who have birthday Tomorrow"),
              trailing : Icon(Icons.arrow_forward_ios)
          ),
          ListTile(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: BDay(
                          logo: logo,
                          id :  id ,
                          School: School, address: address, todayg: false, tomorrow: false,                            ),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400)));
              },
              leading :  Icon( Icons.card_giftcard, color : Colors.green ),
              title : Text("Day After Tomorrow\s Birthday"),
              subtitle: Text("Wish Student who have birthday Day After Tomorrow"),
              trailing : Icon(Icons.arrow_forward_ios)
          ),
          ListTile(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: BDay2(
                          logo: logo,
                          id :  id ,
                          School: School, address: address,                     ),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400)));
              },
              leading :  Icon( Icons.card_giftcard, color : Colors.orange ),
              title : Text("All Birthday\s"),
              subtitle: Text("All Birthday\s"),
              trailing : Icon(Icons.arrow_forward_ios)
          ),
        ],
      )
    );
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