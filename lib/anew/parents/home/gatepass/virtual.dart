
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'dart:convert';
import 'package:student_managment_app/attendance/Qr_code.dart';
import 'dart:io';
import 'dart:ui';
import 'package:student_managment_app/upload/download_qr.dart';
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

class Virtual extends StatefulWidget {
  StudentModel user;SchoolModel st;bool verified;
   Virtual({super.key,required this.user,required this.st,required this.verified});

  @override
  State<Virtual> createState() => _VirtualState();
}

class _VirtualState extends State<Virtual> {
  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    vf();
  }

  vf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('school') ?? "None";
    final String clas = prefs.getString('class') ?? "None";
    final String session = prefs.getString('session') ?? "None";
    final String regist = prefs.getString('id') ?? "None";
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${id}/${session}/${clas}/${regist}');
    qrImage = QrImage(qrCode);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text("Virtual ID Card"),
      ),
      body: Column(
        children: [
          VirtualPassCard.card(widget.user,context,widget.st,widget.verified,qrImage),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Note : This Pass could easily be used in Parents Meeting, Exhibition, ChildTaking, etc. For Entry Anonymously, for Fee Payment You need to get Approval. Please talk with School regarding Confusion"),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: w-20,
              height:90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: widget.st=="QR"?Colors.blue:Colors.red.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  SizedBox(width: 5,),
                  Image.asset(height: 80,
                      "assets/images/login/qr-code-scanning-concept-with-characters_23-2148654288 (1).png"),
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Not Verified ! Verify Now',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                      SizedBox(height: 3,),
                      Text('Verify using Phone SMS or Email Verification',
                        style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                      Text('to Verify it as Parents Phone',
                        style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                    ],
                  ),
                  Spacer(),
                  widget.st=="QR"? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class VirtualPassCard{
  static final GlobalKey boundaryKey = GlobalKey();
  static Widget card(StudentModel user,BuildContext context,SchoolModel sc,bool verified,QrImage qrImage){
    double w=MediaQuery.of(context).size.width;
    double h= MediaQuery.of(context).size.width / 1.572;
    return Container(
      width: w,height: h+60,
      color: Colors.white,
      child: Column(
        children: [
          RepaintBoundary(
            key: boundaryKey,
            child: Stack(
              children: [
            Container(
              width: w,height: h,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(sc.Pic_link),
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
                        color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 7,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(sc.Pic_link),
                              ),
                            ),
                           Spacer(),
                            Container(
                              width: w/2+38,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(sc.Name,style: TextStyle(fontSize: w/25,fontWeight: FontWeight.w900,letterSpacing: 1.5,color: Colors.white),maxLines: 1,),
                                  Text(sc.Address,style: TextStyle(fontSize: w/36,fontWeight: FontWeight.w600,color: Colors.white),maxLines: 1,),
                                  Text("Phone : " +sc.Phone+"  Email : "+sc.Email,style: TextStyle(fontSize: w/41,fontWeight: FontWeight.w500,color: Colors.white),maxLines: 1,),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(user.pic),
                              ),
                            ),
                            SizedBox(width: 7,),
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
                              width:  h*4/8-5,
                              height: h*4/8-5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
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
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Parents Gate Pass',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                                  ),
                                ),
                                sd(context, "Name", user.Name),
                                sd(context, "Father", user.Father_Name),
                                sd(context, "Class", user.Class),
                                sd(context,"Section",user.Section),
                                sd(context, "Mobile",user.Mobile),
                              ],
                            ),
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
                                color: Colors.green,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Admission No.",style: TextStyle(color: Colors.white,fontSize: 9,fontWeight: FontWeight.w600),),
                                    Text(user.Admission_number,style: TextStyle(color: Colors.white,fontSize: 9,fontWeight: FontWeight.w600),),
                                  ],
                                )
                            ),
                            Container(
                              child: CustomPaint(size: Size(40, 32), painter: DrawTriangle()),
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
                                          image: NetworkImage(sc.AuthorizeSignature),
                                          fit: BoxFit.contain,
                                        )
                                    ),
                                  ),
                                  Text("Authorize Signature",style: TextStyle(fontSize: 4,fontWeight: FontWeight.w900,letterSpacing: 1.5),)
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 32,
                              width: 100,
                              child:!verified? Column(
                                children: [
                                  Icon(Icons.warning,color: Colors.red,size: 25,),
                                  Text("Not Verified",style: TextStyle(fontSize: 4,fontWeight: FontWeight.w900,letterSpacing: 1.3,color: Colors.red),)
                                ],
                              ):Column(
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
                        color: Colors.yellow,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(width: w,height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap:() async {
                    try {
                      RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                      Uint8List pngBytes = byteData!.buffer.asUint8List();
                      String customName ="My_Virtual_Card";
                      final result = await ImageGallerySaver.saveImage(
                        Uint8List.fromList(pngBytes),
                        name: customName,
                      );
                      if (result['isSuccess'] == true) {
                        print("Image saved: $result");
                        Send.message(context, "Success : $result", true);
                      } else {
                        print("Failed to save image: $result");
                      Send.message(context, "Failed : $result", false);
                      }
                    } catch (e) {
                      Send.message(context, "Failed : $e", false);
                      print("Error saving image: $e");
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(child: Text("Download Now",style: TextStyle(color: Colors.white),)),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final String id = prefs.getString('school') ?? "None";
                    final String clas = prefs.getString('class') ?? "None";
                    final String session = prefs.getString('session') ?? "None";
                    final String regist = prefs.getString('id') ?? "None";
                    Navigator.push(
                      context,
                      PageTransition(
                        child: Qrcode(
                          school_id: id,
                          class_id: clas,
                          sesiion: session,
                          idi: regist,
                        ),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 800),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                    ),
                    child: Center(child: Text("Show QR",style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
 static Widget sd(BuildContext context,String st, String st2) {
    double w=MediaQuery
        .of(context)
        .size
        .width/28;
    return Container(
     child: Row(
       children: [
         Container(width: 70,
           child: t1(st, true,w),
         ),
         Text(": ",
           style: TextStyle(fontWeight: FontWeight.w800, fontSize: w),),
         Container(width: MediaQuery
             .of(context)
             .size
             .width - 210,
           child: t1(st2, false,w),
         ),
       ],
     ),
   );
 }
  static t1(String fg,bool b,double w)=>Text(fg,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w),maxLines: b?1:2,);
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
      Paint()..color = Colors.green, // You can change the color if needed
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
