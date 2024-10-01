/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/after_login/calender.dart';

import 'package:studio_next_light/after_login/session.dart';
import 'package:studio_next_light/model/birthday_student.dart';
import 'package:url_launcher/url_launcher.dart';

import '../after_login/b2.dart';

class Att11 extends StatelessWidget {
  String id, name, st; bool b ;

  Att11({super.key, required this.id, required this.name, required this.b, required this.st});

  List<StudentModel2> list = [];

  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();
  final Fire = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Mark Student\'s Absent'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getStudentsStream(id, st, b),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data?.docs;
          final filteredDocs = data?.where((doc) {
            final presentArray = doc.data()['Present'] as List<dynamic>?; // Use nullable type
            if (presentArray != null) {
              return b ? presentArray.contains(st) : !presentArray.contains(st);
            }
            return false; // Return false if Present field is null
          }).toList() ?? [];
          return ListView.builder(
            itemCount: filteredDocs.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatUser(
                user: StudentModel2.fromJson(filteredDocs[index].data()),
                id : id,
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Make All Student\'s Absent',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              try {
                for (final student in list) {
                  await sendNotification(student);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Success: All Message sent!'),
                  ),
                );
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Falied : The API server is down or the APi is Wrong ! ${e}'),
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
  Future<void> sendNotification(StudentModel2 user) async {
    String apiUrl = 'https://sms.autobysms.com/app/smsapi/index.php';
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('h:mm a').format(currentTime);
    Map<String, String> queryParams = {
      'key': '365E176C71F352',
      'campaign': '0',
      'routeid': '9',
      'type': 'text',
      'contacts': user.Mobile,
      'senderid': 'WAHRAM',
      'msg':
      'Dear Parents, Your ${user.Name} of Class Y Check ABSENT Today Time $formattedTime in our institute ${name} JRAM',
      'template_id': '1407171212391331672',
    };

    String fullUrl = '$apiUrl?' +
        queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');

    try {
      // Make the GET request
      var response = await http.get(Uri.parse(fullUrl));

      // Check the response status code
      if (response.statusCode == 200) {
        print('SMS sent successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to send SMS. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsStream(String id, String? st, bool b) {
    return FirebaseFirestore.instance
        .collection('School')
        .doc(id)
        .collection('Students')
        .snapshots();
  }
}


class ChatUser extends StatefulWidget {
  StudentModel2 user; String id ;

  ChatUser({
    super.key,
    required this.user, required this.id,
  });

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  void initState(){
    checkAndUpdatePresent( widget.user.id, "md");
  }

  Future<void> checkAndUpdatePresent(String documentId, String value) async {
    try {
      // Get the reference to the document
      final docRef = FirebaseFirestore.instance.collection('School')
          .doc(widget.id)
          .collection('Students').doc(documentId);
      // Get the document snapshot
      final docSnapshot = await docRef.get();
      // Check if the document exists
      if (docSnapshot.exists) {
        final presentList = docSnapshot.data()?['Present'] as List<dynamic>? ?? [];
        // Check if the value is already in the present list
        if (!presentList.contains(value)) {
          // Add the value to the present list
          presentList.add(value);
          // Update the document with the new present list
          await docRef.update({'Present': presentList});
          print('Value "$value" added to the "Present" list in document $documentId');
        } else {
          print('Value "$value" already exists in the "Present" list in document $documentId');
        }
      } else {
        print('Document $documentId does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.pic),
      ),
      title: Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Mobile no. : " + widget.user.Mobile),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: MyCalenderPage(
                  idi: widget.user.id,
                  df: widget.user.School_id_one,
                ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 800)));
      },
      trailing: InkWell(
          onTap: () async {
            final Uri _url = Uri.parse('tel:+91${widget.user.Mobile}');
            if (!await launchUrl(_url)) {
              throw Exception('Could not launch $_url');
            }
          },
          child: Icon(Icons.phone, color: Colors.green)),
      splashColor: Colors.orange.shade300,
      tileColor: widget.user.dne ? Colors.grey.shade100 : Colors.white,
    );
  }

  String hjk(String g) {
    String dateTimeString = g; // Replace with your DateTime string
    print(g);
    // Convert DateTime string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }
}

*/
