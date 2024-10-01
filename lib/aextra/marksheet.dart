import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/aextra/session.dart';
import 'package:student_managment_app/function/send.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:student_managment_app/model/school_model.dart';


class Mark extends StatelessWidget {
   Mark({super.key,required this.user});
SchoolModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Make Marksheet"),
      ),
      body:Column(
        children:[
          InkWell(
            onTap:() async {
                final status = await Permission.manageExternalStorage.status;
                if (!status.isGranted) {
                  final result = await Permission.manageExternalStorage.request();
                  if (!result.isGranted) {
                    Send.message(context, "Storage Access not given !", false);
                  }
                }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditM(user:user)),
              );
            },
            child:asd(Icon(Icons.branding_watermark_rounded),"Template 1","Use Template 1 for Marsheet"),
          ),
        ]
      )
    );
  }
  Widget asd(Widget d, String s1, String s2) {
    return ListTile(

      leading: d,
      title: Text(s1,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.blueAccent)),
      subtitle: Text(s2),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueAccent),
    );
  }
}

class EditM extends StatefulWidget {
   EditM({super.key,required this.user});
SchoolModel user;

  @override
  State<EditM> createState() => _EditMState();
}

class _EditMState extends State<EditM> {
   final TextEditingController affNController = TextEditingController();

   final TextEditingController aff1Controller = TextEditingController();

   final TextEditingController aff2Controller = TextEditingController();

   final TextEditingController webController = TextEditingController();

   final TextEditingController sessionController = TextEditingController();

   final TextEditingController classController = TextEditingController();

   final TextEditingController sectionController = TextEditingController();

   final TextEditingController addressController = TextEditingController();

   final TextEditingController rollController = TextEditingController();

   final TextEditingController fnameController = TextEditingController();

   final TextEditingController mnameController = TextEditingController();

   final TextEditingController adNoController = TextEditingController();

   final TextEditingController regNoController = TextEditingController();

   final TextEditingController casteController = TextEditingController();

   final TextEditingController contactController = TextEditingController();

   final TextEditingController adhaarController = TextEditingController();

   final TextEditingController a1Controller = TextEditingController();

   final TextEditingController a2Controller = TextEditingController();

   final TextEditingController a3Controller = TextEditingController();

   final TextEditingController a4Controller = TextEditingController();

   final TextEditingController a5Controller = TextEditingController();

   final TextEditingController a6Controller = TextEditingController();

   final TextEditingController a7Controller = TextEditingController();

   final TextEditingController a8Controller = TextEditingController();

   final TextEditingController a9Controller = TextEditingController();

   final TextEditingController a10Controller = TextEditingController();

   final TextEditingController q1Controller = TextEditingController();

   final TextEditingController q2Controller = TextEditingController();

   final TextEditingController q3Controller = TextEditingController();

   final TextEditingController q4Controller = TextEditingController();

   final TextEditingController q5Controller = TextEditingController();

   final TextEditingController q6Controller = TextEditingController();

   final TextEditingController q7Controller = TextEditingController();

   final TextEditingController q8Controller = TextEditingController();

   final TextEditingController q9Controller = TextEditingController();

   final TextEditingController q10Controller = TextEditingController();

   final TextEditingController h1Controller = TextEditingController();

   final TextEditingController h2Controller = TextEditingController();

   final TextEditingController h3Controller = TextEditingController();

   final TextEditingController h4Controller = TextEditingController();

   final TextEditingController h5Controller = TextEditingController();

   final TextEditingController h6Controller = TextEditingController();

   final TextEditingController h7Controller = TextEditingController();

   final TextEditingController h8Controller = TextEditingController();

   final TextEditingController h9Controller = TextEditingController();

   final TextEditingController h10Controller = TextEditingController();
   double i = 5, j = 10;
   final TextEditingController s1Controller = TextEditingController();

   final TextEditingController s2Controller = TextEditingController();

   final TextEditingController s3Controller = TextEditingController();

   final TextEditingController s4Controller = TextEditingController();

   final TextEditingController s5Controller = TextEditingController();

   final TextEditingController s6Controller = TextEditingController();

   final TextEditingController s7Controller = TextEditingController();

   final TextEditingController s8Controller = TextEditingController();

   final TextEditingController s9Controller = TextEditingController();

   final TextEditingController s10Controller = TextEditingController();
   final TextEditingController Name = TextEditingController();
   bool up = false; String pic ="";

   void initState(){
     s1Controller.text="English";
     s2Controller.text="Hindi";
   }
   final TextEditingController remarks1 = TextEditingController();
   final TextEditingController remarks2 = TextEditingController();
   final TextEditingController remarks3 = TextEditingController();
   final TextEditingController status = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Close Marsheet Editing'),
              content: Text('Do you really want to close the Editing ?'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Pop the dialog
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop(true); // Pop the dialog
                  },
                ),
              ],
            );
          },
        );
        // Return false to prevent the app from being closed immediately
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title:Text("My Marksheet",style:TextStyle(color:Colors.black)),
          actions:[
            Container(
              width:w/2-30,
              child: SwitchListTile(
                title: Text('Enable Editing'),
                value: up,
                onChanged: (bool value) {
                  setState(() {
                    up = value;
                    sum1=0;sum2=0;sum3=0;
                    Map<String, int> iny= letssum();
                    print(iny);
                  });
                },
              ),
            )
          ]
        ),
        body:!up?SingleChildScrollView(
          child: Column(
            children: [
              dc(affNController, 'Affiliation Name', 'Enter affiliation name', false),
              Row(
                children: [
                  Container(
                    width: w/2,
                    child: dc(aff1Controller, 'Enter Affiliation', 'Enter aff1', false),
                  ),
                  Container(
                    width: w/2,
                    child: dc(aff2Controller, 'Enter Affiliation 2', 'Enter aff2', false),
                  ),
                ],
              ),
              dc(webController, 'Website', 'Enter website', false),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.supervised_user_circle, size: 30, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Student Information",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              dc(sessionController, 'Session', 'Enter session', false),
              ListTile(
                onTap: () async {
                  StudentModel u = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SessionJust(id: widget.user.id, student: true, reminder : false, sname : widget.user.Name)),
                  );
                  print(u.Name);
                  setState(() {
                    Name.text = u.Name;
                    classController.text = u.Class;
                    sectionController.text = u.Section;
                    rollController.text=u.Roll_number.toString();
                    regNoController.text = u.Registration_number;
                    regNoController.text = u.Admission_number;
                    addressController.text=hjk(u.newdob);
                    fnameController.text=u.Father_Name;
                    mnameController.text=u.Mother_Name;
                    contactController.text=u.Mobile;
                    pic=u.pic;
                    adNoController.text=u.Admission_number;

                  });
                },
                splashColor: Colors.orange,
                tileColor: Colors.greenAccent.shade100,
                leading: Icon(Icons.dataset_rounded),
                title: Text("Add from School Data",
                    style: TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text("Add from already present Student Data"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
              Row(
                children: [
                  Container(
                    width: w/2,
                    child:  dc(classController, 'Class', 'Enter class', false),
                  ),
                  Container(
                    width: w/4,
                    child: dc(sectionController, 'Section', 'A', false),
                  ),
                  Container(
                    width: w/4,
                    child: dc(rollController, 'Roll No', '3', true),
                  ),
                ],
              ),
              dc(Name, 'Enter Name', 'Enter Name', false),
              dc(addressController, 'Address', 'Enter address', false),
              dc(fnameController, 'Father Name', 'Enter father name', false),
              dc(mnameController, 'Mother Name', 'Enter mother name', false),
              dc(adNoController, 'Board Number', 'Enter Board number', false),
              dc(regNoController, 'Registration Number', 'Enter registration number', false),
              dc(casteController, 'Caste', 'Enter caste', false),
              dc(contactController, 'Contact', 'Enter contact', true),
              dc(adhaarController, 'APAAR ID', 'Enter Apaar Id', false),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.school, size: 30, color: Colors.blueAccent),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Academic Information",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              Text(
                "No. of Subjects : "+(i.toInt()).toString(),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
              ),
              FlutterSlider(
                values: [i, j],
                max: 10,
                min: 5,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  i = lowerValue;
                  j = upperValue;
                  setState(() {});
                },
              ),
              divi(w,  dc( s1Controller, '  Subject 1', 'Enter   Subject', false), dc( s2Controller, '  Subject 2', 'Enter   Subject', false),),
              divi(w,  dc( s3Controller, '  Subject 3', 'Enter   Subject', false), dc( s4Controller, '  Subject 4', 'Enter   Subject', false),),
              divi(w,  dc( s5Controller, '  Subject 5', 'Enter   Subject', false), dc( s6Controller, '  Subject 6', 'Enter   Subject', false),),
             i>6 ?divi(w,  dc( s7Controller, '  Subject 7', 'Enter   Subject', false), dc( s8Controller, '  Subject 8', 'Enter   Subject', false),):SizedBox(),
              i>8?divi(w,  dc( s9Controller, '  Subject 9', 'Enter   Subject', false), dc( s10Controller, '  Subject 10', 'Enter   Subject', false),):SizedBox(),
              s(10),
              r(s1Controller),
              fori(w,d(q1Controller,"Quaterly Exam","100"),d(h1Controller,"Quaterly Exam","100"),d(a1Controller,"Quaterly Exam","100")),
              r(s2Controller),
              fori(w,d(q2Controller,"Quaterly Exam","100"),d(h2Controller,"Quaterly Exam","100"),d(a2Controller,"Quaterly Exam","100")),
              r(s3Controller),
              fori(w,d(q3Controller,"Quaterly Exam","100"),d(h3Controller,"Quaterly Exam","100"),d(a3Controller,"Quaterly Exam","100")),
              r(s4Controller),
              fori(w,d(q4Controller,"Quaterly Exam","100"),d(h4Controller,"Quaterly Exam","100"),d(a4Controller,"Quaterly Exam","100")),
              r(s5Controller),
              fori(w,d(q5Controller,"Quaterly Exam","100"),d(h5Controller,"Quaterly Exam","100"),d(a5Controller,"Quaterly Exam","100")),
              r(s6Controller),
              fori(w,d(q6Controller,"Quaterly Exam","100"),d(h6Controller,"Quaterly Exam","100"),d(a6Controller,"Quaterly Exam","100")),
              r(s7Controller),
              fori(w,d(q7Controller,"Quaterly Exam","100"),d(h7Controller,"Quaterly Exam","100"),d(a7Controller,"Quaterly Exam","100")),
              r(s8Controller),
              fori(w,d(q8Controller,"Quaterly Exam","100"),d(h8Controller,"Quaterly Exam","100"),d(a8Controller,"Quaterly Exam","100")),
              r(s9Controller),
              fori(w,d(q9Controller,"Quaterly Exam","100"),d(h9Controller,"Quaterly Exam","100"),d(a9Controller,"Quaterly Exam","100")),
              r(s10Controller),
              fori(w,d(q10Controller,"Quaterly Exam","100"),d(h10Controller,"Quaterly Exam","100"),d(a10Controller,"Quaterly Exam","100")),
              s(10),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.auto_graph, size: 30, color: Colors.orange),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Academic Performance",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              Row(
                children:[
                  SizedBox(width:19),
                  suiop(remarks1,"Good"), SizedBox(width:7),
                  suiop(remarks1,"Better"),SizedBox(width:7),
                  suiop(remarks1,"Best"),
                ]
              ),
              dc(remarks1, 'Performance Quaterly', 'Good/Better/Best/Empty', false),
              Row(
                  children:[
                    SizedBox(width:19),
                    suiop(remarks2,"Good"),SizedBox(width:7),
                    suiop(remarks2,"Better"),SizedBox(width:7),
                    suiop(remarks2,"Best"),
                  ]
              ),
              dc(remarks2, 'Performance Half Yearly', 'Good/Better/Best/Empty', false),
              Row(
                  children:[
                    SizedBox(width:19),
                    suiop(remarks3,"Good"),SizedBox(width:7),
                    suiop(remarks3,"Better"),SizedBox(width:7),
                    suiop(remarks3,"Best"),
                  ]
              ),
              dc(remarks3, 'Performance Annual', 'Good/Better/Best/Empty', false),
              Row(
                  children:[
                    SizedBox(width:19),
                    suiop(status,"Pass"),SizedBox(width:7),
                    suiop(status,"Fail"),
                  ]
              ),
              dc(status, 'Status', 'Pass/Fail/Empty',false),
              s(20),
            ],
          ),
      ):
        ExportFrame(
              frameId: 'someFrameId',
              exportDelegate: exportDelegate,
              child:Container(
                  decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border.all(
                          color: Colors.orangeAccent,
                          width: 1
                      ),
                  ),
                  width: w,height: w*1.35,
                  child:Column(
                  children:[
                    s(4),
                    Container(
                      width: w,
                      height: w/7+6,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.user.Pic_link
                            ),
                            radius: w/27*2-2,
                          ),
                          Container(
                            width: w/2+40,
                            height: w/7+6,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Text(textAlign:TextAlign.center,widget.user.Name,style:TextStyle(fontSize: w/27,color:Colors.blue,fontWeight: FontWeight.w900,letterSpacing: 1.3)),
                                 h2(w,widget.user.Address),
                                h2(w,"( Affiliated to ${affNController.text} )"),
                                h2(w,"AFFILIATION NO : "+aff1Controller.text),
                                h2(w,"Phone : "+widget.user.Phone),
                              ],
                            )
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.user.Pic_link
                            ),
                            radius: w/27*2-2,
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 3,),
                  yu(w,"ACADEMIC RECORD ( ${sessionController.text} )"),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                          width:w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  row1(w,"Student Name",Name.text,"Class",classController.text+ "  ( "+sectionController.text+" )"),
                                  row1(w,"Father Name",fnameController.text,"Roll No.",rollController.text),
                                  row1(w,"Mother Name",mnameController.text,"Dob",addressController.text),
                                  row1(w,"Admission No. ",adNoController.text,"Category",casteController.text),
                                  row1(w,"APAAR ID",adhaarController.text,"Mobile",contactController.text,),
                                ],
                              ),
                              Spacer(),
                              Container(
                                width: 55,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(pic),
                                    fit: BoxFit.cover
                                  )
                                ),
                              )
                            ],
                          )),
                    ),
                    yu(w,"SCHOLASTIC RECORD"),
                    Container(
                      color:Colors.grey.shade300,
                      width: w,height: 30,
                      child:Row(
                        children: [
                          Container(
                            width: w*6/12,height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.blue)
                            ),
                            child:Text("  Subjects",style:TextStyle(fontSize: w/25,))
                          ),
                         col(w,1),
                          col(w,2),col(w,3),
                        ],
                      )
                    ),
                    Container(
                        width: w,height:( w/31)*10,
                        child:Column(
                          children: [
                            con(w,s1Controller,q1Controller,h1Controller,a1Controller),
                            con(w,s2Controller,q2Controller,h2Controller,a2Controller),
                            i>2?con(w,s3Controller,q3Controller,h3Controller,a3Controller): SizedBox(),
                            i>3?con(w,s4Controller,q4Controller,h4Controller,a4Controller): SizedBox(),
                            i>4?con(w,s5Controller,q5Controller,h5Controller,a5Controller): SizedBox(),
                            i>5?con(w,s6Controller,q6Controller,h6Controller,a6Controller) : SizedBox(),
                            i>6?con(w,s7Controller,q7Controller,h7Controller,a7Controller) : SizedBox(),
                            i>7?con(w,s8Controller,q8Controller,h8Controller,a8Controller) : SizedBox(),
                            i>8?con(w,s9Controller,q9Controller,h9Controller,a9Controller) : SizedBox(),
                           i>9 ?con(w,s10Controller,q10Controller,h10Controller,a10Controller) : SizedBox(),
                          ],
                        )
                    ),
                    SizedBox(height:6),
                    Container(
                        color:Colors.grey.shade300,
                        width: w,height: 16,
                        child:Row(
                          children: [
                            Container(
                                width: w*6/12,
                                child:Text("  Total Marks",style:TextStyle(fontSize: w/38))
                            ),
                        Container(
                            width: w*2/12,
                            child:Container(
                                width:w*2/12,
                                height:16,
                                child:Center(child: Text((sum1/2).toStringAsFixed(0) + " / ${((i*100).toInt()).toString()}",style:TextStyle(fontSize:w/41)))
                            )
                        ),
                            Container(
                                width: w*2/12,
                                child:Container(
                                    width:w*2/12,
                                    height:16,
                                    child:Center(child: Text((sum2/2).toStringAsFixed(0) + " / ${((i*100).toInt()).toString()}",style:TextStyle(fontSize:w/41)))
                                )
                            ),
                            Container(
                                width: w*2/12,
                                child:Container(
                                    width:w*2/12,
                                    height:16,
                                    child:Center(child: Text((sum3/2).toStringAsFixed(0) + " / ${((i*100).toInt()).toString()}",style:TextStyle(fontSize:w/41)))
                                )
                            ),
                          ],
                        )
                    ),
                    Container(
                        color:Colors.grey.shade300,
                        width: w,height: 16,
                        child:Row(
                          children: [
                            Container(
                                width: w*6/12,
                                child:Text("  Percentage",style:TextStyle(fontSize: w/38))
                            ),
                            Container(
                                width: w*2/12,
                                child:Container(
                                    width:w*2/12,
                                    height:16,
                                    child:Center(child: Text(letscount(sum1),style:TextStyle(fontSize:w/41)))
                                )
                            ),
                            Container(
                                width: w*2/12,
                                child:Container(
                                    width:w*2/12,
                                    height:16,
                                    child:Center(child: Text(letscount(sum2),style:TextStyle(fontSize:w/41)))
                                )
                            ),
                            Container(
                                width: w*2/12,
                                child:Container(
                                    width:w*2/12,
                                    height:16,
                                    child:Center(child: Text(letscount(sum3),style:TextStyle(fontSize:w/41)))
                                )
                            ),
                          ],
                        )
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: w*5/8,
                          child:Column(
                            children:[
                              Container(
                                  width: w*5/8,
                                  height: 1.2,color:Colors.blue
                              ),
                              Container(
                                  width: w*5/8,
                                  height: w/25,color:Colors.orangeAccent,
                                  child:Center(child:Text("GENERAL REMARKS",style:TextStyle(fontWeight:FontWeight.w900,fontSize: w/35)))
                              ),
                              Container(
                                  width:w*5/8,
                                  height: 0.3,color:Colors.blue
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: w/23,
                                    width: w*2/8,
                                    decoration: BoxDecoration(
                                      border:Border.all(color:Colors.blue)
                                    ),
                                    child:Center(child: Text("Quaterly",style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/35)))
                                  ),
                                  Container(
                                    height: w/23,
                                    width: w*3/8,
                                    decoration: BoxDecoration(
                                        border:Border.all(color:Colors.blue)
                                    ),
                                      child:Center(child: Text(remarks1.text,style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/38))))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      height: w/23,
                                      width: w*2/8,
                                      decoration: BoxDecoration(
                                          border:Border.all(color:Colors.blue)
                                      ),
                                      child:Center(child: Text("Half  Yearly",style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/35)))
                                  ),
                                  Container(
                                    height: w/23,
                                    width: w*3/8,
                                    decoration: BoxDecoration(
                                        border:Border.all(color:Colors.blue)
                                    ),
                                      child:Center(child: Text(remarks2.text,style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/38))))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      height: w/23,
                                      width: w*2/8,
                                      decoration: BoxDecoration(
                                          border:Border.all(color:Colors.blue)
                                      ),
                                      child:Center(child: Text("Annual",style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/35)))
                                  ),
                                  Container(
                                    height: w/23,
                                    width: w*3/8,
                                    decoration: BoxDecoration(
                                        border:Border.all(color:Colors.blue)
                                    ),
                                      child:Center(child: Text(remarks3.text,style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/38))))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      height: w/16,
                                      width: w*2/8,
                                      decoration: BoxDecoration(
                                          border:Border.all(color:Colors.blue)
                                      ),
                                      child:Center(child: Text("Result",style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/35)))
                                  ),
                                  Container(
                                    height: w/16,
                                    width: w*3/8,
                                    decoration: BoxDecoration(
                                        border:Border.all(color:Colors.blue)
                                    ),
                                      child:Center(child: Text(status.text,style:TextStyle(fontWeight: FontWeight.w700,fontSize: w/38))))

                                ],
                              ),
                            ]
                          )
                        ),
                        Container(width: 4,height: w/22*5.1+2,color:Colors.blue),
                        Container(
                          width: w*3/8,
                            child:Column(
                                children:[
                                  Container(
                                      width: w*3/8,
                                      height: 1.2,color:Colors.blue
                                  ),
                                  Container(
                                      width: w*3/8,
                                      height: w/25,color:Colors.orangeAccent,
                                      child:Center(child:Text("KEY TO GRADE",style:TextStyle(fontWeight:FontWeight.w900,fontSize: w/35)))
                                  ),
                                  Container(
                                      width:w*3/8,
                                      height: 1.2,color:Colors.blue
                                  ),
                                  SizedBox(height:4),
                                  rop(w,"A+", "90-100"),
                                  rop(w,"A", "80-90"),
                                  rop(w,"B", "70-80"),
                                  rop(w,"C", "60-80"),
                                  rop(w,"D", "50-60"),
                                  rop(w,"E", "40-50"),
                                  rop(w,"F", "<40"),
                                  SizedBox(height:4),
                                ]
                            )
                        ),
                      ],
                    ),
                    Container(
                      width: w,height: 2,color: Colors.blue,
                    ),
                    Container(
                        width: w,height:40,
                      child:Column(
                        children:[
                          Row(children:[
                            h2(w,"  Date of Issue : "),
                            h4(w,"${DateFormat('dd/MM/yyyy').format(DateTime.now())}"),
                          ]),
                          Spacer(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:[
                            h2(w,"Class Teacher Signature"),
                            h2(w,"Parents Signature"),
                            Column(
                              children: [
                                Image.network(widget.user.AuthorizeSignature,height: 20,),
                                h2(w,"Principal Signature"),
                              ],
                            )

                          ]),
                        ]
                      )
                    ),
                  ]
              )
              ),
          ),
        persistentFooterButtons: [
          upi?Center(child:CircularProgressIndicator()):InkWell(
            onTap: () async {
              setState((){
                upi=true;
              });
              try{
                Map<String, int> iny= await letssum();
                final ExportOptions overrideOptions = ExportOptions(
                  textFieldOptions: TextFieldOptions.uniform(
                    interactive: false,
                  ),pageFormatOptions: PageFormatOptions.custom(width: w,height: w*1.35,
                    clip: false,marginAll: 0,marginBottom: 0,marginLeft: 0,marginRight: 0,marginTop: 0),
                  checkboxOptions: CheckboxOptions.uniform(
                    interactive: false,
                  ),
                );
                final pdf = await exportDelegate.exportToPdfDocument("someFrameId", overrideOptions: overrideOptions);
                final filePath = await saveFile(pdf, Name.text+ " MarkSheet");
                Send.message(context, "Success ! File saved on Android>Data>com.starwish.student>data>${Name.text}.pdf", true);
                if (filePath != null) {
                  Share.shareXFiles([XFile(filePath)], text: 'Here is your PDF file.');
                }
              }catch(e){
                print(e);
                Send.message(context, "$e", false);
              }finally{
                try {
                  Map<String, int> iny= await letssum();
                  try {
                    final ExportOptions overrideOptions = ExportOptions(
                      textFieldOptions: TextFieldOptions.uniform(
                        interactive: false,
                      ),
                      pageFormatOptions: PageFormatOptions.custom(
                        width: w,
                        height: w * 1.35,
                        clip: false,
                        marginAll: 0,
                        marginBottom: 0,
                        marginLeft: 0,
                        marginRight: 0,
                        marginTop: 0,
                      ),
                      checkboxOptions: CheckboxOptions.uniform(
                        interactive: false,
                      ),
                    );

                    final pdf = await exportDelegate.exportToPdfDocument("someFrameId", overrideOptions: overrideOptions);
                    final pdfBytes = await pdf.save(); // Convert the Document to Uint8List
                    final filePath = await newsaveFiles(pdfBytes, "${Name.text} MarkSheet");
                    Send.message(context, "Success! File also saved at $filePath", true);
                    if (filePath != null) {
                      await Process.run('xdg-open', [filePath]); // Linux
                    }
                  } catch (e) {
                    print(e);
                    Send.message(context, "S$e", false);
                  }
                }catch(e){
                  Send.message(context, "S$e", false);
                }
              }
              Map<String, int> iny= await letssum();
              setState((){
                upi=false;
              });
            },
          child:Padding(
            padding: const EdgeInsets.all(1.0),
            child:Container(
    width: w-10,
    height: 50,
    decoration: BoxDecoration(
    color:Colors.orange,
    borderRadius: BorderRadius.circular(5)
    ),
    child: Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        Icon(Icons.download),
        Text("Download Now",style:TextStyle(fontWeight:FontWeight.w800)),
      ],
    )
    ),
          )),
        ],
      ),
    );
  }
  Map<String, int> letssum(){
    final results = calculateSums(
      sControllers: [
        q1Controller, q2Controller, q3Controller, q4Controller,q5Controller,q6Controller,q7Controller,q8Controller,q9Controller,q10Controller
      ],
      hControllers: [
        h1Controller, h2Controller, h3Controller, h4Controller,h5Controller,h6Controller,h7Controller,h8Controller,h9Controller,h10Controller
      ],
      aControllers: [
        a1Controller, a2Controller, a3Controller, a4Controller,a5Controller,a6Controller,a7Controller,a8Controller,a9Controller,a10Controller
      ],
    );
    return results;
  }


   int parseToInt(TextEditingController controller) {
     return int.tryParse(controller.text) ?? 0;
   }

   Map<String, int> calculateSums({
     required List<TextEditingController> sControllers,
     required List<TextEditingController> hControllers,
     required List<TextEditingController> aControllers,
   }) {
     int sumS = 0, sumH = 0, sumA = 0;

     for (var controller in sControllers) {
       sumS += parseToInt(controller);
     }

     for (var controller in hControllers) {
       sumH += parseToInt(controller);
     }

     for (var controller in aControllers) {
       sumA += parseToInt(controller);
     }
     setState(() {
       print(sum1);
       print(sum2);
       print(sum3);
       sum1=0;sum2=0;sum3=0;
       sum1=sumS;
       sum2=sumH;
       sum3=sumA;
       print(sum1);
       print(sum2);
       print(sum3);
     });
     return {
       'sum1': sumS,
       'sum2': sumH,
       'sum3': sumA,
     };
   }

   Future<String> newsaveFiles(Uint8List pdfBytes, String fileName) async {
     // Get the base external storage directory
     final Directory? baseDir = await getExternalStorageDirectory();

     if (baseDir != null) {
       // Construct the target directory path
       final String customDirPath = "/storage/emulated/0/Student_Next_Light/Marksheet/Class_${classController.text}_${sectionController.text}/";
       final Directory customDir = Directory(customDirPath);
       if (!await customDir.exists()) {
         await customDir.create(recursive: true);
       }

       // Save the file
       final File file = File("$customDirPath/$fileName.pdf");
       await file.writeAsBytes(pdfBytes);
       try {
         final String folderPath = customDir.path;
         const platform = MethodChannel('flutter.native/helper'); // Channel for native actions.
         await platform.invokeMethod('openDirectory', {'path': folderPath});
       } catch (e) {
         print('Error opening directory: $e');
       }
       return file.path;
     }
     throw Exception("Could not get storage directory");
   }
  Widget suiop(TextEditingController c, String s){
    return InkWell(
      onTap:(){
        setState(() {
          if(c==remarks1){
            remarks1.text=s;
          }if(c==remarks2){
            remarks2.text=s;
          }if(c==status){
           status.text=s;
          }if(c==remarks3){
            remarks3.text=s;
          }
        });
      },
      child:Container(
        color:c.text==s?Colors.blue:Colors.black,
        child:Padding(
          padding:EdgeInsets.all(10),
          child:Text(s,style: TextStyle(color: c.text==s?Colors.black:Colors.white),),
        )
      )
    );
  }


   String hjk( String g ) {
     String dateTimeString = g; // Replace with your DateTime string
     print(g);
     // Convert DateTime string to DateTime
     DateTime dateTime = DateTime.parse(dateTimeString);

     // Format the DateTime in the desired format (DD/MM/YYYY)
     String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

     return formattedDate ;
   }
  String letscount(int pl){
     double iou= i*200;
     int s = (pl/iou * 100).toInt();
     return s.toString() + " %";
  }
  bool upi=false;
  Widget rop(double w,String str, String str2){
     return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Container(
             width: 12,height:w/42,
             decoration: BoxDecoration(
                 border:Border.all(
                     color:Colors.blue,width: 0.6
                 ),
             ),
             child:Center(child: Text(str,style:TextStyle(fontSize: w/65,fontWeight: FontWeight.w600)))
         ),
         Container(
             width: w*3/8-35,height:w/42,
             decoration: BoxDecoration(
                 border:Border.all(color:Colors.blue,width: 0.6)
             ),
             child:Center(child: Text(str2,style:TextStyle(fontSize: w/65,fontWeight: FontWeight.w600)))
         ),
       ],
     );
  }
  int sum1=0,sum2=0,sum3=0;
   void updateSum(TextEditingController controller, Function(int) update) {
     if (controller.text.isNotEmpty) {
       int? value = int.tryParse(controller.text);
       if (value != null) {
         update(value);
       }
     }
   }
  Widget con(double w, TextEditingController name, TextEditingController m1, TextEditingController m2,TextEditingController m3){
    updateSum(m1, (value) => sum1 += value);
    updateSum(m2, (value) => sum2 += value);
    updateSum(m3, (value) => sum3 += value);
     return Container(
       height: w/31,
       child: Row(
         children: [
           Container(
             width: w*6/12,
             child: Text("  "+name.text,style:TextStyle(fontWeight: FontWeight.w500,fontSize:w/39)),
           ),
           Container(
             width:w*1/12,
             height:20,
             child:Center(child: Text(m1.text,style:TextStyle(fontWeight: FontWeight.w500,fontSize: w/43))),
           ),
           Container(
             width:w*1/12,
             height:20,
             child:Center(child: Text(sd(m1),style:TextStyle(fontWeight: FontWeight.w500,fontSize: w/42))),
           ),
           Container(
             width:w*1/12,
             height:20,
             child:Center(child: Text(m2.text,style:TextStyle(fontWeight: FontWeight.w500,fontSize: w/43))),
           ),
           Container(
             width:w*1/12,
             height:20,
             child:Center(child: Text(sd(m2),style:TextStyle(fontWeight: FontWeight.w500,fontSize: w/42))),
           ),
           Container(
             width:w*1/12,
             height:20,
             child:Center(child: Text(m3.text,style:TextStyle(fontWeight: FontWeight.w500,fontSize: w/43))),
           ),
           Container(
             width:w*1/12,
             height:20,
             child:Center(child: Text(sd(m3),style:TextStyle(fontWeight: FontWeight.w500,fontSize: w/42))),
           ),
         ],
       ),
     );
  }
  String sd(TextEditingController c){
     try {
       int y = int.parse(c.text);
       if (y > 90) {
         return "A+";
       } else if (y > 80) {
         return "A";
       } else if (y > 70) {
         return "B";
       } else if (y > 60) {
         return "C";
       } else if (y > 50) {
         return "D";
       } else if (y > 40) {
         return "E";
       } else {
         return "F";
       }
     }catch(e){
       return "";
     }
  }
   Widget h4(double w,String s)=> Text(s,style:TextStyle(fontSize: w/52,color:Colors.black,fontWeight: FontWeight.w600));
  Widget col(double w,hi){
     return  Container(
         width: w*2/12,
         decoration: BoxDecoration(
             border: Border.all(
               color:Colors.blue,
               width: 0.4
             )
         ),
         child:Column(
           children: [
             Container(
               width:w*2/12,
               height:15,
               decoration: BoxDecoration(
                   border: Border.all(
                     color:Colors.blue,
                     width: 0.1
                   )
               ),
               child:Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Center(child: Text(textAlign:TextAlign.center,hi==1?"Quarterly":hi==2?"Half Yearly":"Annual",style:TextStyle(fontSize:w/45))),
               )
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children:[
                   Center(child: Text("Marks",style:TextStyle(fontSize:w/56))),
                   Container(
                     height: 14,
                     width: 0.4,
                     color: Colors.blue,
                   ),
                   Center(child: Text("Grades",style:TextStyle(fontSize:w/56))),
                 ]
             ),
           ],
         )
     );
  }
  Widget row1(double d,String s, String s2, String s3, String s4){
    return Row(
      children: [
        Container(
            width: d/2,
            child: Row(
              children: [
                Text(s+ " : ",style:TextStyle(fontSize: d/41,color:Colors.blue,fontWeight: FontWeight.w600)),
                Text(s2,style:TextStyle(fontSize: d/42,color:Colors.black,fontWeight: FontWeight.w500)),
              ],
            )),
        Container(
            width: d/2-90,
            child: Row(
              children: [
                Text(s3+ " : ",style:TextStyle(fontSize: d/41,color:Colors.blue,fontWeight: FontWeight.w600)),
                Text(s4,style:TextStyle(fontSize: d/42,color:Colors.black,fontWeight: FontWeight.w500)),
              ],
            )),
      ],
    );
  }
  Widget h2(double w,String s)=> Text(s,style:TextStyle(fontSize: w/52,color:Colors.blue,fontWeight: FontWeight.w600));
  Widget r(TextEditingController c){
    return Row(
      children: [
        SizedBox(width:10),
        Container(
          width: 20,
          height: 30,
          color:Colors.blue
        ),
        SizedBox(width:10),
        Text(c.text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
      ],
    );
  }

  Widget yu(double w,String str){
    return Column(
      children:[
        Container(
            width: w,
            height: 1.2,color:Colors.blue
        ),
        Container(
            width: w,
            height: w/25,color:Colors.orangeAccent,
            child:Center(child:Text(str,style:TextStyle(fontWeight:FontWeight.w900,fontSize:w/35 )))
        ),
        Container(
            width: w,
            height: 1.2,color:Colors.blue
        ),
      ]
    );
  }
  Widget divi(double w, Widget w1, Widget w2){
    return Row(
      children: [
        Container(
          width: w/2,
          child: w1,
        ),
        Container(
          width: w/2,
          child: w2
        ),
      ],
    );
}
   Widget fori(double w, Widget w1, Widget w2,Widget w3){
     return Row(
       children: [
         Container(
           width: w/3,
           child: w1,
         ),
         Container(
             width: w/3,
             child: w2
         ),
         Container(
             width: w/3,
             child: w3
         ),
       ],
     );
   }
  Widget s(double d)=>SizedBox(height: d,);

   Widget ss(double d)=>SizedBox(width: d,);

  DateTime now = DateTime.now();
   Widget dc(TextEditingController c, String label, String hint, bool number) {
     return Padding(
       padding: const EdgeInsets.all(14.0),
       child: TextFormField(
         controller: c,
         keyboardType: number ? TextInputType.number : TextInputType.text,
         decoration: InputDecoration(
           labelText: label,
           hintText: hint,
           isDense: true,
           border: OutlineInputBorder(),
         ),
         validator: (value) {
           if (value!.isEmpty) {
             return 'Please type It';
           }
           return null;
         },
       ),
     );
   }
   Widget d(TextEditingController c, String label, String hint) {
     return Padding(
       padding: const EdgeInsets.all(14.0),
       child: TextFormField(
         controller: c, maxLength: 3,
         keyboardType:  TextInputType.number,
         decoration: InputDecoration(
           labelText:"",counterText: "",
           hintText: "",
           isDense: true,
           border: OutlineInputBorder(),
         ),
         validator: (value) {
           if (value!.isEmpty) {
             return 'Please type It';
           }
           return null;
         },
       ),
     );
   }
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
