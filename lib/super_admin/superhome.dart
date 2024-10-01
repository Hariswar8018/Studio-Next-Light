import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/Parents_Admin_all_data/search_school.dart';
import 'package:student_managment_app/super_admin/order_page.dart';
import 'package:student_managment_app/super_admin/super_incoming.dart';
import 'package:url_launcher/url_launcher.dart';

class SuperHome extends StatelessWidget {
  SuperModel user;
  SuperHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height : 20),
            Container(
              width : MediaQuery.of(context).size.width,
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  a(context, Icon(Icons.group, size : 57, color : Colors.white), user.Students.toString(), "Total", "Students", Color(0xfff44236) ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Order_J(s: 'Orders', name: 'Order Receive',),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: a(context, Icon(Icons.business, size : 57, color : Colors.white), user.Re.length.toString(), "Order", "Receive", Color(0xff2196f3) ))
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
                width : MediaQuery.of(context).size.width,
                child : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap : (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Order_J(s: 'Progress', name: 'Order Processing',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 400)));
            },
                        child: a(context, Icon(Icons.settings_display_rounded, size : 57, color : Colors.white), user.Po.length.toString(), "Order", "Processing", Color(0xff009788) )),
                    GestureDetector(
                        onTap : (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Order_J(s: 'Complete', name: 'Order Complete',),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 400)));
                        },
                        child: a(context, Icon(Icons.paid, size : 57, color : Colors.white), user.Co.length.toString(), "Order", "Complete", Color(0xffff9700) ))
                  ],
                )
            ),
            SizedBox(height: 20,),
            Text("  Surguja Divison :- ", style : TextStyle( fontSize: 22 , fontWeight : FontWeight.w600)),
            wh(context, true, "Surguja", user.Surguja.length.toString()),
            wh(context, false, "Surajpur", user.Surjapur.length.toString()),
            wh(context, true, "Balrampur", user.Balrampur.length.toString()),
            wh(context, false, "Jashpur", user.Jashpur.length.toString()),
            wh(context, true, "Koriya", user.Koriya.length.toString()),
            wh(context, false, "Manendragarh", user.Manendragarh.length.toString()),
            SizedBox(height: 20,),
            Text("  Institutes Counter :- ", style : TextStyle( fontSize: 22 , fontWeight : FontWeight.w600)),
            wh(context, true, "School", user.School.length.toString()),
            wh(context, false, "College", user.College.length.toString()),
            wh(context, true, "University", user.University.length.toString()),
          SizedBox(height : 15),
          ],
        ),
      ),
    );
  }

  Widget wh(context, bool s, String s1, String s2){
    return Center(
      child: Container(
        color: s ? Colors.grey.shade300 : Colors.white,
        width: MediaQuery.of(context).size.width - 20,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Text(" $s1"),
              Spacer(),
              Text("$s2 ")
            ],
          ),
        ),
      ),
    );
  }

  Widget a(context, Icon ah, String number, String st1, String st2 , Color c){
    return  Container(
        color : c,
        width : MediaQuery.of(context).size.width/2 - 10,
        height : MediaQuery.of(context).size.width/2 - 40,
        child : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ah ,
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only( top : 10.0, right : 5),
                    child: Text( number , style : TextStyle( fontSize: 25, fontWeight: FontWeight.w700, color : Colors.white)),
                  ),
                ],
              ),
              Text( st1 , style : TextStyle( fontSize: 18, fontWeight: FontWeight.w700, color : Colors.white), textAlign: TextAlign.left,),
              Text( st2, style : TextStyle( fontSize: 18, fontWeight: FontWeight.w700, color : Colors.white), textAlign: TextAlign.left,),
            ],
          ),
        )
    );
  }
}
