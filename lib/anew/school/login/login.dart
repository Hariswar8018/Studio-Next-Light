import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/after_login/school_names.dart';
import 'package:student_managment_app/anew/school/dashboard/school_name.dart';
import 'package:student_managment_app/before_check/forgot_password.dart';
import 'package:student_managment_app/before_check/signup_now.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:url_launcher/url_launcher.dart';


class SchoolM extends StatefulWidget {
  bool principal;
  SchoolM({
    required this.principal
});
  @override
  _SchoolMState createState() => _SchoolMState();
}

class _SchoolMState extends State<SchoolM> {
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

  String st = "";
bool signup=false;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Container(
        width: w,height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Center(
              child: Container(
                  width:w-40,height:300,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          image:AssetImage(widget.principal?"assets/images/school/principal.png":"assets/images/login/Back-to-School-Illustration.jpg"),
                          fit: BoxFit.contain
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text("Welcome "+(widget.principal?"Principal to your School":"School Managment Users"),
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text("Please Login to your Account to view all School Data",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
            ),
            SizedBox(height: 2.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
            ),
            SizedBox(height: 10.0),
            InkWell(
              onTap: () async {
                save();
                if(signup){
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: d,
                      password: s,
                    );
                    Navigator.push(
                        context, PageTransition(
                        child: SchoolName(principal: widget.principal,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    widget.principal?prefs.setString('What', "Principal"):prefs.setString('What', "School");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'The password provided is too weak.'),
                        ),
                      );
                    } else if (e.code == 'email-already-in-use') {
                      print(
                          'The account already exists for that email.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'The account already exists for that email.'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${e}'),
                      ),
                    );
                  }
                }else{
                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: d,
                      password: s,
                    );
                    print(credential);
                    Navigator.push(
                        context, PageTransition(
                        child: SchoolName(principal: widget.principal,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                    ));
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    widget.principal?prefs.setString('What', "Principal"):prefs.setString('What', "School");
                  }on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No User found for this Email'),
                        ),
                      );
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      Send.message(context, "Wrong password provided for that user",false);
                    } else {
                      Send.message(context, "${e}",false);
                    }
                  }
                }
              },
              child: Center(
                child: Container(
                  height:45,width:w-20,
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
                  child: Center(child: Text(signup?"SignUp Today":"Login to your School",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () {
                 setState(() {
                   if(signup){
                     signup=false;
                   }else{
                     signup=true;
                   }
                 });
                }, child: Text("New User? Sign Up here"),),
                TextButton(onPressed: () {
                  Navigator.push(
                      context, PageTransition(
                      child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                  ));
                }, child: Text("Forgot Password?"),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap:() async {
                    try {
                      // Trigger the Facebook login flow
                      final LoginResult result = await FacebookAuth.instance.login();

                      // Check if the login was successful
                      if (result.status == LoginStatus.success) {
                        // Obtain the access token from the login result
                        final AccessToken? facebookAccessToken = result.accessToken;

                        // The token is now accessed using `token` field directly
                        if (facebookAccessToken != null) {
                          // Create a credential for Firebase
                          final OAuthCredential credential = FacebookAuthProvider.credential(facebookAccessToken.tokenString);

                          // Sign in to Firebase using the Facebook credential
                          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                          print("Facebook sign-in successful: ${userCredential.user?.displayName}");
                          loginnow(userCredential.user!.uid);
                        }
                      } else if (result.status == LoginStatus.cancelled) {
                        print("Facebook login was cancelled by the user.");
                      } else if (result.status == LoginStatus.failed) {
                        print("Facebook login failed: ${result.message}");
                      }
                    } catch (e) {
                      Send.message(context, "$e", false);
                      print("Error during Facebook login: $e");
                    }
                  },
                  child: Container(
                    width:w/3-20,height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
                          spreadRadius: 5, // The extent to which the shadow spreads
                          blurRadius: 7, // The blur radius of the shadow
                          offset: Offset(0, 3), // The position of the shadow
                        ),
                      ],
                    ),
                    child:Center(
                      child: FaIcon(FontAwesomeIcons.facebook,color: Colors.blue,),
                    ),
                  ),
                ),
                InkWell(
                  onTap:() async {
                    try {
                      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication googleAuth = await googleUser!
                          .authentication;
                      final AuthCredential credential = GoogleAuthProvider
                          .credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      String uid= await FirebaseAuth.instance.currentUser!.uid;
                      loginnow(uid);
                    }catch(e){
                      print(e);
                      Send.message(context, "$e", false);
                    }
                  },
                  child: Container(
                    width:w/3-20,height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
                          spreadRadius: 5, // The extent to which the shadow spreads
                          blurRadius: 7, // The blur radius of the shadow
                          offset: Offset(0, 3), // The position of the shadow
                        ),
                      ],
                    ),
                    child:Center(
                      child: FaIcon(FontAwesomeIcons.google,color: Colors.red,),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      // Initialize Twitter login instance
                      final twitterLogin = TwitterLogin(
                        apiKey: 'z1Yqg9SwvNIEUXRlAEcnyKkn2',
                        apiSecretKey: '1WwAjMBADoj9ZX5WSvZFwVqiLxXbRrnZPcLOdQpzLD3Ycn7ij3',
                        redirectURI: 'https://studio-next-light.firebaseapp.com/__/auth/handler',
                      );

                      // Trigger login
                      final authResult = await twitterLogin.login();

                      // Check for login status
                      switch (authResult.status) {
                        case TwitterLoginStatus.loggedIn:
                        // When logged in successfully, get the session token and secret
                          final session = authResult.authToken!;

                          // Create Firebase credential using Twitter access token and secret
                          final AuthCredential credential = TwitterAuthProvider.credential(
                            accessToken: session,
                            secret: authResult.authTokenSecret!,
                          );

                          // Sign in to Firebase
                          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                          String uid= await FirebaseAuth.instance.currentUser!.uid;
                          loginnow(uid);
                          print("Signed in: ${userCredential.user?.displayName}");
                          break;

                        case TwitterLoginStatus.cancelledByUser:
                          print("Twitter login canceled by user.");
                          break;

                        case TwitterLoginStatus.error:
                          print("Twitter login error: ${authResult.errorMessage}");
                          break;
                        case null:
                          break;
                      // TODO: Handle this case.
                      }
                    } catch (e) {
                      print("Error during Twitter login: $e");
                    }

                  },
                  child: Container(
                    width:w/3-20,height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
                          spreadRadius: 5, // The extent to which the shadow spreads
                          blurRadius: 7, // The blur radius of the shadow
                          offset: Offset(0, 3), // The position of the shadow
                        ),
                      ],
                    ),
                    child:Center(
                      child: FaIcon(FontAwesomeIcons.twitter,color: Colors.blueAccent,),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Container(
                width: w-100,height: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login/design.png"),
                    )
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  void save()async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Email', d);
      prefs.setString('Password', s);
      print("Saved............");
    }catch(e){
      print(e);
    }
  }
  void loginnow(String uid)async{
    save();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      widget.principal?prefs.setString('What', "Principal"):prefs.setString('What', "School");
      Navigator.push(
          context, PageTransition(
          child: SchoolName(principal: widget.principal,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No User found for this Email'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Send.message(context, "Wrong password provided for that user",false);
      } else {
        Send.message(context, "${e}",false);
      }
    }
  }
}
