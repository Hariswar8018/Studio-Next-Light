import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/after_login/Birthdays.dart';
import 'package:student_managment_app/after_login/options.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/attendance/attendance_register.dart';
import 'package:student_managment_app/before_check/first.dart';
import 'package:student_managment_app/service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Our_Works extends StatelessWidget{
  Our_Works({super.key});
  List<SchoolModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        automaticallyImplyLeading: false,
        title : Center(child: Text("Our Customers", style : TextStyle(color : Colors.white))),
        backgroundColor : Colors.red,
      ),
      body : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
             width : MediaQuery.of(context).size.width,
              child: Center(
                child : Text("We are committed to keeping our customers happy. We strive to provide them with high quality products and services. We also strive to provide them with excellent customer service.", textAlign: TextAlign.center,)
              )
            ),
          ),
          Container(
            height : MediaQuery.of(context).size.height - 100,
            width : MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: Fire.collection('School').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list =  data?.map((e) => SchoolModel.fromJson(e.data())).toList() ?? [];
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 4.0, // Spacing between columns
                          mainAxisSpacing: 4.0, // Spacing between rows
                        ),
                        itemCount: list.length,
                        padding: EdgeInsets.all(4.0), // Padding around the grid
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser(
                            user: list[index],
                          );
                        },
                      );


                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class ChatUser extends StatefulWidget {
  final SchoolModel user;

  const ChatUser({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUser> createState() => ChatUserState();
}

class ChatUserState extends State<ChatUser> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color : Colors.white,
      child : Stack(
        children: [
      Container(
      height : MediaQuery.of(context).size.height,
      width : MediaQuery.of(context).size.height,
      color : Colors.white,
      ),
          Container(
            height : 80,
            width : MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.user.Pic), fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height : MediaQuery.of(context).size.height,
            width : MediaQuery.of(context).size.height,
            child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.Pic_link),
                  radius: 45,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.user.Name, textAlign : TextAlign.center, style : TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}
