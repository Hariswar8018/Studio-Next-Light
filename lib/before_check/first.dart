import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student_managment_app/Parents_Admin_all_data/search_school.dart';
import 'package:student_managment_app/before_check/admin.dart';
import 'package:student_managment_app/before_check/first2.dart';
import 'package:student_managment_app/before_check/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/before_check/new.dart';
import 'package:student_managment_app/before_check/our_works.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/l10n/app_localization.dart';
import 'package:student_managment_app/main.dart';
import 'package:student_managment_app/super_admin/carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class First extends StatefulWidget {

  First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  List<Carousell> list = [];
  Locale? _locale;

  void setLocale(Locale locale) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.setLocale(locale);
  }
  String st="";
  Widget asd(BuildContext context, String loc, double w, String str, String str2, String asset) {
    final currentLocale = Localizations.localeOf(context);

    return InkWell(
      onTap: () {
        if (currentLocale.languageCode == loc) {
          Navigator.push(
            context,
            PageTransition(
              child: New_S(),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 50),
            ),
          );
        }
        setLocale(Locale(loc));
      },
      child: Container(
        width: w / 2 - 15,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: currentLocale.languageCode == loc ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Image.asset(height: 50, asset),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  str,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  str2,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            currentLocale.languageCode == loc
                ? Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Center(
                  child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white, size: 22),
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
  Widget sd(BuildContext context, String loc, double w, String str, String str2, String asset) {
    final currentLocale = Localizations.localeOf(context);

    return InkWell(
      onTap: () {
        Send.message(context, "Will be available in Next Version of App ( 1.0.75 )", false);
      },
      child: Container(
        width: w / 2 - 15,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: currentLocale.languageCode == loc ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Image.asset(height: 50, asset),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  str,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  str2,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            currentLocale.languageCode == loc
                ? Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Center(
                  child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white, size: 22),
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
 @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
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
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 127,),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Text(AppLocalizations.of(context)!.translate('first_select'),
                style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Text(AppLocalizations.of(context)!.translate('first_select2'),
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
            ),
            SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  c(false,w),c(false,w),c(false,w),
                ],
              ),
            ),
            SizedBox(height: 33,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                asd(context,"en",w, "English","English", "assets/first/cute-happy-girl-boy-student-dressed-beautiful-clothes_679557-721.png"),
                  ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Double Press to Continue",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red),)),
            ),
            a(),
             a(),a(),
             Padding(
               padding: const EdgeInsets.only(left: 8.0,right: 8),
               child: Divider(),
             ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Language to be added soon in App ",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),)),
            ),
            a(),

            a(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                sd(context,"hi",w, "हिन्दी","Hindi", "assets/first/cute-wedding-couple-character-standing-in-traditional-attire-vector.jpg"),

                /*    sd(context,"ta",w, "தமிழ்","Tamil", "assets/first/7174fdc6c11fb222e151817bb185125b.jpg"),*/
                sd(context,"fr",w, "Français","French", "assets/first/french-people-national-dress-flag-600nw-484777525-Photoroom.png"),

              ],
            ),
            a(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               sd(context,"bn",w, "বাংলা","Bengali", "assets/first/istockphoto-1159092857-612x612.jpg"),
                  sd(context,"ja",w, "日本語","Japanese", "assets/first/cute-japanese-couple-traditional-kimono-dress-cartoon_74564-290.png"),
              ],
            ),
            a(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                sd(context,"zh",w, "中文","Chinese", "assets/first/chinese-man-woman-people-national-600nw-313646429.webp"),
                sd(context,"ar",w, "عربي","Arabic", "assets/first/cute-cartoon-character-moslem-kids-student-vector.jpg"),
              ],
            ),


            Spacer(),
            Center(child: Text(AppLocalizations.of(context)!.translate('availablein'),style: TextStyle(fontSize: 10,color: Colors.grey),)),
            Center(
              child: Container(
                width: w-100,height: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/first/flags.png"),
                    )
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
  Widget a()=>SizedBox(height: 10,);

  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
}

mixin AppLocale {
  static const String title = 'title';

  static const Map<String, dynamic> EN = {title: 'Localization'};
  static const Map<String, dynamic> FR = {title: 'ការធ្វើមូលដ្ឋានីយកម្ម'};
  static const Map<String, dynamic> JA = {title: 'ローカリゼーション'};
}