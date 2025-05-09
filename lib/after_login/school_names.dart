import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/Parents_Portal/as.dart';
import 'package:studio_next_light/after_login/Birthdays.dart';
import 'package:studio_next_light/after_login/options.dart';
import 'package:studio_next_light/after_login/session.dart';
import 'package:flutter/material.dart';
import 'package:studio_next_light/attendance/attendance_register.dart';
import 'package:studio_next_light/attendance/stpassword.dart';
import 'package:studio_next_light/before_check/first.dart';
import 'package:studio_next_light/service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:studio_next_light/model/school_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Schoo_Name extends StatelessWidget {
  Schoo_Name({super.key});

  List<SchoolModel> list = [];

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  String s = FirebaseAuth.instance.currentUser!.email ?? " ";

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Global.buildDrawer(context),
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
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(Icons.waving_hand),
              onPressed: () async {

                    String phoneNumber = '917000994158';
                    String message = 'Hi, Studio Next Light! We are contacting you regarding your App as an Institute';

                    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

                    if (await canLaunch(url)) {
                    await launch(url);
                    } else {
// Handle error
                    print('Could not launch WhatsApp');
                    }
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: Fire.collection('School')
            .where('Clientemail', isEqualTo: s)
            .snapshots(),
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
              if (list.isEmpty) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Image.network(
                          "https://assets-v2.lottiefiles.com/a/92920ca4-1174-11ee-9d90-63f3a87b4e3d/c6NYERU5De.png"),
                      Text("No School found for your Email", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(
                          "Looks like Admin of Institution haven't add your Email for School Upload. Please double check your Email or Please contact either Admin or SuperAdmin",
                          textAlign: TextAlign.center),
                      SizedBox(height: 10),
                      TextButton(
                        child: Text("Inquire on Whatsapp"),
                        onPressed: () async {
                          final Uri _url = Uri.parse(
                              'https://wa.me/917000994158?text=Hello!%20We%20are%20contacting%20you%20for%20Students%20ID%20Card%20Services!');
                          if (!await launchUrl(_url)) {
                            throw Exception('Could not launch $_url');
                          }
                        },
                      )
                    ]);
              } else {
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

          }
        },
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
  int i = 0;
  void initState(){
    countTotalMfValue();
  }
  void countTotalMfValue() async {
    int totalMfValue = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(widget.user.id)
          .collection('Session')
          .get();
      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('feet')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['feet'];
            if (mfValue is int) {
              totalMfValue += mfValue;
            } else if (mfValue is double) {
              totalMfValue += mfValue.toInt();
            }
          }
        }
      });

      setState(() {
        i = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.user.b) {
          Navigator.push(
              context,
              PageTransition(
                  child: Session( csession : widget.user.csession,
                    id: widget.user.id,
                    School: widget.user.Name,
                    EmailB: widget.user.EmailB,
                    RegisB: widget.user.RegisB,
                    Other4B: widget.user.Other4B,
                    Other3B: widget.user.Other3B,
                    Other2B: widget.user.Other2B,
                    Other1B: widget.user.Other1B,
                    MotherB: widget.user.MotherB,
                    DepB: widget.user.DepB,
                    BloodB: widget.user.BloodB,
                  ),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 400)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(" School Editing had been Closed by Admin "),
            ),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
              title: Text(widget.user.Name,
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                widget.user.Address,
                maxLines: 1,
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.Pic_link),
              ),
              trailing: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: BDay(
                              logo: widget.user.Pic_link,
                              id : widget.user.id ,
                              School: widget.user.Name, address: widget.user.Address,                            ),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400)));
                  },
                  icon: Icon( Icons.card_giftcard, color : Colors.red ),
                  label: Text("Birthdays", style : TextStyle(color : Colors.red, fontSize: 12))),
            ),
            Divider(),
            SizedBox(height: 5),
            Text("   Total Students : " + i.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.start),
            Text("   Total Students ( This Session ) : " + widget.user.totse.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.start),
            Text("   Completed Data : " +  widget.user.complete.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.start),
            Text("   Pending Data : " +  widget.user.pending.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.start),
            Text("   ID Card Receive : " +  widget.user.receive.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.start),
            SizedBox(height: 5),
            Divider(),
            ListTile(
              title: Text(
                widget.user.Chief,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              subtitle: Text("Chief Cordinator"),
              trailing: Container(
                  height: 90,
                  width: 160,
                  child: Image.network(widget.user.AuthorizeSignature)),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.uidise,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text("UIDSE"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.Phone,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text("Phone"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.Adminemail,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                        maxLines: 1,
                      ),
                      Text("Email"),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Attendance / Fee Registery',
                borderRadius: 20,
                fontSize: 18,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckJ(user: widget.user,)
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Upload Student Data',
                borderRadius: 20,
                fontSize: 18,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  if (widget.user.b) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Session( csession : widget.user.csession,
                          id: widget.user.id,
                          School: widget.user.Name,
                          EmailB: widget.user.EmailB,
                          RegisB: widget.user.RegisB,
                          Other4B: widget.user.Other4B,
                          Other3B: widget.user.Other3B,
                          Other2B: widget.user.Other2B,
                          Other1B: widget.user.Other1B,
                          MotherB: widget.user.MotherB,
                          DepB: widget.user.DepB,
                          BloodB: widget.user.BloodB,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(" School Editing had been Closed by Admin "),
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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Check Order History',
                borderRadius: 20,
                fontSize: 18,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Options(id: widget.user.id,)
                      ),
                    );
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
