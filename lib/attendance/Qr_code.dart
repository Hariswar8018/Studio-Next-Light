import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
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

class Qrcode extends StatefulWidget {
  String school_id, class_id, idi, sesiion;

  Qrcode(
      {super.key, required this.school_id, required this.class_id, required this.idi, required this.sesiion});

  @override
  State<Qrcode> createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {

  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.school_id}/${widget.sesiion}/${widget.class_id}/${widget.idi}');
    qrImage = QrImage(qrCode);
  }
  final GlobalKey boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Student's QR Code")
      ),
      body: Column(
        children: [
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
          Text("This is your QR Code ! ", style : TextStyle(color : Colors.blue, fontWeight: FontWeight.w800, fontSize: 22))
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Download Now',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                  Text('Downloading Image !'),
                ),
              );
              try {
                RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Adjust the pixelRatio as needed
                ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                Uint8List pngBytes = byteData!.buffer.asUint8List();
                final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('Image saved $result'),
                  ),
                );
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('${e}'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
