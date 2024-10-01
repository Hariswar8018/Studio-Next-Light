import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Noticee extends StatelessWidget {

  String id, classid, sessionid, studentid,tokens;
  Noticee({super.key, required this.id,required this.classid,required this.sessionid,required this.studentid ,required this.tokens});
  List<Notice> list = [];
  late Map<String, dynamic> userMap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Send Notification to Student")
      ),
      floatingActionButton: tokens.isEmpty?SizedBox():FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              PageTransition(
                  child: Add(id: id, classid:classid, sessionid: sessionid, studentid: studentid, tokens:tokens),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 300)));
        },
        child:Icon(Icons.add,color:Colors.white),backgroundColor:Colors.blue
      ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('School').doc(id).
          collection('Session').doc(sessionid).collection("Class").doc(classid)
              .collection("Student").doc(studentid).collection("Notices").snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => Notice.fromJson(e.data())).toList() ?? [];
                if(list.isEmpty){
                  return Column(
                      crossAxisAlignment:CrossAxisAlignment.center,
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:[
                        Image.network(width:MediaQuery.of(context).size.width,"https://miro.medium.com/v2/resize:fit:1400/1*Y13puJSDm3OJLAZYKeoK-g.jpeg"),
                        SizedBox(height:20),
                        Text("Send Notification to Parents",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500)),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(textAlign:TextAlign.center,"Send a Notification to Parents on their Mobile. Once send they will be notified",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
                        ),
                        SizedBox(height:40),
                        tokens.isEmpty?Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(textAlign:TextAlign.center,"Opps ! The Parents haven't Login yet for this Student",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500,color:Colors.red)),
                        ):SizedBox(),
                      ]
                  );
                }
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUserR(
                      user: list[index],
                    );
                  },
                );
            }
          },
        ),

    );
  }
}

class ChatUserR extends StatelessWidget {
  Notice user ;
  ChatUserR({super.key, required this.user, });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width-10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
              color: Colors.blue,
              width: 1
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(user.name, style: TextStyle(color: Colors.grey.shade800, fontSize: 18,fontWeight: FontWeight.w700),),
                  Spacer()
                ],
              ),
              Text(user.description),
              Divider(),
              Text(c(user.date), style: TextStyle(color: Colors.grey.shade500, fontSize: 12),),
            ],
          ),
        ),
      ),
    );
  }
  String c(String dateTimeString) {
    // Parse the input string into a DateTime object
    try{
      // Parse the input string into an int and then to a DateTime object
      int millisecondsSinceEpoch = int.parse(dateTimeString);
      DateTime inputDateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
      DateTime now = DateTime.now();

      // Calculate the difference
      Duration difference = now.difference(inputDateTime);

      if (difference.inMinutes < 1) {
        return "Recently";
      } else if (difference.inMinutes >= 1 && difference.inMinutes < 60) {
        return difference.inMinutes.toString() + " min ago";
      } else if (difference.inHours >= 1 && difference.inHours < 24) {
        return difference.inHours.toString() + " hours ago";
      } else if (difference.inDays >= 1 && difference.inDays < 30) {
        return difference.inDays.toString() + " days ago";
      } else {
        return "Long Time ago";
      }
    }catch(e){
      return "Long Time ago";
    }
  }
}




class Add extends StatefulWidget {
  String id, classid, sessionid, studentid,tokens;
  Add({super.key, required this.id,required this.classid,required this.sessionid,required this.studentid ,required this.tokens});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController desc =  TextEditingController();
  TextEditingController link =  TextEditingController();
  TextEditingController name =  TextEditingController();
  TextEditingController linkj =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        iconTheme: IconThemeData(
            color : Colors.white
        ),
        backgroundColor:  Color(0xFF303C52),
        title : Text("Add New Notification" , style : TextStyle(color : Colors.white)),
      ),
      body : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              t1("Name"),
              sd(name, context, 1),
              SizedBox(height: 10),
              t1("Description",),
              sd(desc, context, 4),
            ]
        ),
      ),
      persistentFooterButtons: [
        SocialLoginButton(
            backgroundColor: Colors.blue,
            height: 40,
            text: "Send Notification",
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              final iddd = DateTime.now().millisecondsSinceEpoch.toString();
              try {
                CollectionReference collection = FirebaseFirestore.instance.collection(
                    'School').doc(widget.id).collection('Session').doc(widget.sessionid)
                    .collection('Class').doc(widget.classid)
                    .collection("Student").doc(widget.studentid).collection("Notices");
                Notice s=Notice(id: iddd, date: iddd, name: name.text, description: desc.text,
                    link: '', pic: "", namet: "",
                    coTeach: true, follo: []);
                await collection.doc(iddd).set(s.toJson());
                sendNotifications();
                Navigator.pop(context);
              }catch(e){
                print(e);
              }
            }),
      ],
    );
  }

  Widget t1(String g){
    return Text(g, style : TextStyle(fontSize: 19, fontWeight: FontWeight.w600, ));
  }

  Widget t2(String g){
    return Text(g, style : TextStyle(fontSize: 14, fontWeight: FontWeight.w300));
  }

  Widget sd (TextEditingController cg,  BuildContext context, int yu ){
    return Padding(
        padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
        child: Center(
          child: TextFormField(
            controller: cg, maxLines: 6, minLines: yu,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              isDense: false,
              border: OutlineInputBorder(),
              counterText: '',
            ),
          ),
        )
    );
  }
  Widget sds (TextEditingController cg,  BuildContext context, int yu ){
    return Padding(
      padding: const EdgeInsets.only( top : 10.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg, maxLines: 6, minLines: yu,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none, // No border
                    counterText: '', prefixIcon: Icon(Icons.link, color: Colors.blue,)
                ),
              ),
            )
        ),
      ),
    );
  }
  void sendNotifications() async {
    await sendNotificationsToTokens(widget.tokens);
  }

  Future<void> sendNotificationsToTokens(String tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );

      var result = await server.send(
        FirebaseSend(
          validateOnly: false,
          message: FirebaseMessage(
            notification: FirebaseNotification(
              title: name.text,
              body: desc.text,
            ),
            android: FirebaseAndroidConfig(
              ttl: '3s', // Optional TTL for notification

              /// Add Delay in String. If you want to add 1 minute delay then add it like "60s"
              notification: FirebaseAndroidNotification(
                icon: 'ic_notification', // Optional icon
                color: '#009999', // Optional color
              ),
            ),
            token: tokens, // Send notification to specific user's token
          ),
        ),
      );

      // Print request response
      print(result.toString());
    }


  final serviceAccountFileContent = <String, String>{
    'type': "service_account",
    'project_id': "studio-next-light",
    'private_key_id':  "a0321d013e1c1d188573cfba2f00b4fef0d13895",
    'private_key':  "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCzQVsitKMz0wEf\n79j7iROR2W7qbinklL8oQnkypekTllavh/ds4yMfvsBMoThXXqeeTpp4Ugd74UA6\nLOXw180uNulYpeP/ql6c1o5CyOdBAEwgd8fYKu4iruur7f897gN5N+X/bgMjYk4q\nzNYlKpGd1QlK0/p9155/NoCYzPOTl7P8lSjPrR4xBDKvBOCxBAkxLFPiE0mXW5ed\ndRktIxXDLy9VnWjMzjNOrAsUQZrs18A3nFSPKAtlND0PlS3SjOEPQ9Jhp1AQEIS2\nQfgou1KpuIfIvzoGXDeUnNkDrWetIWps4pXVmUF48rRuxmOa74Isub9Y+kQFoQjn\nIHF+tExLAgMBAAECggEATSgXg0O/b8ImHMoPWo2xF7lAjbWnYJVKBpk+M7fIMD8o\nxts+e+b0qmhfu1w1tR2wBmsNADdGs2LMU34Z52XsEjVekWKuVdDOcrHDgCmbqJXp\nLpyAL6Ki59jk5hdGIzD828Ncw2pl/WgF/1Q15L+C+C3HlybRDjOuLFGYXqzxNxh+\njDMybwfQ06uNWOkpnk8VUbK0gQ5nK1TnSjDOZ4OkXZp7BW+Q/Lg4hSnmg6F38QRH\nTkC1WtjeS6xiRY60LQeoMBBqHEZILQ9zNX2JGiLJgv6aUoGA5W/a3/xUVWd+Ru2f\n8SpW8wwzkLzSgL1E/Fmw5A3C3zsBanwPAkIhqNDwOQKBgQDxZv1Xo19yQx0ag4zD\nj62F574l93MwnPcHDf9X8PVIr/nxEayPzOzJxghmVLwQMMRUy/+ns9zvh+61+PJK\neT/6OuFEHbX/zKE9mmrERJrGVOZ9kMnkRjbpgRq6VbkRbUZhGDgqMuzPx6o2i5A/\n4gm3F6AXTP0P9HFeM7bEeRVmxQKBgQC+GE3k/bWg3MGh1cui6U1CdMgxkR5LSv9T\ne+b4eO+4IvIU6Szbibh44qbJVY05Lmb2VA/cNJ4lFrz3P5MJSQVqPWfmPg7y4uyX\n9/W+geh8O+rUjB9gV35kgJSMaxKIYGZeL1r3fRLzefCIlP6/XS2oLozNXSF9Kaqj\npYbOyCiXzwKBgDBsMkFUGh83ay0YWjIYLfyAQdonysljkwGtQx0GzozoD8DVhMHL\nn2vR93lfYeH1hkxkJ0IiiBzcLXv/Fcrui3DMQseBFjLbfzR2NxhrkohaG2nwky7h\nDr7EEPJzo43lV4q+avW8BVigeno6gJLv6nb5nDlQTirXI657vRuoFizpAoGBAIDg\n2W62070L7ftah4Ubx1WW92Mjj/ZcEl73UdCDrYKZrqaer9rntDnA8HLvnZ925jd7\nJoWU5uMeV18JqxZQe2tb1mUzDc9+KgmeAu32BTi1JrCTj3Ix328j/ZJ1xUrQkJaq\nZHIGSiLoOTtgSJZVBe9QIAXbbij9ZsMsJglripnhAoGAOShUA0siVvt/WiNTODgE\np0alwgV5BrlsD1tYfyQ1hlNbFh7x67ZrBPg/mkNYr7q8/xWDfUdrTngn7xkzNBR8\nYG/RkRxqc+LeF0NSM2PYl84MTCLmJacaJPq/8tZf3tT6amg4nlBm9EGMppn39lDg\n6gbuKH9Dqzn0fCfoatszhV4=\n-----END PRIVATE KEY-----\n",
    'client_email': "firebase-adminsdk-3dfyt@studio-next-light.iam.gserviceaccount.com",
    'client_id':"109409309262803939071",
    'auth_uri':  "https://accounts.google.com/o/oauth2/auth",
    'token_uri':  "https://oauth2.googleapis.com/token",
    'auth_provider_x509_cert_url':  "https://www.googleapis.com/oauth2/v1/certs",
    'client_x509_cert_url': "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-3dfyt%40studio-next-light.iam.gserviceaccount.com",
  };
}



class Notice {
  Notice({
    required this.id,
    required this.date,
    required this.name,
    required this.description,
    required this.link,
    required this.pic,
    required this.namet,
    required this.coTeach,
    required this.follo,
  });

  late final List follo;

  late final String id;
  late final String date;
  late final String name;
  late final String description;
  late final String link;
  late final String pic;
  late final String namet;
  late final bool coTeach;

  Notice.fromJson(Map<String, dynamic> json) {
    follo = json['follo'] ??[];
    id = json['id'] ?? '';
    date = json['date'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    link = json['link'] ?? '';
    pic = json['pic'] ?? '';
    namet = json['namet'] ?? '';
    coTeach = json['coTeach'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['follo']=follo;
    data['id'] = id;
    data['date'] = date;
    data['name'] = name;
    data['description'] = description;
    data['link'] = link;
    data['pic'] = pic;
    data['namet'] = namet;
    data['coTeach'] = coTeach;
    return data;
  }

}


class NotificationService {
  static final String projectId = 'madrasa-e-mstafa'; // Replace with your Firebase project ID
  static final String serviceAccountKeyPath = 'assets/madrasa-e-mustafa-firebase-adminsdk-2frrn-eda9c8c38e.json'; // Path to your service account key JSON file

  static Future<void> sendNotification(String userId, String title, String body, String token) async {
    if (token == null || token.isEmpty) {
      print('No token found for user: $userId');
      return;
    }

    // Prepare notification payload
    final data = {
      'message': {
        'notification': {
          'title': title,
          'body': body,
        },
        'token': token,
      },
    };

    try {
      // Get the service account credentials
      final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(await _loadServiceAccountKey()),
      );

      print("Service account credentials loaded.");

      // Obtain an authenticated HTTP client
      final authClient = await clientViaServiceAccount(
        serviceAccountCredentials,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      print("Authenticated HTTP client obtained.");

      // Send notification
      final response = await authClient.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print("Notification request sent.");

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  static Future<String> _loadServiceAccountKey() async {
    try {
      String key = await rootBundle.loadString(serviceAccountKeyPath);
      print("Service account key loaded.");
      return key;
    } catch (e) {
      print("Error loading service account key: $e");
      rethrow;
    }
  }
}
