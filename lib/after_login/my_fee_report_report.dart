import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/model/fee.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:flutter/material.dart' ;
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/admin/Student_Data_Update.dart';
import 'package:student_managment_app/admin/student_profile_view.dart';
import 'package:student_managment_app/after_login/student_shift.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'dart:typed_data';
import 'package:student_managment_app/upload/storage.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/attendance/single_attendance.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:student_managment_app/model/school_model.dart';

class MyFR extends StatefulWidget {
  final StudentModel user;
  final String school;

  MyFR({super.key, required this.user, required this.school});

  @override
  State<MyFR> createState() => _MyFRState();
}

class _MyFRState extends State<MyFR> {
  List<FeeModel> list = [];
  double i = 1, j = 5;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("My Fee Report"),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Show Transaction',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              try {
                // Reference to the 'users' collection
                CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                // Query the collection based on uid
                QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: widget.school).get();
                // Check if a document with the given uid exists
                if (querySnapshot.docs.isNotEmpty) {
                  // Convert the document snapshot to a UserModel
                  SchoolModel user = SchoolModel.fromSnap(querySnapshot.docs.first);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MyFRr(user: widget.user, list: list, user1: user, u: i.toInt()),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 800)));
                } else {
                  // No document found with the given uid
                  return null;
                }
              } catch (e) {
                print("Error fetching user by uid: $e");
                return null;
              }
            },
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.pic),
              radius: 40,
            ),
          ),
          Text(
            widget.user.Name,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(width: 2),
                  Text(
                    "No. of Last Transaction to Show",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                  ),
                  Spacer(),
                  Text(
                    (i.toInt()).toString(),
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              FlutterSlider(
                values: [i, j],
                max: 5,
                min: 1,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  i = lowerValue;
                  j = upperValue;
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
            ]),
          ),
          Container(
            color: Color(0xff00CE9D),
            width: w,
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 410,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('School')
                  .doc(widget.school)
                  .collection('Fee').where("Registration_N",isEqualTo: widget.user.Registration_number)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => FeeModel.fromJson(e.data())).toList() ?? [];
                    print(list);
                    if (list.isEmpty) {
                      return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.hourglass_empty, color: Colors.red, size: 80),
                                Text(
                                    textAlign: TextAlign.center,
                                    "Look Likes No Transaction have occured during the Timeline",
                                    style: TextStyle(color: Colors.red, fontSize: 17)),
                                SizedBox(height: 15),]));
                    } else {
                      return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(bottom: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser(user: list[index], pic: widget.user.pic);
                        },
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
class ChatUser extends StatelessWidget {
  FeeModel user; String pic;
  ChatUser({super.key,required this.user,required this.pic});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        print(user.id);
        print(user.Registration_N);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(pic),
      ),
      title: Text(" ₹" + user.Total_Fee,style:TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Paid on : "+ user.date+ " on " +user.time),
    );
  }
}

class MyFRr extends StatelessWidget {
  DateTime now = DateTime.now();
  SchoolModel user1;
  StudentModel user;  List<FeeModel> list = [];
  int u;
   MyFRr({super.key,required this.user,required this.list,required   this.user1,required this.u});

   int full(){
     int sum=0;
     for(int i =0;i<list.length;i++){
       sum=sum+ int.parse(list[i].Total_Fee);
     }
     return  sum;
   }
  int fulll(){
    int sum=full() + user.Myfee;
    return  sum;
  }
bool up=false;
int i = 1;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.orange,
        title:Text("My Fee Report")
      ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'Download Now' ,
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                try{
                  // export the frame to a PDF Page
                  final ExportOptions overrideOptions = ExportOptions(
                    textFieldOptions: TextFieldOptions.uniform(
                      interactive: false,
                    ),pageFormatOptions:  PageFormatOptions.custom(width: w, height: w*1.35,
                      clip: true,marginAll: 0,marginBottom: 0,marginLeft: 0,marginRight: 0,marginTop: 0),
                    checkboxOptions: CheckboxOptions.uniform(
                      interactive: false,
                    ),
                  );
                  final pdf = await exportDelegate.exportToPdfDocument(
                      "someFrameId",
                      overrideOptions: overrideOptions);
                  final filePath = await saveFile(pdf, user.Name+ " Transaction Slip");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Success ! File saved on Android>Data>com.starwish.student>data>My.pdf'),
                    ),
                  );
                  if (filePath != null) {
                    Share.shareXFiles([XFile(filePath)], text: 'Here is your PDF file.');
                  }
                }catch(e){
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e}'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      body:ExportFrame(
        frameId: 'someFrameId',
        exportDelegate: exportDelegate,
      child:Container(
        decoration: BoxDecoration(
            color:Colors.white,
          border: Border.all(
            color: Colors.blue,
            width: 2
          )
        ),
        width: w,height: w*1.35,
        child:Column(
          children: [
            Container(
              color:Color(0xff00CE9D),
              width: w,
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user1.Pic_link),
                    radius: w/14,
                  ),
                  SizedBox(width: 12,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user1.Name,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w900,fontSize: w/27)),
                      Text(user1.Address,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w600,fontSize: w/31)),
                      Text("Phone no. : "+user1.Phone,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w800,fontSize: w/32)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: w,
              height: 10,
              color:Colors.black,
            ),
            s(),s(),
            Text("FEE STATEMENT",style:TextStyle(fontWeight:FontWeight.w800,fontSize: w/22,wordSpacing: 2,letterSpacing: 5)),
            s(),
           s(),
           r(w,"Name",user.Name,"Date", now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString()),
            r(w,"Father's Name",user.Father_Name,"Time",now.hour.toString()+":"+now.minute.toString()),
            r(w,"Class",user.Class + " ("+user.Section+")","Roll No",user.Roll_number.toString()),
            s(),
            s(),
            Container(
              color:Color(0xff00CE9D),
              width: w-30,
              height: 20,
              child: Row(
                children: [
                  Container(
                      width:w/2-20,
                      child: Text("  Date & Time",style:TextStyle(color: Colors.white,fontSize: w/30))),
                  Container(
                      width:70,
                      child: Text("  Category",style:TextStyle(color: Colors.white,fontSize: w/30))),
                  Spacer(),
                  Text("  Amount   ",style:TextStyle(color: Colors.white,fontSize: w/30)),
                ],
              ),
            ),
            Container(
          height:u*20,width: w,
          child: ListView.builder(
            itemCount: u,
            itemBuilder: (context, index){
              return Padding(
                padding:EdgeInsets.only(left:13,right:13),
               child: Container(
                decoration: BoxDecoration(
                    color:index%2==0?Colors.white:Colors.grey.shade400,
                    border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1
                    ),
                ),
                width: w-30,
                height: 20,
                child: Row(
                  children: [
                    Container(
                        width:w/2-20,
                        child: Text("  ${list[index].date} on ${list[index].time}",style:TextStyle(color: Colors.black,fontSize: w/32))),
                    Container(
                        width:70,
                        child: Text("  PAID",style:TextStyle(color: Colors.black,fontSize: w/32))),
                    Spacer(),
                    Text("  ${list[index].Total_Fee}   ",style:TextStyle(color: Colors.black,fontSize: w/32)),
                  ],
                ),
              ));
            },
          ),
        ),
            Container(
              decoration: BoxDecoration(
                color:Colors.blue.shade50,
                border: Border.all(
                  color: Colors.grey.shade500,
                  width: 1
                )
              ),
              width: w-30,
              height: 25,
              child: Row(
                children: [
                  Container(
                      width:w/2-20,
                      child: Text("  Total Due Before",style:TextStyle(color: Colors.black,fontSize: w/32))),
                  Container(
                      width:70,
                      child: Text("   ",style:TextStyle(color: Colors.white))),
                  Spacer(),
                  Text("  ${fulll()}   ",style:TextStyle(color: Colors.black,fontSize: w/32)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color:Colors.green.shade100,
                  border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1
                  )
              ),
              width: w-30,
              height: 25,
              child: Row(
                children: [
                  Container(
                      width:w/2-20,
                      child: Text("  Total Paid",style:TextStyle(color: Colors.black,fontSize: w/30))),
                  Container(
                      width:70,
                      child: Text("  ",style:TextStyle(color: Colors.white))),
                  Spacer(),
                  Text("  ${full()}   ",style:TextStyle(color: Colors.black,fontSize: w/30)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color:Colors.red.shade50,
                  border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1
                  )
              ),
              width: w-30,
              height: 25,
              child: Row(
                children: [
                  Container(
                      width:w/2-20,
                      child: Text("  Total DUES",style:TextStyle(color: Colors.black,fontSize: w/30))),
                  Container(
                      width:70,
                      child: Text("  ",style:TextStyle(color: Colors.white))),
                  Spacer(),
                  Text("  ${user.Myfee}   ",style:TextStyle(color: Colors.black,fontSize: w/30)),
                ],
              ),
            ),
            Spacer(),
            Row(
              children: [
                ss(),
                ss(),
                Text("Thanks",style:TextStyle(fontWeight:FontWeight.w800,fontSize: w/28)),
                Spacer(),
              ],
            ),
            Container(
              color:Color(0xff00CE9D),
              width: w-40,
              height: 5,
            ),
            s(),
            s(),
          ],
        )
      ))
    );
  }
  Widget r(double w,String s,String s2, String s3, String s4){
    return  Row(
      children: [
        ss(),
        ss(),
        t1(w,"$s - "+s2),
        Spacer(),
        t1(w,"$s3 - "+s4),
        ss(),
        ss(),
      ],
    );
  }
  Widget s()=>SizedBox(height:10);
  Widget ss()=>SizedBox(width:10);
  Widget t1(double w,String s)=>Text(s,style:TextStyle(fontWeight:FontWeight.w400,fontSize: w/29));
  final ExportDelegate exportDelegate = ExportDelegate();
  Future<String?> saveFile( document, String name) async {
    try {
      final Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        final String downloadsPath = '${dir.path}';
        final String filePath = '$downloadsPath/$name.pdf';

        final File file = File(filePath);
        await file.writeAsBytes(await document.save());

        debugPrint('Saved exported PDF at: $filePath');
        return filePath;
      } else {
        debugPrint('Could not access external storage directory.');
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    }
  }
}

