import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_managment_app/model/bus.dart';

class Send{
  static Color color=BusModel.color;
  static Widget fg(TextEditingController ha,String str, String str2)=> Padding(
    padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 10),
    child: TextFormField(
      controller: ha,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: str,
        hintText: str2,
        isDense: true,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please type It';
        }
        return null;
      },
    ),
  );
  static Widget se(double w,String s){
    return Container(
      width: w-30,
      height: 50,
      decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Center(child: Text(s,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),)),
    );
  }
  static Widget see(double w,String s,Widget icon){
    return Container(
      width: w-30,
      height: 50,
      decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,SizedBox(width: 7,),
          Text(s,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
        ],
      ),
    );
  }
 static  Widget button(BuildContext context,String str){
   return Center(
     child: Container(
       height:45,width:MediaQuery.of(context).size.width-40,
       decoration:BoxDecoration(
         borderRadius:BorderRadius.circular(7),
         color:Colors.blue,
         boxShadow: [
           BoxShadow(
             color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
             spreadRadius: 5, // The extent to which the shadow spreads
             blurRadius: 7, // The blur radius of the shadow
             offset: Offset(0, 3), // The position of the shadow
           ),
         ],
       ),
       child: Center(child: Text(str,style: TextStyle(
           color: Colors.white,
           fontFamily: "RobotoS",fontWeight: FontWeight.w800
       ),)),
     ),
   );
 }
  static void message(BuildContext context,String str, bool green) async{
    await Flushbar(
      titleColor: Colors.white,
      message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.linear,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: green?Colors.green:Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: green?LinearGradient(colors: [Colors.green, Colors.green.shade400]):LinearGradient(colors: [Colors.red, Colors.redAccent.shade400]),
      isDismissible: false,
      duration: Duration(seconds: 3),
      icon: green? Icon(
        Icons.verified,
        color: Colors.white,
      ): Icon(
        Icons.warning,
        color: Colors.white,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      messageText: Text(
        str,
        style: TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }
  static void topic(BuildContext context,String str1,String str) async{
    await Flushbar(
      titleColor: Colors.white,
      message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.linear,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: LinearGradient(colors: [Colors.red, Colors.redAccent.shade400]),
      isDismissible: false,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.warning,
        color: Colors.white,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      titleText:  Text(
        str1,
        style: TextStyle(fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.w700, fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        str,
        style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }

  static Future<void> sendNotificationsToTokens(String name, String mes,String tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    var result = await server.send(
      FirebaseSend(
        validateOnly: false,
        message: FirebaseMessage(
          notification: FirebaseNotification(
            title: name,
            body: mes,
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
    print(result.toString());
  }

  static Future<void> sendNotification(String name, String mes,String tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    var result = await server.send(
      FirebaseSend(
        validateOnly: false,
        message: FirebaseMessage(
          notification: FirebaseNotification(
            title: name,
            body: mes,
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
    print(result.toString());
  }

 static final serviceAccountFileContent = <String, String>{
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