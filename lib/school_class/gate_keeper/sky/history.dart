import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/gate_keeper/history.dart';
import 'package:student_managment_app/school_class/gate_keeper/sky/signature.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hand_signature/signature.dart';

import '../../../model/gatehistory.dart';


class GateHistoryy extends StatelessWidget {
  UserModel user;bool pending;
  GateHistoryy({super.key,required this.user,required this.pending});
  List<GateKeeper> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Pending Guests in School'),
      ),
      body: StreamBuilder(
        stream:pending?Fire.collection('School').doc(user.schoolid).collection('Gate').where("timeleave",isEqualTo: "").snapshots()
            : Fire.collection('School').doc(user.schoolid).collection('Gate').where("timeleave",isEqualTo: "").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => GateKeeper.fromJson(e.data())).toList() ?? [];
              if(list.isEmpty){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Icon(Icons.bedtime_off_outlined,size: 30,color: Colors.red)),
                    Center(child: Text("No History",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800),)),
                    Center(child: Text("No one had entered or leave this School",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),
                  ],
                );
              }
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUse(user: list[index],schoolid: user.schoolid,);
                },
              );
          }
        },
      ),
    );
  }
}