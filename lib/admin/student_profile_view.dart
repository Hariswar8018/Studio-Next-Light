
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';
import 'package:student_managment_app/after_login/calender.dart';
import 'package:student_managment_app/after_login/my_fee_report_report.dart';
import 'package:student_managment_app/attendance/Qr_code.dart';
import 'package:student_managment_app/attendance/notice.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/picture.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';

class StudentProfileN extends StatefulWidget {
  String schoolid, sessionid, classid ;
  StudentModel user;
  StudentProfileN(
      {super.key,
        required this.user, required this.schoolid, required this.classid, required this.sessionid});

  @override
  State<StudentProfileN> createState() => _StudentProfileNState();
}

class _StudentProfileNState extends State<StudentProfileN> {

  int j=0;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.Name),
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
                                child: Pic(str: widget.user.pic,
                                    name: widget.user.Name),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.pic),
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
                                      "tel:" + widget.user.Mobile);
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
                                      "mailto:" + widget.user.Email);
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
                                      "https://www.google.com/maps/search/?api=1&query=${widget.user.Address}");
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
            Center(child: Text(widget.user.Pic_Name)),
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
                    TextButton.icon(onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: MyCalenderPage(idi: widget.user
                                  .Registration_number, df: widget.schoolid,
                                classi: widget.classid, sessioni: widget.sessionid, user: widget.user,
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
                      onPressed: () => Global.As(widget.user, false, widget.schoolid),
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
                    TextButton.icon(onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: MyFR(user:widget.user, school: widget.schoolid,),
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
                    TextButton.icon(onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Noticee(id: widget.schoolid, classid: widget.classid, sessionid: widget.sessionid, studentid: widget.user.Registration_number, tokens:widget.user.token),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 400)));
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
            SizedBox(height: 10),
            AppinioAnimatedToggleTab(
              callback: (int i) {
                setState(() {
                  j=i;
                });
              },
              tabTexts: const [
                'Profile',
                'Fees',
                'Marksheets',
              ],
              height: 40,
              width: w*9/10,
              boxDecoration: BoxDecoration(color: Colors.red.shade100,),
              animatedBoxDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFc3d2db).withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
                color: Colors.red,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              activeStyle: const TextStyle( color: Colors.white,),
              inactiveStyle: const TextStyle( color: Colors.black,),
            ),
            SizedBox(height: 10),
            col(j,w),
          ],
        ),
      ),
    );
  }
  Widget col(int y,double w){
    if(y==0){
      return Column(
        children: [
          s("Name", widget.user.Name, false, true),
          s("Father Name", widget.user.Father_Name, true, true),
          widget.user.Mother_Name == " " ? s("Mother Name", widget.user.Mother_Name, false, true): SizedBox(),
          widget.user.BloodGroup == " " ? s("Blood Group", widget.user.BloodGroup, true, true) : SizedBox(),
          s("Mobile", widget.user.Mobile.toString(), false, true),
          s("Date of Birth : " , hjk(widget.user.newdob) , false, true),
          widget.user.Email == " " ?  s("Email", widget.user.Email, true, true) : SizedBox(),
          SizedBox(height: 20),
          widget.user.Admission_number == " " ? s("Admission Number", widget.user.Admission_number, false, true): SizedBox(),
          s("Registration Number", widget.user.Registration_number, true, true),
          s("ID", widget.user.id, false, true),
          s("Session", widget.user.Session, true, true),
          s("Roll Number", widget.user.Roll_number.toString(), false, true),
          SizedBox(height: 20),
          s("Batch", widget.user.Batch, true,true),
          s("Class", widget.user.Class, false, true),
          s("Section", widget.user.Section, true, true),
          widget.user.Department == " " ? s("Department", widget.user.Department, false, true): SizedBox(),
          s("Address", widget.user.Address, true, true),
        ],
      );
    }else if(y==1){
      return Column(
        children: [
          Card(
            color: Colors.white,
            child: Container(
              width: w-15,
              height: 110,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Total Fee Pending",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                      ],
                    ),
                    Text("₹"+widget.user.Myfee.toString(),style: TextStyle(fontSize: 29,fontWeight: FontWeight.w800,color: Colors.green),),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }else{
      return Column(
        children: [
          s("Name", widget.user.Name, false, true),
          s("Father Name", widget.user.Father_Name, true, true),
        ],
      );
    }
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
