import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanDownload extends StatefulWidget {
  @override
  State<ScanDownload> createState() => _ScanDownloadState();
}

class _ScanDownloadState extends State<ScanDownload> {
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('https://play.google.com/store/apps/details?id=com.starwish.student_managment_app');
    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Download Our App"),
        backgroundColor: Colors.blue.shade50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  width: w*2/3,
                  height: w*2/3,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color:Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: PrettyQrView(
                      qrImage: qrImage,
                      decoration: const PrettyQrDecoration(
                        image: PrettyQrDecorationImage(
                          image: AssetImage('assets/google-play-logo-C0F8C12322-seeklogo.com.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text("SCAN to Download our App",style: TextStyle(fontSize: 23,color: Colors.blue,fontWeight: FontWeight.w800),),
            SizedBox(height: 10,),
            Center(
              child: InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.starwish.student_managment_app');
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                },
                child: Container(
                  height:45,width:w-40,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text("Open Play Store",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () async {
                  final result = await Share.share('Download our Student Managment App here :  https://play.google.com/store/apps/details?id=com.starwish.student_managment_app');

                  if (result.status == ShareResultStatus.success) {
                    Send.message(context, "Thank you for sharing our App !", true);
                    print('Thank you for sharing my website!');
                  }
                },
                child: Container(
                  height:45,width:w-40,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text("Share App",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse('https://www.amazon.com/gp/product/B0DG788G26');
                    if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Container(
                      width: w/2-30,
                      height:170,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          SizedBox(width: 15,),
                          Image.asset(height: 60,
                              "assets/amazon-apps-logo-18BA9949C2-seeklogo.com.png"),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Amazon App Store',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                              SizedBox(height: 3,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse('https://www.indusappstore.com/');
                    if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Container(
                      width: w/2-30,
                      height:170,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          SizedBox(width: 15,),
                          Image.asset(height: 60,
                              "assets/p0OQGhwB_400x400.jpg"),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Indus App Store',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                              SizedBox(height: 3,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
