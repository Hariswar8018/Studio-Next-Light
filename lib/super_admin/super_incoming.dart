import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/Parents_Admin_all_data/search_school.dart';
import 'package:student_managment_app/super_admin/carousel.dart';
import 'package:student_managment_app/super_admin/superhome.dart';

class Incoming extends StatelessWidget {
  Incoming({super.key});
  List<SuperModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title : Text("Super Admin Area", style : TextStyle(color : Colors.white)),
        backgroundColor:  Color(0xff50008e),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                PageTransition(
                    child: Carousel(),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 400)));
          }, icon: Icon(Icons.view_carousel_sharp, color : Colors.white)),
          SizedBox(width : 9),
        ],
      ),
      body : StreamBuilder(
        stream: Fire.collection('Admin').where('This', isEqualTo : "This").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => SuperModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                itemCount: 1,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return SuperHome(
                    user: list[index],
                  );
                },
              );
          }
        },
      ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: SocialLoginButton(
              backgroundColor:  Color(0xff50008e),
              height: 40,
              text: 'Export Data Now  >',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Panel_School(b : true),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 400)));
              },
            ),
          ),
        ],
    );
  }
}


class SuperModel {
  SuperModel({
    required this.Students,
  required this.Balrampur,
  required this.College,
  required this.Complete,
  required this.Jashpur,
  required this.Koriya
  });
  late final int Students;
  late final List Co;
  late final List Po;
  late final List Re ;
  late final List Receive; 
      late final List Process;
  late final List Complete;
  late final List Surguja;
  late final List Surjapur;
  late final List Balrampur;
  late final List Jashpur;
  late final List Koriya;
  late final List Manendragarh;
  late final List School;
  late final List College;
  late final List University;

  SuperModel.fromJson(Map<String, dynamic> json) {
     Students = json['Students'] ?? 1;
     Receive = json["Receive"] ?? [] ;
     Process = json["Process"] ?? [] ;
     Complete = json["Complete"] ?? [] ;
     Surguja = json["Surguja"] ?? [] ;
     Surjapur = json["Surjapur"] ?? [] ;
     Balrampur = json["Balrampur"] ?? [] ;
     Jashpur = json["Jashpur"] ?? [] ;
     Koriya = json["Koriya"] ?? [] ;
     Manendragarh = json["Manendragarh"] ?? [] ;
     School = json["School"] ?? [] ;
     College = json["College"] ?? [] ;
     University = json["University"] ?? [] ;
     Co = json['CO'] ?? [];
     Re = json['OR'] ?? [];
     Po = json['PR'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    return data;
  }
}
