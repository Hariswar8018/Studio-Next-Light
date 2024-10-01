import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/after_login/calender.dart';
import 'package:student_managment_app/after_login/my_fee_report_report.dart';
import 'package:student_managment_app/attendance/notice.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/picture.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/student_model.dart';

class StProfile extends StatelessWidget {
  StudentModel user; bool parent;
  StProfile({super.key,required this.parent,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        title: Text(user.Name),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: InkWell(
                      onLongPress: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Pic(str: user.pic,
                                    name: user.Name),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.pic),
                        radius: 120,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Row(
                      children: [
                        Spacer(),
                        Column(
                            children: [
                              SizedBox(height: 20),
                              InkWell(
                                onTap: ()  async {
                                  final Uri _url = Uri.parse(
                                      "tel:" + user.Mobile);
                                  if (!await launchUrl (_url)
                                  ) {
                                    throw Exception('Could not launch $_url');
                                  }
                                },
                                child: CircleAvatar(radius: 24,
                                  child: Icon(Icons.call, color: Colors.white,
                                      size: 20),
                                  backgroundColor: Colors.greenAccent,),

                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () async  {
                                  final Uri _url = Uri.parse(
                                      "mailto:" + user.Email);
                                  if (!await launchUrl (_url)
                                  ) {
                                    throw Exception('Could not launch $_url');
                                  }
                                }, child:
                              CircleAvatar(radius: 24,
                                child: Icon(
                                    Icons.mail, color: Colors.white, size: 20),
                                backgroundColor: Colors.red,),
                              ), SizedBox(height: 5),
                              InkWell(
                                onTap: () async {
                                  final Uri _url = Uri.parse(
                                      "https://www.google.com/maps/search/?api=1&query=${user.Address}");
                                  if (!await launchUrl (_url)) {
                                    throw Exception('Could not launch $_url');
                                  }
                                }, child:
                              CircleAvatar(radius: 24,
                                child: Icon(
                                    Icons.map_sharp, color: Colors.white,
                                    size: 20),
                                backgroundColor: Colors.purple,),
                              ),
                            ]
                        ),
                        SizedBox(width: 8),
                      ]
                  ),
                ),
              ],
            ),
            Center(child: Text(user.Pic_Name)),
            SizedBox(height: 10),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 10),
                    TextButton.icon(onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String id = prefs.getString('school') ?? "None";
                      final String clas = prefs.getString('class') ?? "None";
                      final String session = prefs.getString('session') ?? "None";
                      final String regist = prefs.getString('id') ?? "None";
                      Navigator.push(
                          context,
                          PageTransition(
                              child: MyCalenderPage(idi: user
                                  .Registration_number, df: id,
                                classi: clas, sessioni: session, user: user,
                              ),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400)));
                    },
                      icon: Icon(Icons.how_to_reg, size: 25),
                      label: Text("Attendance"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),
                    SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        final String id = prefs.getString('school') ?? "None";
                        final String clas = prefs.getString('class') ?? "None";
                        final String session = prefs.getString('session') ?? "None";
                        final String regist = prefs.getString('id') ?? "None";
                        Global.As(user, false, id);},
                      icon: Icon(Icons.receipt, size: 25),
                      label: Text("Reminder"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.lightGreen),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),
                    SizedBox(width: 10),
                  ]
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 10),
                    TextButton.icon(onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String id = prefs.getString('school') ?? "None";
                      final String clas = prefs.getString('class') ?? "None";
                      final String session = prefs.getString('session') ?? "None";
                      final String regist = prefs.getString('id') ?? "None";
                      Navigator.push(
                          context,
                          PageTransition(
                              child: MyFR(user:user, school: id,),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400)));
                    },
                      icon: Icon(Icons.receipt, size: 25),
                      label: Text("Fee Report"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),
                    SizedBox(width: 10),
                    TextButton.icon(onPressed: () async {
                      Send.message(context, "This is only for School Communication", false);
                    },
                      icon: Icon(Icons.credit_score, size: 25),
                      label: Text("Notices "),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurple),
                        // Set the background color of the button
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Set the text color of the button
                      ),),

                    SizedBox(width: 10),
                  ]
              ),
            ),
            SizedBox(height: 15),
            Text("Only School could edit Student Info. But you could still View",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400),),
            SizedBox(height: 10),
            s("Name", user.Name, false, true),
            s("Father Name", user.Father_Name, true, true),
            user.Mother_Name == " " ? s("Mother Name", user.Mother_Name, false, true): SizedBox(),
            user.BloodGroup == " " ? s("Blood Group", user.BloodGroup, true, true) : SizedBox(),
            s("Mobile", user.Mobile.toString(), false, true),
            s("Date of Birth : " , hjk(user.newdob) , false, true),
            user.Email == " " ?  s("Email", user.Email, true, true) : SizedBox(),
            SizedBox(height: 20),
            user.Admission_number == " " ? s("Admission Number", user.Admission_number, false, true): SizedBox(),
            s("Registration Number", user.Registration_number, true, true),
            s("ID", user.id, false, true),
            s("Session", user.Session, true, true),
            s("Roll Number", user.Roll_number.toString(), false, true),
            SizedBox(height: 20),
            s("Batch", user.Batch, true,true),
            s("Class", user.Class, false, true),
            s("Section", user.Section, true, true),
            user.Department == " " ? s("Department", user.Department, false, true): SizedBox(),
            s("Address", user.Address, true, true),
          ],
        ),
      ),
    );
  }
  Widget s(String s, String n, bool b, bool j) {
    return ListTile(
      leading: Icon(Icons.circle, color: Colors.black, size: 20),
      title: Text(s + " :"),
      trailing:
      Text(n, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      splashColor: Colors.orange.shade300,
      tileColor: b ? Colors.grey.shade50 : Colors.white,
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
