import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/admin/admin_panel.dart';
import 'package:student_managment_app/before_check/admin_signup.dart';
import 'package:student_managment_app/before_check/forgot_password.dart';
import 'package:url_launcher/url_launcher.dart';

class Admin extends StatefulWidget {

  @override
  State<Admin> createState() => _SuperAdminState();
}

class _SuperAdminState extends State<Admin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _key = TextEditingController();

  String s = "Demo";
  String k = " ";

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
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                  child: Text("Studio Next Light",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "font1",
                          fontSize: 30,
                          fontWeight: FontWeight.w700))),
              Center(
                  child: Text("Add Schools data and view Entries",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "font1",
                          fontSize: 17,
                          fontWeight: FontWeight.w400))),
              Image.asset("assets/adminlogin.gif"),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your School email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
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
                  labelText: 'Your Passsword',
                  isDense: true,
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
              SizedBox(height: 16.0),
              TextFormField(
                controller: _key,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Admin Key',
                  isDense: true,
                  icon: Icon(Icons.key),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please type your Key';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    k = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              SizedBox(
                height: 10,
              ),
              SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Enter Admin Area',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  if (k == "FRHJJJY6H" ||
                      k == '5690TTKY' ||
                      k == 'FRTYHN7539' ||
                      k == " TYUUIJKN53U" ||
                      k == "RTTT634HJ" ||
                      k == "ERTYY999" ||
                      k == 'R67UGG479' ||
                      k == 'HARI8018' ||
                      k == "FFT479YGHE" ||
                      k == "RRTY3567V" ||
                      k == "ZQET34589" ||
                      k == "RQPI79015" ||
                      k == "YUDDT13" ||
                      k == "EQ007560") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Correct Key ! Loggin you In'),
                      ),
                    );
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: d,
                        password: s,
                      );
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('Admin', true);
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AdminP(),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 800)));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No User found for this Email'),
                          ),
                        );
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Wrong password provided for that user.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${e}"),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Wrong Key ! Please reach to Super Admin to request a Key'),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              SocialLoginButton(
                backgroundColor: Colors.white,
                height: 40,
                text: 'Login with Google', textColor: Colors.black,
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.google,
                onPressed: () async {
                  if (k == "FRHJJJY6H" ||
                      k == '5690TTKY' ||
                      k == 'FRTYHN7539' ||
                      k == " TYUUIJKN53U" ||
                      k == "RTTT634HJ" ||
                      k == "ERTYY999" ||
                      k == 'R67UGG479' ||
                      k == 'HARI8018' ||
                      k == "FFT479YGHE" ||
                      k == "RRTY3567V" ||
                      k == "ZQET34589" ||
                      k == "RQPI79015" ||
                      k == "YUDDT13" ||
                      k == "EQ007560") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Correct Key ! Loggin you In'),
                      ),
                    );
                    const List<String> scopes = <String>[
                      'email',
                      'https://www.googleapis.com/auth/contacts.readonly',
                    ];
                    GoogleSignIn _googleSignIn = GoogleSignIn(
                      scopes: scopes,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text('This will work in next update !'),
                      ),
                    );
                    try {
                      final GoogleSignInAccount? googleUser =
                          await GoogleSignIn().signIn();
// Obtain the auth details from the request
                      final GoogleSignInAuthentication? googleAuth =
                          await googleUser?.authentication;
// Create a new credential
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth?.accessToken,
                        idToken: googleAuth?.idToken,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('Admin', true);
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AdminP(),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 800)));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No User found for this Email'),
                          ),
                        );
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Wrong password provided for that user.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${e}"),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Wrong Key ! Please reach to Super Admin to request a Key'),
                      ),
                    );
                  }
                },
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AdminC(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 800)));
                      },
                      child: Text("New User? Sign Up here"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Forgot(),
                                type: PageTransitionType.topToBottom,
                                duration: Duration(milliseconds: 800)));
                      },
                      child: Text("Forgot Password?"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
