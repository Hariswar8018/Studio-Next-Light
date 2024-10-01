import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:student_managment_app/upload/qr.dart';

class QRSchool extends StatefulWidget {
  String str;bool open;
  QRSchool({super.key,required this.str,this.open=false});

  @override
  State<QRSchool> createState() => _QRSchoolState();
}

class _QRSchoolState extends State<QRSchool> {
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.str}');
    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: widget.open?AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text("My QR"),
      ):AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          image: AssetImage('assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text("SCAN to Apply for GatePass",style: TextStyle(fontSize: 23,color: Colors.blue,fontWeight: FontWeight.w800),),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScanDownload()),
                  );
                },
                child: Container(
                  width: w-40,
                  height:90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(width: 15,),
                      Image.asset(height: 60,
                          "assets/google-play-logo-C0F8C12322-seeklogo.com.png"),
                      SizedBox(width: 9,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1) Download from PlayStore',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Download our App from Playstore',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('and register',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15),
              child: Container(
                width: w-40,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 15,),
                    Image.asset(height: 60,
                        "assets/google-play-logo-C0F8C12322-seeklogo.com.png"),
                    SizedBox(width: 9,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2) Register as GatePass',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Go to English > School Service > GatePass',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('and create account',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15),
              child: Container(
                width: w-40,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 15,),
                    Image.asset(height: 60,
                        "assets/little-boy-holds-mobile-his-hand-with-text-scan-me-child-qr-code_531064-14133.png"),
                    SizedBox(width: 9,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3) Scan QR and ask Permission',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Scan this QR Code to ask for Permission',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('from School / Principal',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
