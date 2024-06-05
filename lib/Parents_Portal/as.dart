import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:studio_next_light/before_check/first.dart';
import 'package:studio_next_light/model/student_model.dart';
import 'package:studio_next_light/service.dart';
import 'package:url_launcher/url_launcher.dart';

class Global {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset(
                  "assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png")),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Our Website"),
            onTap: () async {
              final Uri _url = Uri.parse('https://ayush.starwish.in/');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            splashColor: Colors.orange.shade200,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(Icons.work, color: Colors.redAccent, size: 30),
            title: Text("Our Services"),
            onTap: () async {
              Navigator.push(
                  context, PageTransition(
                  child: Servie(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
              ));
            },
            splashColor: Colors.orange.shade300,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.redAccent,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(Icons.map, color: Colors.greenAccent, size: 30),
            title: Text("Locate on Map"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'https://www.google.com/maps?q=15.2803236,73.9558804');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.greenAccent,
              size: 20,
            ),
            splashColor: Colors.orange.shade300,
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.redAccent, size: 30),
            title: Text("Mail Us"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'mailto:nextlight000@gmail.com?subject=Known_more_about_services&body=New%20plugin');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            splashColor: Colors.orange.shade300,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.redAccent,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: SocialMediaButton.whatsapp(
              onTap: () {
                print('or just use onTap callback');
              },
              size: 35,
              color: Colors.green,
            ),
            title: Text("Whatsapp"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'https://wa.me/917000994158?text=Hello!%20We%20are%20contacting%20you%20for%20Students%20ID%20Card%20Services!');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            subtitle: Text("Inquire in Whatsapp"),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.green,
              size: 20,
            ),
            splashColor: Colors.orange.shade300,
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: SocialMediaButton.instagram(
              onTap: () {
                print('or just use onTap callback');
              },
              size: 35,
              color: Colors.red,
            ),
            title: Text("Instagram"),
            onTap: () async {
              final Uri _url = Uri.parse(
                  'https://instagram.com/studio_next_light?igshid=MTNiYzNiMzkwZA==');
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            subtitle: Text("Follow on Instagram"),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.purpleAccent,
              size: 20,
            ),
            splashColor: Colors.orange.shade300,
            tileColor: Colors.grey.shade50,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
              size: 30,
            ),
            title: Text("Log Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              print('User signed out');
              SharedPreferences prefs = await SharedPreferences.getInstance();
               prefs.setBool('Admin', false)  ;
              prefs.setBool('Parent', false)  ;
              // Navigate to the login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => First()),
              );
            },
            splashColor: Colors.orange.shade200,
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.black,
              size: 20,
            ),
            tileColor: Colors.grey.shade50,
            subtitle: Text("Log out "),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  static void As(StudentModel user, bool hindi, String snames) async {
    String phoneNumber = "91" + user.Mobile;
    if (hindi){
      String message = " आदरणीय श्री ${user.Father_Name} जी, \n\nआपके बच्चे ${user.Name} का ${geta()} का बकाया ₹${user.Myfee}है। विलंब शुल्क से बचने के लिए कृपया महीने की 15 तारीख तक भुगतान करें। \n \nधन्यवाद,\n${snames}";
      String encodedMessage = Uri.encodeFull(message);
      String  url = "https://wa.me/$phoneNumber?text=$encodedMessage";
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }else{
      String message = "Respected ${user.Father_Name}, \n\nYour child ${user.Name} dues for ${geta()} is ₹${user.Myfee}. Please due Pay by 15th of Month to avoid Late Fee. \n \nThank you,\n${snames}";
      String encodedMessage = Uri.encodeFull(message);
      String  url = "https://wa.me/$phoneNumber?text=$encodedMessage";
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }

  }
  static String geta() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Extract the month and year from the current date
    int currentMonth = now.month;
    int currentYear = now.year;

    // Convert the month number to its corresponding name
    String monthName = monthNumberToName(currentMonth);

    // Print the current month and year
    return  "$monthName $currentYear" ;
  }

  static String monthNumberToName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Invalid Month';
    }
  }
}