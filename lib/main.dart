import 'dart:io' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' ;
import 'package:student_managment_app/L10n/l10n.dart';
import 'package:student_managment_app/Parents_Admin_all_data/Admin/homeportal.dart';
import 'package:student_managment_app/Parents_Admin_all_data/finance/home_p.dart';
import 'package:student_managment_app/Parents_Admin_all_data/managment/home.dart';
import 'package:student_managment_app/Parents_Portal/home.dart';
import 'package:student_managment_app/admin/admin_panel.dart' ;
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/after_login/school_names.dart' ;
import 'package:student_managment_app/anew/parents/home/portal_student.dart';
import 'package:student_managment_app/anew/school/dashboard/school_name.dart';
import 'package:student_managment_app/anew/school_service/bus/portal.dart';
import 'package:student_managment_app/anew/school_service/click_photo/portal.dart';
import 'package:student_managment_app/anew/school_service/gate_pass/gate.dart';
import 'package:student_managment_app/anew/school_service/scanner/home.dart';

import 'package:student_managment_app/api.dart';
import 'package:student_managment_app/before_check/first.dart';
import 'package:student_managment_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_managment_app/l10n/app_localization.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/class/home.dart';
import 'package:student_managment_app/school_class/dormitory/portal.dart';
import 'package:student_managment_app/school_class/employee/home.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' ;
import 'dart:async' ;
import 'dart:convert' ;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' ;
import 'package:firebase_core/firebase_core.dart' ;
import 'package:firebase_messaging/firebase_messaging.dart' ;
import 'package:flutter_localizations/flutter_localizations.dart' ;
import 'package:provider/provider.dart';
import 'package:student_managment_app/school_class/gate_keeper/portal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_review/in_app_review.dart';

Future< void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized() ;
  final bool Admin = prefs.getBool('Admin') ?? false ;
  final bool Parent = prefs.getBool('Parent') ?? false ;
  final String Position = prefs.getString('What') ?? "None";
  await  FirebaseApi().initNotification() ;
  runApp( ChangeNotifierProvider(
    create: (context) => LocaleProvider(),
    child:  MyApp(Admin : Admin, Parent : Parent, position: Position,),
  ),);
}

class MyApp extends StatefulWidget {
  bool Admin;
  bool Parent;
  String position;

  MyApp({required this.Admin, required this.Parent, required this.position});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      print("------------------->");
      _checkForUpdate();
    });
    Timer(Duration(seconds: 240), () {
      print("------------------->");
      _requestReview();
    });
  }

  Future<void> _checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Update is available
        await InAppUpdate.startFlexibleUpdate();
        InAppUpdate.completeFlexibleUpdate().then((_){}).catchError((e){
          print(e);
        });
      }
    } catch (e) {
      print("Error while checking for updates: $e");
    }
  }

  Future<void> _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      // Request the in-app review
      inAppReview.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: "Student Next Lights",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: provider.locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,  // Your custom delegate for app localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 4)),
        builder: (ctx, timer) {
          if (timer.connectionState == ConnectionState.done) {
            if (widget.Parent) {
              if(widget.position == "Parent"){
                return FutureBuilder<StudentModel?>(
                  future: getStudent("bh"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      return PortalStudent(st: snapshot.data!, parent: true,);
                    } else {
                      return Center(child: Text("User not found"));
                    }
                  },
                );
              }else{
                return FutureBuilder<StudentModel?>(
                  future: getStudent("bh"),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      return PortalStudent(st: snapshot.data!, parent: false,);
                    } else {
                      return Center(child: Text("User not found"));
                    }
                  },
                );
              }
            } else {
              if (user == null) {
                return First();
              } else {
                if (widget.position == "Photo") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return HomePhoto(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }else  if (widget.position == "Gate") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return GatePortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }else  if (widget.position == "Dormitory") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return DormitoryKeeper(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }else  if (widget.position == "Gate Keeper") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return GateKeeper(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }else  if (widget.position == "Bus") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return BusPortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                } else  if (widget.position == "Photographer") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return ClickPicPortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }else  if (widget.position == "Class Teacher") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return ClassHome(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }   else  if (widget.position == "Managment") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return ManagmentPPortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }  else  if (widget.position == "Employee") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return Employeeome(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }  else  if (widget.position == "Finance") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return FinancePPortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                } else  if (widget.position == "Managment") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return ManagmentPPortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }  else  if (widget.position == "Admin") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return AdminPortal(user: snapshot.data!);
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                } else  if (widget.position == "SuperAdmin") {
                  return FutureBuilder<UserModel?>(
                    future: getUserByUid(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return AdminP();
                      } else {
                        return Center(child: Text("User not found"));
                      }
                    },
                  );
                }  else if (widget.Admin) {
                  return AdminP();
                } else {
                  if (widget.position == "Principal"){
                    return SchoolName(principal: true,);
                  }else{
                    return SchoolName(principal: false,);
                  }

                }
              }
            }
          } else {
            return Scaffold(
              backgroundColor: Color(0xfffdfdff),
              body: Column(
                children: [
                  SizedBox(height: 140,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image: AssetImage('assets/logo.gif'),
                    ),
                  ),
                  Spacer(),
                  Text("Made with 💖 in India",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
                  Text("Student Next Light",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                  Text("Version 1.0.721",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w300,color: Colors.grey),),
                  SizedBox(height: 60,),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<UserModel?> getUserByUid(String uid) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      return null;
    }
  }

  Future<StudentModel?> getStudent(String uid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String id = prefs.getString('school') ?? "None";
      final String clas = prefs.getString('class') ?? "None";
      final String session = prefs.getString('session') ?? "None";
      final String regist = prefs.getString('id') ?? "None";
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('School')
          .doc(id)
          .collection('Session')
          .doc(session)
          .collection("Class")
          .doc(clas)
          .collection("Student");
      QuerySnapshot querySnapshot = await usersCollection.where('Registration_number', isEqualTo: regist).get();

      if (querySnapshot.docs.isNotEmpty) {
        StudentModel user = StudentModel.fromSnap(querySnapshot.docs.first);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      return null;
    }
  }
}
class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale('en');
    notifyListeners();
  }
}

