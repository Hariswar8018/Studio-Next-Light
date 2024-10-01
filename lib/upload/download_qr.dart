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
import 'package:student_managment_app/model/student_model.dart';
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

class Download2 extends StatefulWidget {
  final String id;
  final String session;
  final String classu;
  List<StudentModel> list = [];
  Download2({super.key, required this.id, required this.session, required this.classu,required this.list});

  @override
  _Download2State createState() => _Download2State();
}
Set qr={};
class _Download2State extends State<Download2> {
  final ScrollController _scrollController = ScrollController();

  final Fire = FirebaseFirestore.instance;

  Timer? _scrollTimer;

  void initState(){
   super.initState();
    qr={};
   startOneTimeTimer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }
  void startOneTimeTimer() {
    const delay = Duration(seconds: 2);
    Timer(delay, () {
      // Code to execute after 5 seconds
      _autoScroll();
    });
  }
  void stopc() {
    const delay = Duration(seconds: 5);
    Timer(delay, () {
      // Code to execute after 5 seconds
      Navigator.pop(context);
      print(widget.list.length);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sucess for All "+widget.list.length.toString()+" Students"),
        ),
      );
    });
  }
  void _autoScroll() {
    const delay = Duration(milliseconds: 50); // Delay between each scroll step
    const scrollAmount = 400.0; // Amount to scroll each step

    _scrollTimer = Timer.periodic(delay, (timer) {
      if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(
          _scrollController.position.pixels + scrollAmount,
          duration: Duration(milliseconds: 300), // Animation duration
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
       stopc();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download all Student Data"),
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            child: Center(
              child: Stack(
                children: [
                  Center(child: Icon(Icons.download_for_offline, size: 25, color: Colors.pink)),
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.purpleAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(" Downloading...... ",
              style:TextStyle(color:Colors.red,fontSize: 23,fontWeight: FontWeight.w800)),
          Text("( Please allow the Screen to Scroll till the Last)",
              style:TextStyle(color:Colors.red,fontSize: 14,fontWeight: FontWeight.w800)),
          SizedBox(height:20),
          Container(
            height: MediaQuery.of(context).size.height - 220,
            child: ListView.builder(
              controller: _scrollController, // Attach the ScrollController here
              itemCount: widget.list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUser(
                  user: widget.list[index],
                  c: widget.classu,
                  s: widget.session,
                  school: widget.id,
                );
              },
            ),
          ),
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
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.school}/${widget.s}/${widget.c}/${widget.user.Registration_number}');
    qrImage = QrImage(qrCode);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for the QR code saving to complete before proceeding
      await saveQrCode();
    });
  }
  Future<void> saveQrCode() async {
    try {
      if (qr.contains(widget.user.Registration_number)) {
        print('Student ID already processed: ${widget.user.Registration_number}');
        return;
      }

      qr.add(widget.user.Registration_number);
      await Future.delayed(Duration(milliseconds: 500));

      RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Loop to wait until the boundary is ready for painting
      while (boundary.debugNeedsPaint) {
        print("Boundary needs paint, waiting for the next frame...");
        await Future.delayed(Duration(milliseconds: 100));
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String customName = widget.user.Registration_number;

      // Initialize the result variable with a default value
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        name: customName,
      );

      // Check if the save operation was successful
      if (result['isSuccess'] == true) {
        print("Image saved: $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('Success : ${result}'),
          ),
        );
      } else {
        print("Failed to save image: $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('Failed : to comply'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text('${e}'),
        ),
      );
      print("Error saving image: $e");
    }
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
          subtitle: Text("Registration no : " + widget.user.Registration_number),
          splashColor: Colors.orange.shade300,
          tileColor: Colors.grey.shade50,
        ),
        RepaintBoundary(
          key: boundaryKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(45),
              child: PrettyQrView(
                qrImage: qrImage,
                decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                    image: AssetImage('assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
