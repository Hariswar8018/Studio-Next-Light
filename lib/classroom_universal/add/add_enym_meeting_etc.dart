import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:student_managment_app/classroom_universal/notice.dart';
import 'package:student_managment_app/function/send.dart';

class Notice1Form extends StatefulWidget {
  String school,session,clas;
  type_class type ;

  Notice1Form({super.key,required this.type,required this.clas,required this.school,required this.session});

  @override
  State<Notice1Form> createState() => _Notice1FormState();
}

class _Notice1FormState extends State<Notice1Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _date2Controller = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _linkController = TextEditingController();

  final TextEditingController _picController = TextEditingController();

  final TextEditingController _nametController = TextEditingController(text: "");

  final TextEditingController _attachmentController = TextEditingController();

  bool _coTeach = false;

  bool _classteacher = false;

  List<dynamic> _follo = [];

  String fd(String g){
    String s1=g.substring(0,1).toUpperCase();
    String s2=g.substring(1);
    return s1+s2;
  }

  @override
  Widget build(BuildContext context)
  {   double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Color(0xff029A81),
        title: Text("Add ${fd(widget.type.name.toString())}",style:TextStyle(color:Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nametController,
                decoration: const InputDecoration(labelText: 'NameT'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Topic Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              (widget.type==type_class.homework||widget.type==type_class.assignment||widget.type==type_class.notice)?InkWell(
                onTap: () async {
                  DateTime? dateTime = await showOmniDateTimePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                    DateTime(1600).subtract(const Duration(days: 3652)),
                    lastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    is24HourMode: false,
                    isShowSeconds: false,
                    minutesInterval: 1,
                    secondsInterval: 1,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 650,
                    ),
                    transitionBuilder: (context, anim1, anim2, child) {
                      return FadeTransition(
                        opacity: anim1.drive(
                          Tween(
                            begin: 0,
                            end: 1,
                          ),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    selectableDayPredicate: (dateTime) {
                      // Disable 25th Feb 2023
                      if (dateTime == DateTime(2023, 2, 25)) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                  );
                  setState(() {
                    _dateController.text=dateTime.toString();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          Icon(Icons.calendar_month),
                          Text("Date of Submission",style:TextStyle(fontWeight:FontWeight.w800)),
                        ],
                      )
                  ),
                ),
              ):InkWell(
                onTap: () async {
                  List<DateTime>? dateTimeList =
                  await showOmniDateTimeRangePicker(
                    context: context,
                    startInitialDate: DateTime.now(),
                    startFirstDate:
                    DateTime(1600).subtract(const Duration(days: 3652)),
                    startLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    endInitialDate: DateTime.now(),
                    endFirstDate:
                    DateTime(1600).subtract(const Duration(days: 3652)),
                    endLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    is24HourMode: false,
                    isShowSeconds: false,
                    minutesInterval: 1,
                    secondsInterval: 1,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 650,
                    ),
                    transitionBuilder: (context, anim1, anim2, child) {
                      return FadeTransition(
                        opacity: anim1.drive(
                          Tween(
                            begin: 0,
                            end: 1,
                          ),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    selectableDayPredicate: (dateTime) {
                      // Disable 25th Feb 2023
                      if (dateTime == DateTime(2023, 2, 25)) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                  );
                  setState(() {
                    if(dateTimeList!=null){
                      _dateController.text=dateTimeList[0].toString();
                      _date2Controller.text=dateTimeList[1].toString();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          Icon(Icons.calendar_month),
                          Text("Date of Submission",style:TextStyle(fontWeight:FontWeight.w800)),
                        ],
                      )
                  ),
                ),
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date of Submission',enabled: false),
              ),
              (widget.type==type_class.homework||widget.type==type_class.assignment||widget.type==type_class.notice)?SizedBox():TextFormField(
                controller: _date2Controller,
                decoration: const InputDecoration(labelText: 'Date 2',enabled: false),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(labelText: 'Link ( Optional )'),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Urgent / Important'),
                value: _coTeach,
                onChanged: (value) {
                  setState((){
                    _coTeach = value;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            if(_dateController.text.isEmpty){
              Send.message(context, "Deadline date is Required !", false);
              return ;
            }
            if(_nameController.text.isEmpty){
              Send.message(context, "Name Required !", false);
              return ;
            }
            if(_nametController.text.isEmpty){
              Send.message(context, "Topic Required !", false);
              return ;
            }
            try {
              Notice1 notice = Notice1(
                id: id,
                date: _dateController.text,
                date2: _date2Controller.text,
                name: _nameController.text,
                description: _descriptionController.text,
                link: _linkController.text,
                pic: _picController.text,
                namet: _nametController.text,
                coTeach: _coTeach,
                classteacher: _classteacher,
                follo: _follo,
                type:fd(widget.type.name.toString()),
                attachment: _attachmentController.text,
              );
              final jsonData = notice.toJson();
              print('Saved Notice1: $jsonData');
              await FirebaseFirestore.instance.collection('School').doc(widget.school)
                  .collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
                  .collection(fd(widget.type.name.toString())).doc(id)
                  .set(notice.toJson());
              Navigator.pop(context);
              Send.message(context, "Success", true);
            }catch(e){
              Send.message(context, "$e", false);
            }
          },
          child: Padding(
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
                    Icon(Icons.add),
                    Text("Add Now",style:TextStyle(fontWeight:FontWeight.w800)),
                  ],
                )
            ),
          ),
        )
      ],
    );
  }

  final String id=DateTime.now().toString();
}