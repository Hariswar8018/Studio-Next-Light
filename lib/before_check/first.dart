import 'package:flutter/material.dart';
import 'package:studio_next_light/Parents_Admin_all_data/search_school.dart';
import 'package:studio_next_light/before_check/admin.dart';
import 'package:studio_next_light/before_check/first2.dart';
import 'package:studio_next_light/before_check/login.dart';
import 'package:page_transition/page_transition.dart';


class First extends StatelessWidget {
  const First({super.key});

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
                    Navigator.of(context).pop(true); // Pop the dialog
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
            Center(
              child: Text("Welcome to Studio Next Light", style : TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 21
              ), textAlign: TextAlign.center,),
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
            SizedBox(height: 20,),
            Container(
                width : MediaQuery.of(context).size.width ,
                child: Image.asset("assets/img.png"))
          ],
        ),
      ),
    );
  }
}
