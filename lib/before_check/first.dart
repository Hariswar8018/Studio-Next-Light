import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studio_next_light/Parents_Admin_all_data/search_school.dart';
import 'package:studio_next_light/before_check/admin.dart';
import 'package:studio_next_light/before_check/first2.dart';
import 'package:studio_next_light/before_check/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/before_check/our_works.dart';
import 'package:studio_next_light/super_admin/carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class First extends StatelessWidget {

  First({super.key});
  List<Carousell> list = [];

  late Map<String, dynamic> userMap;
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
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions : [
            TextButton.icon( onPressed : (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: Our_Works(),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 100)));
            }, icon : Icon(Icons.remove_red_eye), label : Text("Check Our Valuable Clients")),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()  async {
            String phoneNumber = '917000994158';
            String message = 'Hi, Studio Next Light! We are contacting you regarding your App';

            String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

            if (await canLaunch(url)) {
            await launch(url);
            } else {
// Handle error
            print('Could not launch WhatsApp');
            }
          },
          tooltip: 'Open WhatsApp',
          child: Icon(Icons.chat),
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width - 40,
              child: Image(
                image: AssetImage(
                    'assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png', ),
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              child: Center(
                child: Text("Welcome to Studio Next Light", style : TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 21
                ), textAlign: TextAlign.center,),
              ),
            ),
            Center(
              child: Text("We make Different types of Students ID Card - Attractive, Error Free and at Good Price", style : TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 17
              ), textAlign: TextAlign.center,),
            ),
            IconButton(onPressed: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: First2(),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 100)));
            }, icon: Icon(Icons.login, size : 84, color : Colors.greenAccent),),
            Center(
              child: Text("Click to Enter App", style : TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 15, color : Colors.grey
              ), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),
            Container(
                width : MediaQuery.of(context).size.width ,
                height: 220,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Admin').doc("C").collection("C").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list =
                            data?.map((e) => Carousell.fromJson(e.data())).toList() ??
                                [];
                        return ListView.builder(
                          itemCount: 1,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Superr(
                              user: list[index],
                            );
                          },
                        );
                    }
                  },
                ),
            )
          ],
        ),
      ),
    );
  }
}

class Superr extends StatelessWidget {
  Carousell user ;
   Superr({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Image.network(user.pic, width: MediaQuery.of(context).size.width ,);
  }
}
