
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/Parents_Admin_all_data/Admin/homeportal.dart';
import 'package:student_managment_app/Parents_Admin_all_data/finance/home_p.dart';
import 'package:student_managment_app/Parents_Admin_all_data/managment/home.dart';
import 'package:student_managment_app/Parents_Admin_all_data/search_school.dart';
import 'package:student_managment_app/admin/admin_panel.dart';
import 'package:student_managment_app/anew/school_service/bus/portal.dart';
import 'package:student_managment_app/anew/school_service/click_photo/portal.dart';
import 'package:student_managment_app/anew/school_service/gate_pass/gate.dart';
import 'package:student_managment_app/anew/school_service/scanner/home.dart';

import 'package:student_managment_app/before_check/admin.dart';
import 'package:student_managment_app/before_check/forgot_password.dart';
import 'package:student_managment_app/before_check/login.dart';
import 'package:student_managment_app/before_check/super_admin.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/new_login/passwordless.dart';
import 'package:student_managment_app/new_login/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:student_managment_app/school_class/class/home.dart';
import 'package:student_managment_app/school_class/dormitory/portal.dart';
import 'package:student_managment_app/school_class/employee/home.dart';
import 'package:student_managment_app/school_class/gate_keeper/portal.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_login/twitter_login.dart';

class ProfileM extends StatefulWidget {
  String str;
  ProfileM({super.key,required this.str});

  @override
  State<ProfileM> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileM> {

  bool signup=false;

  siugn()async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:(){
            Navigator.pop(context);
            siugn();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: w,height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/main_top.png",height: 200,),
                Spacer(),
                Row(
                  children: [
                    Image.asset("assets/main_bottom.png",height: 20,),
                    Spacer(),
                    Image.asset("assets/login_bottom.png",height: 150,),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: w,height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
                  child: Text("Complete your Profile",
                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Text("Please login to ask for Access",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                ),
                SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      c(true,w),c(true,w),c(true,w),
                    ],
                  ),
                ),
                SizedBox(height: 13,),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade100,
                    child: FaIcon(FontAwesomeIcons.user,size: 50,),
                  ),
                ),
                SizedBox(height: 13,),
                signup?fg(name,"Type your Name","Type Name"):SizedBox(),
                fg(email,"Type your Email","Type your Email"),
                fg(password,"Type your Password","Password"),
                SizedBox(height: 15,),
                InkWell(
                  onTap:() async {
                    save();
                    if(signup){
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        save();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('What', widget.str);
                        String uid=credential.user!.uid;
                        UserModel user = UserModel(name: name.text,
                            email: email.text, uid:uid,
                            pic: "", position: widget.str, last: "",
                            verified: false, probation: false,
                            school: "", schoolid: "",
                            sessionid:"", classid: "", smsend: false, whatsend: false,
                            apisend: false, scan: true, update: true, notify: false, admin: false, admin2: false, schoolpic: '', token: '');
                        await FirebaseFirestore.instance.collection("Users").doc(uid).set(user.toJson());
                        navigatenow(widget.str, user);
                        print(credential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          Send.message(context, "Password is too Weak",false);
                        } else if (e.code == 'email-already-in-use') {
                          print(
                              'The account already exists for that email.');
                          Send.message(context, "Account Already Exist",false);
                        }
                      } catch (e) {
                        Send.message(context, "$e",false);
                      }
                    }else{
                      try {
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        save();
                        String uid = credential.user!.uid;
                        try {
                          CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
                          QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid)
                              .where("position",isEqualTo: widget.str).get();
                          if (querySnapshot.docs.isNotEmpty) {
                            // Convert the document snapshot to a UserModel
                            UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
                            Send.message(context, "Login Success !",true);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('What', widget.str);
                            navigatenow(widget.str, user);
                          } else {
                            Send.message(context, "OOOPs! Looks Like you have Login with Wrong Access",false);
                            await FirebaseAuth.instance.signOut();
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('What', "Photo");

                          }
                        } catch (e) {
                          print("Error fetching user by uid: $e");
                          Send.message(context, "$e",false);
                          await FirebaseAuth.instance.signOut();
                        }
                      }on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          Send.message(context, "No User found for this Email",false);
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
                      height:45,width:w-40,
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
                      child: Center(child: Text(signup?"Sign Up":"Login Now",style: TextStyle(
                          color: Colors.white,
                          fontFamily: "RobotoS",fontWeight: FontWeight.w800
                      ),)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10,),
                    TextButton(onPressed: () {
                      setState(() {
                        if(signup){
                          signup=false;
                        }else{
                          signup=true;
                        }

                      });

                    }, child: Text("New User? Sign Up here"),),
                    Spacer(),
                    TextButton(onPressed: () {
                      Navigator.push(
                          context, PageTransition(
                          child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                      ));
                    }, child: Text("Forgot Password?"),),
                    SizedBox(width: 10,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 2,
                      width: w/2-50,
                      color: Colors.blueGrey,
                    ),
                    Text("OR",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.blueGrey),),
                    Container(
                      height: 2,
                      width: w/2-50,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
                SizedBox(height: 15,),
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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        final OAuthProvider provider = OAuthProvider("microsoft.com");

                        // Define custom parameters if needed
                        provider.setCustomParameters({
                          "tenant": "e131d5cb-eb7d-4551-98b7-4a70ffc88c53",
                        });

                        try {
                          // Trigger the OAuth flow using flutter_web_auth package
                          final result = await FlutterWebAuth.authenticate(
                              url: "https://login.microsoftonline.com/e131d5cb-eb7d-4551-98b7-4a70ffc88c53/oauth2/v2.0/authorize"
                                  "?client_id=4a2a39a1-bb29-4e8c-9514-bdea5a3c578f"
                                  "&response_type=code"
                                  "&redirect_uri=https://studio-next-light.firebaseapp.com/__/auth/handler"
                                  "&response_mode=query"
                                  "&scope=openid profile email",
                              callbackUrlScheme: "yourapp"
                          );
                          // Extract code from the resulting callback URL
                          final Uri resultUri = Uri.parse(result);
                          final String? code = resultUri.queryParameters['code'];
                          if (code != null) {
                            final response = await http.post(
                              Uri.parse("https://login.microsoftonline.com/e131d5cb-eb7d-4551-98b7-4a70ffc88c53/oauth2/v2.0/token"),
                              headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                              },
                              body: {
                                'client_id': '4a2a39a1-bb29-4e8c-9514-bdea5a3c578f',
                                'scope': 'openid profile email',
                                'code': code,
                                'redirect_uri': 'https://studio-next-light.firebaseapp.com/__/auth/handler',
                                'grant_type': 'authorization_code',
                                'client_secret': 'a0W8Q~kCETAk25WxrU3iOz1NZhCdI6x1U6XeCbOR', // Make sure to replace with your app's secret
                              },
                            );

                            final tokens = jsonDecode(response.body);
                            final String? idToken = tokens['id_token'];  // Use this for Firebase
                            final String? accessToken = tokens['access_token'];

                            if (idToken != null) {
                              final OAuthCredential credential = provider.credential(idToken: idToken, accessToken: accessToken);

                              // Sign in to Firebase with the credential
                              final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                              final User? user = userCredential.user;

                              Send.message(context, "Signed in as ${user?.displayName}", false);
                            } else {
                              Send.message(context, "No tokens received", false);
                            }
                          } else {
                            Send.message(context, "No authorization code received", false);
                          }
                        } catch (e) {
                          // Handle errors here
                          Send.message(context, "$e", false);
                          print("Error during Microsoft OAuth: $e");
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
                          child: FaIcon(FontAwesomeIcons.microsoft,color: Colors.orange,),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap:() async {
                        try {
                          final OAuthProvider githubProvider = OAuthProvider(
                              "github.com");
                          try {
                            // Sign in with GitHub using Firebase Authentication
                            final UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(githubProvider);
                            final User? user = userCredential.user;
                            print("Signed in with GitHub: ${user
                                ?.displayName}");
                            Send.message(context, "Signed in with GitHub: ${user
                                ?.displayName}", false);
                          } catch (e) {
                            Send.message(context, "$e", false);
                            print("Error signing in with GitHub: $e");
                          }
                        }catch(e){
                          Send.message(context, "$e", false);
                          print(e);
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
                          child: FaIcon(FontAwesomeIcons.github,color: Colors.black,),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                            context, PageTransition(
                            child: Passwordless(str: widget.str,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
                        ));
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
                          child: FaIcon(FontAwesomeIcons.userSecret,color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void save()async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Email', email.text);
      prefs.setString('Password', password.text);
      print("Saved............");
    }catch(e){
      print(e);
    }
  }
  void loginnow(String uid)async{
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).where("position",isEqualTo: widget.str).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Convert the document snapshot to a UserModel
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        Send.message(context, "Login Success !",true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('What', widget.str);
        navigatenow(widget.str, user);
      }
      else {
        QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
        if(querySnapshot.docs.isEmpty){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('What', widget.str);
          UserModel user = UserModel(name: name.text,
              email: email.text, uid:uid,
              pic: "", position: widget.str, last: "",
              verified: false, probation: false,
              school: "", schoolid: "",
              sessionid:"", classid: "", smsend: false, whatsend: false,
              apisend: false, scan: true, update: true, notify: false, admin: false, admin2: false, schoolpic: '', token: '');
          await FirebaseFirestore.instance.collection("Users").doc(uid).set(user.toJson());
          navigatenow(widget.str, user);
        }else{
          Send.message(context, "OOOPs! Looks Like you have Login with Wrong Access",false);
          await FirebaseAuth.instance.signOut();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('What', "Photo");
        }
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      Send.message(context, "$e",false);
      await FirebaseAuth.instance.signOut();
    }
  }

  void navigatenow(String name,UserModel user){
    save();
    if(name=="Photo"){
      Navigator.push(
          context, PageTransition(
          child: HomePhoto(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Gate Keeper"){
      Navigator.push(
          context, PageTransition(
          child: GateKeeper(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Dormitory"){
      Navigator.push(
          context, PageTransition(
          child: DormitoryKeeper(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Gate"){
      Navigator.push(
          context, PageTransition(
          child: GatePortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Bus"){
      Navigator.push(
          context, PageTransition(
          child: BusPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Photographer"){
      Navigator.push(
          context, PageTransition(
          child: ClickPicPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Class Teacher"){
      Navigator.push(
          context, PageTransition(
          child: ClassHome(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Employee"){
      Navigator.push(
          context, PageTransition(
          child: Employeeome(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Managment"){
      Navigator.push(
          context, PageTransition(
          child: ManagmentPPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Finance"){
      Navigator.push(
          context, PageTransition(
          child: FinancePPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="Admin"){
      Navigator.push(
          context, PageTransition(
          child: AdminPortal(user:user), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }else if(name=="SuperAdmin"){
      Navigator.push(
          context, PageTransition(
          child: AdminP(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
      ));
    }
  }

  Widget fg(TextEditingController ha,String str, String str2)=> Padding(
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

  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController verify=TextEditingController();
  TextEditingController password=TextEditingController();

  Widget c(bool d,double w)=>Container(
    width: w/3-15,height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: d?Colors.blueAccent:Colors.grey.shade300,
    ),
  );
  Widget q(BuildContext context, String asset, String str,String str1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 115;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "Li")),
            ]));
  }
}
