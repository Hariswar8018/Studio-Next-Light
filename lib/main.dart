import 'dart:io' ;
import 'package:flutter/material.dart' ;
import 'package:studio_next_light/admin/admin_panel.dart' ;
import 'package:studio_next_light/after_login/school_names.dart' ;
import 'package:studio_next_light/api.dart';
import 'package:studio_next_light/before_check/first.dart';
import 'package:studio_next_light/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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

Future< void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); //initilization of Firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized() ;
  final bool Admin = prefs.getBool('Admin') ?? false ;
  await  FirebaseApi().initNotification() ;
  runApp( MyApp(Admin : Admin));
}


class MyApp extends StatefulWidget {
  bool Admin ;
  MyApp({required this.Admin});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
  }

  User? user = FirebaseAuth.instance.currentUser ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Studio Next Light", debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (ctx, timer) =>
          timer.connectionState == ConnectionState.done
              ? ( user == null ? First() : ( widget.Admin ? AdminP() : Schoo_Name()) ) //Screen to navigate to once the splashScreen is done.
              : Container(color: Colors.white ,
            width: MediaQuery.of(context).size.width ,
            child: Image(
              image: AssetImage(
                  'assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png'
              ),
            ),
          ),
      ),
    );
  }
}
