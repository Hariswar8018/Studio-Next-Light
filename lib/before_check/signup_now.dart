import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/after_login/school_names.dart';
import 'package:student_managment_app/before_check/forgot_password.dart';

class SScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String s = "Demo";
  String d = "Demo";
  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:  SingleChildScrollView(
        child: Container(
          color: Color(0xfff2f2f2),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 70,),
                  Center(child: Text("Studio Next Light", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 30, fontWeight: FontWeight.w700))),
                  Center(child: Text("Upload Student Data to School Database", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 17, fontWeight: FontWeight.w400))),
                  SizedBox(height: 30,),
                  Image.asset("assets/login_school.gif"),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'School Email',  isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your School email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        d = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ' School Password', isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please type your Password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        s = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  SocialLoginButton(
                    backgroundColor:  Color(0xff50008e),
                    height: 40,
                    text: 'Create New Account',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async {

                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text("Not New? Login Now"),),
                      TextButton(onPressed: () {
                        Navigator.push(
                            context, PageTransition(
                            child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                        ));
                      }, child: Text("Forgot Password?"),),
                    ],
                  ),

                  /* Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(onPressed: () {
                            Navigator.push(
                                context, PageTransition(
                                child: SignUp(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                            ));
                          }, child: Text("New User? Sign Up here"),),
                          TextButton(onPressed: () {
                            Navigator.push(
                                context, PageTransition(
                                child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                            ));
                          }, child: Text("Forgot Password?"),),
                        ],
                      ),*/

                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
