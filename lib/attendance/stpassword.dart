import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/attendance/attendance_register.dart';
import 'package:student_managment_app/model/school_model.dart';

class CheckJ extends StatelessWidget {
   CheckJ({super.key, required this.user});
   final SchoolModel user;
TextEditingController _confirm = TextEditingController();
int i = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          title:
          Text("Confirm Special Access", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
      body : Column(
        children : [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Admin Password', isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please type your Password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'Confirm Special Access',
              borderRadius: 20,
              fontSize: 18,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                if ( _confirm.text == user.SpName){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Atten(user: user, admin : true )
                    ),
                  );
                }else if(i%2 == 0){
                  i += 1 ;
                  final snackBar = SnackBar(
                    content: Text('Wrong Password ! Do Contact your Admin regarding the password if you forgot !'),
                    duration: Duration(seconds: 3), // Optional, default is 4 seconds
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  i += 1 ;
                  final snackBar = SnackBar(
                    content: Text('Wrong Password again ! \nDo Enter as Normal Access if you only need to access Attendance'),
                    duration: Duration(seconds: 3), // Optional, default is 4 seconds
                    action: SnackBarAction(
                      label: 'Enter as Normal Access', onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Atten(user: user, admin : false )
                        ),
                      );
                    },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("OR"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'I don\'t need Special Access',
              borderRadius: 20,
              fontSize: 18,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Atten(user: user, admin : false )
                  ),
                );
              },
            ),
          ),
          Text("*Use this to Only Manage Student Attendance. Student Fee Managment & Staff Managment will be closed", textAlign : TextAlign.center, style : TextStyle(color : Colors.red))
        ]
      )
    );
  }
}
