import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:studio_next_light/model/student_model.dart';
import 'package:download/download.dart' ;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:ui' as ui ;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' ;
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';

class Download2 extends StatelessWidget {

  String id ;
  String session ;
  String classu ;
  Download2({super.key, required this.id , required this.session, required this.classu});
  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : Text("Download all Student Data")
      ),
      body : Column(
        children: [
          Container(
            height : 220,
            child: Center(
              child: CircleAvatar(
                radius: 68,
                backgroundColor: Colors.blue.shade500,
                child: Icon(Icons.download_for_offline, size : 55, color : Colors.white),
              ),
            ),
          ),
          Container(
            height : MediaQuery.of(context).size.height - 220,
            child : StreamBuilder(
              stream: Fire.collection('School')
                  .doc(id)
                  .collection('Session')
                  .doc(session)
                  .collection("Class")
                  .doc(classu)
                  .collection("Student")
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => StudentModel.fromJson(e.data())).toList() ?? [];
                    return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: 10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUser(
                          user: list[index],
                          c : classu,
                          s : session,
                          school: id,
                        );
                      },
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}



class ChatUser extends StatefulWidget {
  String c;
  String s;
  String school;
  StudentModel user;

  ChatUser({super.key, required this.user, required this.school, required this.s ,required this.c});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  final GlobalKey boundaryKey = GlobalKey();
  @protected
  late QrImage qrImage ;

  void initState(){
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.school}/${widget.s}/${widget.c}/${widget.user.Registration_number}');
    qrImage = QrImage(qrCode);
    WidgetsBinding.instance!.addPostFrameCallback((_) => a());
  }
  void a() async {
    RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Adjust the pixelRatio as needed
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.user.pic),
          ),
          title: Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text("Roll no : " +
              widget.user.Roll_number.toString() +
              "   " +
              widget.user.Class +
              widget.user.Section ),
          splashColor: Colors.orange.shade300,
          tileColor: Colors.grey.shade50,
        ),
        RepaintBoundary(
          key: boundaryKey,
          child: Container(
            color : Colors.white,
            child: Padding ( padding : EdgeInsets.all(45), child : PrettyQrView(
              qrImage: qrImage,
              decoration: const PrettyQrDecoration(
                image: PrettyQrDecorationImage(
                  image: AssetImage('assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png'),
                ),
              ),
            ), ),
          ),
        ),
      ],
    );
  }
}
