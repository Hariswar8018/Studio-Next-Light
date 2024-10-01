import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http ;

class StudentsJust1 extends StatefulWidget {
  String id; bool premium ;
  String session_id;
  String class_id;
  String Class;
  bool rem;   // Not Yet
  String sname ;
  String st ;
  bool h ; // Editing Attendance
  StudentsJust1({
    super.key,
    required this.id, required this.sname,
    required this.session_id, required this.premium,
    required this.class_id,
    required this.rem, required this.h, required this.st,
    required this.Class,
  });
  @override
  State<StudentsJust1> createState() => _StudentsJust1State();
}

class _StudentsJust1State extends State<StudentsJust1> {

  late Map<String, dynamic> userMap;

  TextEditingController ud = TextEditingController();

  bool send = false ;
  final Fire = FirebaseFirestore.instance;
  DateTime now = DateTime.now();
  bool up=false;
  @override
  @override
  Widget build(BuildContext context) {
    List<StudentModel> list = [];

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.orange,
          title: Text('Students Data'),
          actions: [
            widget.h ? TextButton.icon(
              onPressed: () {
                if (widget.premium) {
                  setState(() {
                    send = !send;
                  });
                  if (send) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Attendance will be Marked, with Sending SMS"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Attendance will be Marked, WITHOUT Sending SMS"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You must be Premium to use this Feature. Do contact your Admin"),
                    ),
                  );
                }
              },
              icon: Icon(Icons.speed, size: 25),
              label: Text("Send P/A Message"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    send ? Colors.blue : Colors.orange),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ) : SizedBox(),
          ]
      ),
      body: StreamBuilder(
        stream: widget.h
            ? Fire.collection('School')
            .doc(widget.id)
            .collection('Session')
            .doc(widget.session_id)
            .collection("Class")
            .doc(widget.class_id)
            .collection("Student")
            .orderBy('Name', descending: true)
            .snapshots()
            : Fire.collection('School')
            .doc(widget.id)
            .collection('Session')
            .doc(widget.session_id)
            .collection("Class")
            .doc(widget.class_id)
            .collection("Student")
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs ?? [];

              final filteredData = widget.h
                  ? data
                  : data.where((e) {
                if (e.data().containsKey('Present') && e['Present'] is List) {
                  return !(e['Present'] as List).contains('${now.day}-${now.month}-${now.year}');
                }
                return true;
              }).toList();

              list = filteredData.map((e) => StudentModel.fromJson(e.data())).toList();

              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                    id: widget.id,
                    session_id: widget.session_id,
                    class_id: widget.class_id,
                    h: widget.h,
                    r: send,
                    length: list.length,
                    sname: widget.sname,
                    st: widget.st,
                    b: widget.rem,
                  );
                },
              );
          }
        },
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: widget.h ? SizedBox() : up
              ? CircularProgressIndicator()
              : SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Message Absentise Student\'s',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              setState(() {
                up = true;
              });
              print("nvhjjh");

              if (list.isEmpty) {
                print("The list is empty. No students to process.");
                setState(() {
                  up = false;
                });
                return;
              }

              try {
                await sendNotification(list);
                setState(() {
                  up = false;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Message already sent ! Success for all Students"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed: The API server is down or the API is Wrong! ${e}'),
                  ),
                );
                Navigator.pop(context);
                setState(() {
                  up = false;
                });
              }
            },
          ),
        ),
      ],
    );
  }


  Future<void> sendNotification(List<StudentModel> list) async {
    print('sendNotification called with ${list.length} students');
    for (StudentModel user in list) {

      if (prabsent.contains(user.Registration_number)) {
        print('Student ID already processed: ${user.Registration_number}');
        print(prabsent);
        return;
      } else {
        print(prabsent);
        print("Processing student: ${user.Registration_number}");
      }

      prabsent.add(user.Registration_number);

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
        'Dear Parents, Your ${user.Name} of Class ${user.Class} Check ABSENT Today Time $formattedTime in our institute ${widget.st} JRAM',
        'template_id': '1407171212391331672',
      };

      String fullUrl = '$apiUrl?' +
          queryParams.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');

      try {
        // Make the GET request
        print("Sending request to: $fullUrl");
        var response = await http.get(Uri.parse(fullUrl));
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
  }

}

class ChatUser extends StatefulWidget {
  StudentModel user;
  int length; bool h ; //attendance edit
  String st ; bool b ; // not yet
  String id;
  bool r ; //message

  String session_id;
String sname ;
  String class_id;

  ChatUser({
    super.key, required this.h , required this.r,
    required this.user,
    required this.sname,
    required this.length, required this.st, required this.b,
    required this.id,
    required this.session_id,
    required this.class_id,
  });

  @override
  State<ChatUser> createState() => _ChatUserState();
}
Set<String> prabsent = {}; // Track processed QR codes


class _ChatUserState extends State<ChatUser> {




  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.pic),
      ),
      title: Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          widget.user.Roll_number.toString() +
          "   Class : " +
          widget.user.Class +" ("+
          widget.user.Section+")"),
      onTap : () async {
        print(widget.user.dict1);
        if(widget.h){
          DateTime now = DateTime.now();
          String stm = '${now.day}-${now.month}-${now.year}';
          if(widget.user.present.contains(stm)){
            DateTime date = DateTime.now();
            String st = '${date.day}-${date.month}-${date.year}';
            try{
              await FirebaseFirestore.instance.collection('School').doc(widget.id)
                  .collection("Session")
                  .doc(widget.session_id).collection("Class").doc(widget.class_id).collection("Student").doc(widget.user.Registration_number)
                  .update({
                'Present': FieldValue.arrayRemove([st]),
              });
              DateTime now = DateTime.now();
              await _storeColorInFirestore(now, Colors.red, false);
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${e}"),
                ),
              );
            }
          }else{
            DateTime date = DateTime.now();
            String st = '${date.day}-${date.month}-${date.year}';
            try{
              await FirebaseFirestore.instance.collection('School').doc(widget.id)
                  .collection("Session")
                  .doc(widget.session_id).collection("Class").doc(widget.class_id).collection("Student").doc(widget.user.Registration_number)
                  .update({
                'Present': FieldValue.arrayUnion([st]),
              });
              DateTime now = DateTime.now();
              checkin();
              await _storeColorInFirestore(now, Colors.blue, true);
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${e}"),
                ),
              );
            }
          }
        }
      },
      trailing:   acheck(),
    splashColor: Colors.orange.shade300,
      tileColor: Colors.grey.shade50,
    );
  }

  Future<void> checkin() async {
    try {
      String formattedDate = "${DateTime
          .now()
          .day}/${DateTime
          .now()
          .month}/${DateTime
          .now()
          .year}";
      Map<String, String> dateEntry = {
        formattedDate: DateTime.now().toString(),
      };
      await FirebaseFirestore.instance.collection('School').doc(widget.id)
          .collection("Session")
          .doc(widget.session_id).collection("Class").doc(widget.class_id)
          .collection("Student").doc(widget.user.Registration_number)
          .update({
        'dict1': FieldValue.arrayUnion([dateEntry]),
      });
    }catch(e){
      print(e);
    }
  }

  Widget acheck(){
    DateTime now = DateTime.now();
    String stm = '${now.day}-${now.month}-${now.year}';
    if ( widget.user.present.contains(stm)) {
      return Text("P", style : TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color : Colors.blue));
    }else{
      return Text("A", style : TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color : Colors.red));
    }
  }

  String addCommas(int number) {
    String formattedNumber = number.toString();
    if (formattedNumber.length <= 3) {
      return formattedNumber; // If number is less than or equal to 3 digits, no need for commas
    }
    int index = formattedNumber.length - 3;
    while (index > 0) {
      formattedNumber = formattedNumber.substring(0, index) +
          ',' +
          formattedNumber.substring(index);
      index -= 2; // Move to previous comma position (every two digits)
    }
    return formattedNumber;
  }

  Future<void> _storeColorInFirestore(DateTime date, Color color, bool i ) async {
    try {
      String st = '${date.day}-${date.month}-${date.year}';
      await FirebaseFirestore.instance.collection('School').doc(widget.id)
          .collection("Students")
          .doc(widget.user.Registration_number)
          .collection("Colors")
          .doc(st)
          .set({
        'color': color.value,
        'date': date,
        'st': st,
      });
      final player = AudioPlayer();
      await player.play(AssetSource("beep-04.mp3"));
      String apiUrl = 'https://sms.autobysms.com/app/smsapi/index.php';
      DateTime currentTime = DateTime.now();
      String formattedTime = DateFormat('h:mm a').format(currentTime);

      if (i && widget.r){

        if (prabsent.contains(widget.user.Registration_number)) {
          print('Student IDDDDDDDDDDDDDDDDDDDDDDDDDDDD already processed: ${widget.user.Registration_number}');
          return;
        }else{
          print(prabsent);
        }

        prabsent.add(widget.user.Registration_number);

        Map<String, String> queryParams = {
          'key': '365E176C71F352',
          'campaign': '0',
          'routeid': '9',
          'type': 'text',
          'contacts': widget.user.Mobile,
          'senderid': 'WAHRAM',
          'msg':
          'Dear Parents, Your ${widget.user.Name} of Class ${widget.user
              .Class} Check IN Time $formattedTime in our institute ${widget.st} JRAM',
          'template_id': '1407171212391331672',
        };

        String fullUrl = '$apiUrl?' +
            queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(
                e.value)}').join('&');

        try {
          // Make the GET request
            var response = await http.get(Uri.parse(fullUrl));
            if (response.statusCode == 200) {
              print('SMS sent successfully');
              print('Response: ${response.body}');
            } else {
              print('Failed to send SMS. Status code: ${response.statusCode}');
            }

        } catch (e) {
          print('Error sending SMS: $e');
        }
      }else if( widget.r ){
        String sv = widget.user.Class ;
        Map<String, String> queryParams = {
          'key': '365E176C71F352',
          'campaign': '0',
          'routeid': '9',
          'type': 'text',
          'contacts': widget.user.Mobile,
          'senderid': 'WAHRAM',
          'msg':
          'Dear Parents, Your ${widget.user.Name} of Class ${sv} Check ABSENT Today Time $formattedTime in our institute ${widget.st} JRAM',
          'template_id': '1407171212391331672',
        };

        String fullUrl = '$apiUrl?' +
            queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(
                e.value)}').join('&');

        try {
          // Make the GET request

            var response = await http.get(Uri.parse(fullUrl));
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

    } catch (e) {
      print('Error sending SMS: $e');
    }
  }
}
