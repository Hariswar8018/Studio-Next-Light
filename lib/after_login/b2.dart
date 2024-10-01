import 'dart:convert';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/after_login/class.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // for base64Encode
import 'package:path_provider/path_provider.dart';

class BD extends StatelessWidget {
  String name;
  String pic ;
  bool hindi ;
  String logo ;
  String iname ;
  String number ;
  String id ; String Schoolid ;
  String address ;
  BD({super.key, required this.name, required this.pic, required this.hindi, required this.logo, required this.iname ,
    required this.id, required this.Schoolid , required this.number , required this.address,
  });

  List<StudentModel2> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  final GlobalKey boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text('Wish in Whatsapp'),
      ),
      body: RepaintBoundary(
        key: boundaryKey,
        child: Container(
          child : Center(
            child : Stack(
              children: [
                 Image.asset("assets/03d.jpg"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox( height : 27),
                    Text( "Dear, " + name , style : TextStyle( color : Color(0xffFFCC00) , fontSize: w/19, fontWeight: FontWeight.w800)),
                    SizedBox(height: 20,),
                    Text( "Happy Birthday", style : TextStyle( color : Color(0xffFFCC00) , fontSize: w/12, fontWeight: FontWeight.w900,fontFamily: "RobotoS")),
                    SizedBox( height : 12),
                    Container(
                      width: w*4/7+20,
                      child:  Text( hindi?"एक छात्र के रूप में आप एक महान प्रेरणा और आदर्श हैं । हम आशा करते हैं कि आप अपने पेशेवर जीवन में भी ऐसे ही बने रहेंगे। जन्म दिन की शुभकामनाएं":"As a Student, you are a Great Inspiration and Model. We hope you continue to be same in your Professional Life. Happy Birthday !",textAlign: TextAlign.center,
                          style : TextStyle( color : Colors.white, fontSize: w/27, fontWeight: hindi?FontWeight.w600:FontWeight.w900,fontFamily: "Ly")),
                    ),
                    SizedBox( height : 20),
                    Container(
                      height : 220, width : 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(4, 4), // Adjust the values for the right and bottom offset
                            ),
                          ],
                        ),
                      child : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image : DecorationImage(
                              image : NetworkImage(pic), fit: BoxFit.cover,
                            )
                          ),
                        ),
                      )
                    ),
                    SizedBox( height : 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : [
                        SizedBox( width : 20),
                        CircleAvatar(
                          backgroundImage: NetworkImage(logo),
                          radius: w/13,
                        ),
                        SizedBox( width : 20),
                        Container(
                          width : w-w/13-20-20-31,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children : [
                              Text("Regards , ", style : TextStyle( color : Colors.orange, fontSize : w/27,fontWeight: FontWeight.w800)),
                              Text(iname, style : TextStyle( color : Colors.white, fontSize: w/16, fontStyle: FontStyle.italic, fontWeight: FontWeight.w800)),
                              Text(address, style : TextStyle( color : Colors.white, fontSize : w/25)),
                            ]
                          ),
                        ),
                        Spacer(),
                      ]
                    )
                  ],
                )
              ], alignment: AlignmentDirectional.topCenter,
            )
          )
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Send in Whatsapp Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Please Wait ! Saving your Image and directing you to Whatsapp'),
                ),
              );
              try {
                sendImageToWhatsApp();
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Please Wait ! Saving your Image and directing you to Whatsapp'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void captureScreenshot() async {
    RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    String phoneNumber = "917000994158";

    String base64Image = base64Encode(pngBytes);

    // Convert base64 to bytes
    Uint8List decodedBytes = base64Decode(base64Image);

    // Save the image to a file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/image.png';
    File(filePath).writeAsBytesSync(decodedBytes);

    // Save the image to the gallery
    await ImageGallerySaver.saveFile(filePath);

    await Fire.collection('School').doc(Schoolid).collection('Students').doc(id).update({
      "dne" : true ,
    });
    // Construct the WhatsApp URL
    String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeFull("Check out this image")}&media=${Uri.encodeFull('file://$filePath')}";

    // Launch the WhatsApp URL
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);

    } else {
      print("Could not launch WhatsApp.");
    }

  }
  void sendImageToWhatsApp() async {
    RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
    String phoneNumber = "91" + number;
    String message = Uri.encodeComponent("Happy Birthday Dear, $name! Many Happy returns of the Day");
    String whatsappUrl = "https://api.whatsapp.com/send?phone=$phoneNumber&text=$message";
    print(phoneNumber);
    print(whatsappUrl);
    print(result);

    Uri uri = Uri.parse(whatsappUrl);
    try {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }catch(e){
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch(e) {
      print(e);
    }

    try{
      await Fire.collection('School').doc(Schoolid).collection('Students').doc(id).update({
        "dne": true,
      });
    }catch(e){

    }
  }
}
