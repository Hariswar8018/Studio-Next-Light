import 'package:flutter/material.dart';
import 'package:studio_next_light/Parents_Admin_all_data/search_school.dart';
import 'package:studio_next_light/before_check/admin.dart';
import 'package:studio_next_light/before_check/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/before_check/student_data.dart';
import 'package:studio_next_light/before_check/super_admin.dart';

class First2 extends StatelessWidget {
  const First2({super.key});

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
            Icon(Icons.login, size : 44, color : Colors.greenAccent),
            Text("Login to Our App based on your Position", style : TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18
            )),

            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.people_outline_sharp,color: Colors.orange, size: 30),
              title: Text("Parents Entry"),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Panel_School(b : false),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400)));
              },
              subtitle: Text("Check children status or modify data"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.orange, size: 20,),
              splashColor: Colors.orange.shade300,
              tileColor: Colors.grey.shade50,
            ),
            ListTile(
              leading: Icon(Icons.school,color: Colors.blueAccent, size: 30),
              title: Text("School / University / University"),
              onTap: () {
                Navigator.push(
                    context, PageTransition(
                    child: LoginScreen(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                ));
              },
              subtitle: Text("Upload Students data to Institute Database"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.blueAccent, size: 20,),
              splashColor: Colors.orange.shade300,
              tileColor: Colors.grey.shade50,
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings_sharp,color: Colors.greenAccent, size: 30),
              title: Text("Admin"),
              onTap: () {
                Navigator.push(
                    context, PageTransition(
                    child: Admin(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                ));
              },
              subtitle: Text("Make & Manage Institute Profile"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.greenAccent, size: 20,),
              splashColor: Colors.orange.shade300,
              tileColor: Colors.grey.shade50,
            ),
            ListTile(
              leading: Icon(Icons.security,color: Colors.redAccent, size: 30),
              title: Text("SuperAdmin"),
              onTap: () {
                Navigator.push(
                    context, PageTransition(
                    child: SuperAdmin(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                ));
              },
              subtitle: Text("Lock, Unlock, Export School Data"), trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.redAccent, size: 20,),
              splashColor: Colors.orange.shade300,
              tileColor: Colors.grey.shade50,
            ),
          ],
        ),
      ),
    );
  }
}
