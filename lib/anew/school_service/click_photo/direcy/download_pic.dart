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
import 'package:student_managment_app/after_login/school_history.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
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

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';

class Download4 extends StatefulWidget {
 SchoolModel school;
 String session;
  List<StudentModel> list = [];
  Download4({super.key, required this.school,required this.list,required this.session});

  @override
  _Download2State createState() => _Download2State();
}
Set qr2={};
class _Download2State extends State<Download4> {
  final ScrollController _scrollController = ScrollController();

  final Fire = FirebaseFirestore.instance;

  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    qr2 = {};

    // Delay the execution of startOneTimeTimer by 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      startOneTimeTimer();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }
  void startOneTimeTimer() {
    const delay = Duration(seconds: 8);
    Timer(delay, () {
      _autoScroll();
      // Code to execute after 5 seconds
      //_

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
    const delay = Duration(milliseconds: 250); // Delay between each scroll step
    const scrollAmount = 100.0; // Amount to scroll each step

    _scrollTimer = Timer.periodic(delay, (timer) {
      if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(
          _scrollController.position.pixels + scrollAmount,
          duration: Duration(milliseconds: 500), // Animation duration
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
            height: MediaQuery.of(context).size.height - 235,
            child: ListView.builder(
              controller: _scrollController, // Attach the ScrollController here
              itemCount: widget.list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUser(
                  user: widget.list[index],
                  sc: widget.school,
                  session: widget.session,
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
  SchoolModel sc;
  StudentModel user;
String session;
  ChatUser({super.key, required this.user, required this.sc,required this.session});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  final GlobalKey boundaryKey = GlobalKey();
  late QrImage qrImage;
  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.sc.id}/${widget.session}/${widget.user.Classn}/${widget.user.Registration_number}');
    qrImage = QrImage(qrCode);
    setState(() {

    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(Duration(seconds: 2), () async {
        await saveqr2Code();
      });

    });

  }
  Future<void> saveqr2Code() async {
    try {
      if (qr2.contains(widget.user.Registration_number)) {
        print('Student ID already processed: ${widget.user.Registration_number}');
        return;
      }

      qr2.add(widget.user.Registration_number);
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
        Send.message(context, "Success : ${result}", true);
      } else {
        print("Failed to save image: $result");
        Send.message(context, "Failed : to comply", false);

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
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.width / 1.572;
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
            width: w,height: h,
            child: Stack(
              children: [
                Container(
                  width: w,height: h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.sc.Pic_link),
                        fit: BoxFit.contain,
                        opacity: 0.1
                    ),
                  ),
                ),
                Container(
                  width: w,height: h,
                  child: Column(
                    children: [
                      Container(
                        width: w,
                        height: h*1/3-10,
                        color: Color(0xff026F06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 1,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(widget.sc.Pic_link),
                              ),
                            ),
                            Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:w-143,
                                  child:  Text(toU(widget.sc.Name),textAlign:TextAlign.center,style: TextStyle(fontSize: w/28,fontWeight: FontWeight.w800,letterSpacing: 1.4,color: Colors.white,height:1),),
                                ),
                                SizedBox(height: 2,),
                                Text(toU(widget.sc.Address),style: TextStyle(fontSize: w/42,fontWeight: FontWeight.w600,color: Color(0xffEED616)),),
                                Text(toU("U-DISE CODE-"+widget.sc.uidise),style: TextStyle(fontSize: w/42,fontWeight: FontWeight.w500,color: Colors.white),),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                width: 52,
                                height: h*1/3-25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.yellowAccent,
                                    width: 0.2
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(widget.user.pic),
                                    fit: BoxFit.cover,
                                  )
                                ),
                              )
                            ),
                            SizedBox(width: 1,),
                          ],
                        ),
                      ),
                      Container(
                        width: w,
                        height: 2,
                        color: Colors.yellow,
                      ),
                      SizedBox(height: 4,),
                      Container(
                        height: h*2/3-40,
                        width: w,
                        child: Row(
                          children: [
                            SizedBox(width: 12,),
                            Container(
                              width: w*1/5+25,
                              height: w*1/5+25,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color:Colors.white,
                                  child: Center(
                                    child: PrettyQrView(
                                      qrImage: qrImage,
                                      decoration: const PrettyQrDecoration(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffA33909),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6.0,right: 6,top: 3,bottom: 3),
                                    child: Text('Parents Gate Pass',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                                  ),
                                ),
                                SizedBox(height: 0.2,),
                                sd(context, "Name", widget.user.Name),
                                sd(context, "Father", widget.user.Father_Name),
                                sd(context, "Class", widget.user.Class+" (${widget.user.Section})"),
                                sd(context, "Mobile",widget.user.Mobile),
                                sd(context, "Address",trimTo25(widget.user.Address)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: w,
                        height: 32,
                        child: Row(
                          children: [
                            Container(
                                width: 80,
                                height: 32,
                                color: Color(0xff026F06),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Admission No.",style: TextStyle(color: Colors.white,fontSize: 9,fontWeight: FontWeight.w600),),
                                    Text(widget.user.Admission_number,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width/49,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                            ),
                            Container(
                              child: CustomPaint(

                                  size: Size(40, 32), painter: DrawTriangle()),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 32,
                              width: 100,
                              child: Column(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(widget.sc.AuthorizeSignature),
                                          fit: BoxFit.contain,
                                        )
                                    ),
                                  ),
                                  Text("Authorize Signature",style: TextStyle(fontSize: 4,fontWeight: FontWeight.w900,letterSpacing: 1.5),)
                                ],
                              ),
                            ),
                            SizedBox(width: 15,),
                            Container(
                              height: 32,
                              width: 100,
                              child:Column(
                                children: [
                                  Container(
                                    height: 25,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/verified.png"),
                                          fit: BoxFit.contain,
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: w,
                        height: 2,
                        color: Color(0xff026F06),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String trimTo25(String input) {
    return input.length > 23 ? input.substring(0, 23) : input;
  }

  String toU(String input) {
    return input.toUpperCase();
  }

  static Widget sd(BuildContext context,String st, String st2)=> Container(
    child: Row(
      children: [
        Container(width: 60,
          child: t1(st,true,context),
        ),
        Text(":  ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/31),),
        Container(width: MediaQuery.of(context).size.width-210,
          child: t1(st2,false,context),
        ),
      ],
    ),
  );
  static t1(String fg,bool b,BuildContext context)=>Text(fg,style: TextStyle(fontWeight: FontWeight.w800,fontSize: MediaQuery.of(context).size.width/32),maxLines: b?1:2,);
}

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    // Starting point (bottom-left corner of the triangle)
    path.moveTo(0, size.height);

    // Draw the right-angle edge (vertical line up to the top-left corner)
    path.lineTo(0, 0);

    // Draw the hypotenuse (from top-left to bottom-right)
    path.lineTo(size.width, size.height);

    // Close the path back to the starting point
    path.close();

    // Draw the triangle
    canvas.drawPath(
      path,
      Paint()..color = Color(0xff026F06), // You can change the color if needed
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


class Hpt extends StatelessWidget {
  SchoolModel sc;
  StudentModel user;
  String session;
  Hpt({super.key ,required this.user, required this.sc,required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Individual Card"),
      ),
      body: ChatUser(user: user,  session: session, sc: sc,),
    );
  }
}
