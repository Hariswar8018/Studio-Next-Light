import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/after_login/session.dart';
import 'package:flutter/material.dart';
import 'package:studio_next_light/before_check/first.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:studio_next_light/model/school_model.dart';

class Schoo_Name extends StatelessWidget {
  Schoo_Name({super.key});

  List<SchoolModel> list = [] ;
  late Map<String, dynamic> userMap ;
  TextEditingController ud = TextEditingController() ;

  String s = FirebaseAuth.instance.currentUser!.email ?? " " ;
  final Fire = FirebaseFirestore.instance ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Center(
            child: Text(
          "Your School   ",
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.only( right : 5),
            child: IconButton(
              icon: Icon(Icons.waving_hand),
              onPressed: () async{
                final Uri _url =
                Uri.parse('https://wa.me/917000994158?text=Hi%20Wingtrix');
                if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
                }
              },
            )  ,
          )
        ],
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').where('Clientemail', isEqualTo : s ).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => SchoolModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                itemCount: 1,
                padding: EdgeInsets.only(top: 1),
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
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset("assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png")),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Our Website"),
            onTap: () async {
              final Uri _url = Uri.parse('https://wingtrix.in/');
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
            onTap: () async {},
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
              final Uri _url = Uri.parse('https://wa.me/917000994158?text=Hello!%20We%20are%20contacting%20you%20for%20Students%20ID%20Card%20Services!');
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
            subtitle : Text("Log out "),
          ),
         SizedBox(height: 20,),
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
    return InkWell(
      onTap: () {
        if( widget.user.b){
          Navigator.push(
              context,
              PageTransition(
                  child: Session(id: widget.user.id, School : widget.user.Name,
                    EmailB: widget.user.EmailB, RegisB: widget.user.RegisB, Other4B: widget.user.Other4B,
                    Other3B: widget.user.Other3B, Other2B: widget.user.Other2B, Other1B: widget.user.Other1B,
                    MotherB: widget.user.MotherB, DepB: widget.user.DepB, BloodB: widget.user.BloodB,

                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 400)));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(" School Editing had been Closed by Admin "),
            ),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(

                image: DecorationImage(
                    image: NetworkImage(widget.user.Pic), fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: Text(widget.user.Name, style : TextStyle ( fontWeight: FontWeight.w700)),
              subtitle: Text(
                widget.user.Address,
                maxLines: 1,
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.Pic_link),
              ),
              trailing: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person_pin),
                  label: Text(widget.user.Students.toString())),
            ),
            Divider(),
            SizedBox(height : 5),
            Text("   Total Students : 467", style : TextStyle ( fontWeight: FontWeight.w500, fontSize: 16), textAlign : TextAlign.start),
            Text("   Completed Data : 167", style : TextStyle ( fontWeight: FontWeight.w500, fontSize: 16), textAlign : TextAlign.start),
            Text("   Pending Data : 67", style : TextStyle ( fontWeight: FontWeight.w500, fontSize: 16), textAlign : TextAlign.start),
            Text("   ID Card Receive : 6", style : TextStyle ( fontWeight: FontWeight.w500, fontSize: 16), textAlign : TextAlign.start),
            SizedBox(height : 5),
            Divider(),
            ListTile(
              title: Text(widget.user.Chief, style : TextStyle ( fontWeight: FontWeight.w700, fontSize: 16),),
              subtitle: Text("Chief Cordinator"),
              trailing: Container(
                  height: 90, width : 160,
                  child: Image.network(widget.user.AuthorizeSignature)),
            ),
            SizedBox(height : 15),
            Container(
              width : MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.user.uidise, style : TextStyle ( fontWeight: FontWeight.w700, fontSize: 16),),
                        Text("UIDSE"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.user.Phone, style : TextStyle ( fontWeight: FontWeight.w700, fontSize: 16),),
                      Text("Phone"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.user.Adminemail, style : TextStyle ( fontWeight: FontWeight.w700, fontSize: 16), maxLines: 1,),
                      Text("Email"),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height : 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor:  Color(0xff50008e),
                height: 40,
                text: 'Upload Student Data',
                borderRadius: 20,
                fontSize: 18,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  if( widget.user.b){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Session(id: widget.user.id, School : widget.user.Name,
                          EmailB: widget.user.EmailB, RegisB: widget.user.RegisB, Other4B: widget.user.Other4B,
                          Other3B: widget.user.Other3B, Other2B: widget.user.Other2B, Other1B: widget.user.Other1B,
                          MotherB: widget.user.MotherB, DepB: widget.user.DepB, BloodB: widget.user.BloodB,),
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(" School Editing had been Closed by Admin "),
                      ),
                    );
                  }
                  /*CollectionReference collection = FirebaseFirestore.instance.collection('School');
                  await collection.doc(school_id).update({
                    "$to_change" : Admission.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Success ! Updating ! It may take a While'),
                    ),
                  );*/
                 /* Navigator.pop(context);*/
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

