import 'package:flutter_riverpod/flutter_riverpod.dart';
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

import 'dart:convert' ;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' ;
import 'package:firebase_core/firebase_core.dart' ;
import 'package:firebase_messaging/firebase_messaging.dart' ;
import 'package:flutter_localizations/flutter_localizations.dart' ;

import 'package:student_managment_app/school_class/gate_keeper/portal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_review/in_app_review.dart';

class MyFind extends ConsumerWidget {
  final bool parent;
  final String position;

   MyFind({required this.parent, required this.position, Key? key}) : super(key: key);
  final studentProvider = FutureProvider.autoDispose.family<StudentModel?, String>((ref, id) async {
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
  });

  final userProvider = FutureProvider.autoDispose.family<UserModel?, String>((ref, uid) async {
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
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (parent) {
      final studentAsyncValue = ref.watch(studentProvider("bh"));
      return studentAsyncValue.when(
        data: (student) => PortalStudent(st: student!, parent: position == "Parent"),
        loading: () => loading(context),
        error: (error, _) => Center(child: Text("Error: $error")),
      );
    } else {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userAsyncValue = ref.watch(userProvider(uid));
      return userAsyncValue.when(
        data: (user) {
          if (position == "Photo") {
            return HomePhoto(user: user!);
          } else if (position == "Gate") {
            return GatePortal(user: user!);
          } else if (position == "Dormitory") {
            return DormitoryKeeper(user: user!);
          } else if (position == "Gate Keeper") {
            return GateKeeper(user: user!);
          } else if (position == "Bus") {
            return BusPortal(user: user!);
          } else if (position == "Photographer") {
            return ClickPicPortal(user: user!);
          } else if (position == "Class Teacher") {
            return ClassHome(user: user!);
          } else if (position == "Managment") {
            return ManagmentPPortal(user: user!);
          } else if (position == "Employee") {
            return Employeeome(user: user!);
          } else if (position == "Finance") {
            return FinancePPortal(user: user!);
          } else if (position == "Admin") {
            return AdminPortal(user: user!);
          } else if (position == "SuperAdmin") {
            return AdminP();
          } else {
            return const Center(child: Text("User not found"));
          }
        },
        loading: () => loading(context),
        error: (error, _) => Center(child: Text("Error: $error")),
      );
    }
  }
  Widget loading(BuildContext context)=>Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.grey.shade50,
      title: Text(""),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width-20,
          height: 150,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8)
          ),
        ),
        SizedBox(height: 15,),
        f1(context),
        SizedBox(height: 15,),
        f1(context),
        SizedBox(height: 15,),
        f1(context),
        SizedBox(height: 15,),
        f1(context),
      ],
    ),
  );
  Widget f1(BuildContext context)=>Container(
    width: MediaQuery.of(context).size.width-20,
    height: 100,
    decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        d(context),
        d(context),
        d(context),
        d(context),
      ],
    ),
  );
  Widget d(BuildContext context)=>Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.circle,color: Colors.white,size: 30,),
      Container(
        width: MediaQuery.of(context).size.width/5,
        height: 8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5)
        ),
      )
    ],
  );
}
