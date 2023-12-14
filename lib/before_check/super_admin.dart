import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:studio_next_light/super_admin/super_incoming.dart';
import 'package:studio_next_light/super_admin/superhome.dart';

class SuperAdmin extends StatefulWidget {

  @override
  State<SuperAdmin> createState() => _SuperAdminState();
}

class _SuperAdminState extends State<SuperAdmin> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  String s = "Demo";

  String d = "Demo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:  Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 70,),
                Center(child: Text("Studio Next Light", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 30, fontWeight: FontWeight.w700))),
                Center(child: Text("Export Data, Lock, Unlock See all Data", style: TextStyle( color : Colors.black,fontFamily: "font1", fontSize: 17, fontWeight: FontWeight.w400))),
                SizedBox(height: 30,),
                Image.asset("assets/imgpsh_fullsize_anim1.gif"),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Your key',  isDense: true,
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
                    labelText: 'Your Passsword', isDense: true,
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
                SizedBox(height: 10,),

                SocialLoginButton(
                  backgroundColor:  Color(0xff50008e),
                  height: 40,
                  text: 'Enter SuperAdmin Area',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    if ( d == "19912006@ganj" && s == "2131ruby2314" ){
                      Navigator.push(
                          context, PageTransition(
                          child: Incoming(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                      ));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Wrong Password or Key'),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 15,),
                SizedBox(height: 10,),
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
    );
  }
}
