import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:student_managment_app/before_check/first.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/service.dart';
import 'package:url_launcher/url_launcher.dart';

class Global {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 10,),
                  r(Colors.red),
                  r(Colors.blue),
                  r(Colors.green),
                  Spacer(),
                  Icon(Icons.search,color: Colors.grey,size: 25,),
                  SizedBox(width: 13,),
                ],
              ),
              SizedBox(height: 23,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 14,),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png"),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  Text(" Student Next Lights",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
                  Text(" v 1.7.2",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey,fontSize: 9),),

                ],
              ),
              SizedBox(height: 5,),
              ty("Basic Functions"),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun/');
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                },
                child:    p(Icon(Icons.language, color: Colors.black, size: 28,),"Our Website"),
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  Send.message(context, "Will function next Time", false);
                },
                child:  p(Icon(Icons.translate, color: Colors.black, size: 28,),"Change Language"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun');
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                },
                child: p(Icon(Icons.info, color: Colors.black, size: 28,),"Info"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://wa.me/917000994158');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.support, color: Colors.black, size: 28,),"Contact Us") ,
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://wa.me/917978097489');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.support_agent, color: Colors.green, size: 28,),"Developer Support") ,
              ),
              ty("Login Function"),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  print('User signed out');
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('Admin', false)  ;
                  prefs.setBool('Parent', false)  ;
                  prefs.setString('What', "hfhgvjhvhj")  ;
                  // Navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => First()),
                  );
                },
                child:  p(Icon(Icons.logout, color: Colors.red, size: 28,),"Log Out"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://starwish.fun/privacy-policy-for-studio-next-light/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: p(Icon(Icons.privacy_tip, color: Colors.black, size: 28,),"Privacy Policy"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun/delete-account/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.delete, color: Colors.black, size: 28,),"Delete Account"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun/close-account/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.close_rounded, color: Colors.black, size: 28,),"Close Account"),
              ),
              SizedBox(height: 25,),
              InkWell(
                onTap: ()async{
                  final result = await Share.share('Download our Student Managment App to get User Experience  : https://play.google.com/store/apps/details?id=com.starwish.student_managment_app');

                  if (result.status == ShareResultStatus.success) {
                    Navigator.pop(context);
                    Send.message(context, "Thank you for sharing our App !", true);
                    print('Thank you for sharing my website!');
                  }
                },
                child:p(Icon(Icons.share, color: Colors.black, size: 28,),"Share App"),
              ),
              InkWell(
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    Navigator.pop(context);
                  inAppReview.requestReview();
                  }
                },
                child:  p(Icon(Icons.feedback, color: Colors.black, size: 28,),"Feedback"),
              ),
             ty("Social Networks"),
              Row(

                children:[
                  Spacer(),
                  SocialMediaButton.instagram(
                    onTap: () async {
                      final Uri _url = Uri.parse(
                          'https://www.instagram.com/studentnextlights/');
                      if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                      }
                    },
                    size: 50,
                    color: Colors.orange,
                  ),  Spacer(),SocialMediaButton.facebook(
                    onTap: () async {
                      final Uri _url = Uri.parse(
                          'https://www.facebook.com/profile.php?id=61566172200855');
                      if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                      }
                    },
                    size: 50,
                    color: Colors.lightBlueAccent,
                  ),  Spacer(),
                ]
              ),
              Row(
                  children:[
                    Spacer(),
                    SocialMediaButton.twitter(
                      onTap: () async {
                        final Uri _url = Uri.parse(
                            'https://x.com/StudentNextLigh');
                        if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                        }
                      },
                      size: 50,
                      color: Colors.blueAccent,
                    ),  Spacer(),
                    SocialMediaButton.youtube(
                      onTap: () async {
                        final Uri _url = Uri.parse(
                            'https://youtube.com/@studentnextlight?si=fiLGLXt4XZhCxtGq');
                        if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                        }
                      },
                      size: 50,
                      color: Colors.red,
                    ),  Spacer(),
                  ]
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
 static Widget ty(String yui){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Text("  $yui",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.grey),),
      ],
    );
  }
  static p(Widget fg,String g){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 10,),
            fg,
            SizedBox(width: 9,),
            Text(g,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300),),
          ],
        ),
      ),
    );
    return ListTile(
      leading: fg,
      title: Text(g,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
    );
  }
 static Widget r(Color color)=>Padding(
   padding: const EdgeInsets.all(3.0),
   child: Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    ),
 );
  Widget as()=> ListTile(
    leading: Icon(
      Icons.logout,
      color: Colors.red,
      size: 25,
    ),
    title: Text("Log Out"),
    splashColor: Colors.orange.shade200,
    trailing: Icon(
      Icons.arrow_forward_ios_sharp,
      color: Colors.black,
      size: 15,
    ),
    tileColor: Colors.grey.shade50,
    subtitle: Text("Log out "),
  );

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