import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/after_login/stu_edit.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:student_managment_app/function/send.dart';

class Timetablee extends StatefulWidget {
  bool teacher;
  Timetablee({super.key,required this.clas,required this.school,required this.id,required this.session,required this.teacher});
  String school,id,session,clas;

  @override
  State<Timetablee> createState() => _TimetableeState();
}

class _TimetableeState extends State<Timetablee> {
  Future<void> dispose() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  List<Timetable> _list = [];
  void initState(){
   setState(() {
     y=0;
   });
  }
  bool portrait=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          InkWell(
            onTap: () async {

              if(portrait){
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              }else{
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              }
              portrait=!portrait;
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: portrait?Icon(Icons.stay_current_landscape_rounded):Icon(Icons.stay_current_portrait_sharp),
            ),
          ),
          SizedBox(width: 10,)
        ],
        title: Text("My Timetable",style:TextStyle(color:Colors.white,fontSize: 23)),
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection('School').doc(widget.school).
        collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
            .collection("Timetable").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.teacher?InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              child:TimetableScreen(clas: widget.clas, school: widget.school, id: widget.id, session: widget.session, teacher: widget.teacher,),
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 50)));
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.add,color: Colors.white,size: 20,),
                    ),
                  ):SizedBox(),
                  Text(
                    "No TimeTable",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                 widget.teacher? Text(
                   "No TimeTable for your Classroom ! Add 1 Now",
                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                 ): Text(
                   "No TimeTable added by Teacher Yet",
                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                 ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => Timetable.fromJson(e.data())).toList() ?? []);
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: JobUh(user: _list.first, clas: widget.clas, school: widget.school, id: widget.id, session: widget.session, teacher: widget.teacher, )
          );
        },
      ),
    );
  }
}

class JobUh extends StatefulWidget {
  Timetable user;
  bool teacher;

  String school,id,session,clas;
  JobUh({super.key,required this.user,required this.clas,required this.school,required this.id,required this.session,required this.teacher});

  @override
  State<JobUh> createState() => _JobUhState();
}
int y=0;
class _JobUhState extends State<JobUh> {


  Color ct(int y){
    if(y%9==0){
      return Colors.yellow.shade100;
    }else if(y%8==0){
      return Colors.blue.shade100;
    }else if(y%7==0&&y%2==0){
      return Colors.brown.shade100;
    }else if(y%7==0){
      return Colors.greenAccent.shade100;
    }else if(y%6==0){
      return Colors.purpleAccent.shade100;
    }else if(y%5==0){
      return Colors.red.shade100 ;
    }else if(y%4==0){
      return Colors.indigo.shade100 ;
    }else if(y%3==0){
      return Colors.blueGrey.shade100 ;
    }else if(y%2==0){
      return Colors.pink.shade100 ;
    }else{
      return Colors.teal.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h-300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,""),  r1(w,"Monday"),  r1(w,"Tuesday"),  r1(w,"Wednesday"),  r1(w,"Thursday"),  r1(w,"Friday"),  r1(w,"Saturday"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"1st"),  r(w,widget.user.m1),   r(w,widget.user.t1), r(w,widget.user.w1), r(w,widget.user.th1), r(w,widget.user.fr1), r(w,widget.user.s1),
            ],
          ),
          widget.user.recess==1?breaks(w):SizedBox(),
          lessthan(2)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"2st"),  r(w,widget.user.m2),   r(w,widget.user.t2), r(w,widget.user.w2), r(w,widget.user.th2), r(w,widget.user.fr2), r(w,widget.user.s2),
            ],
          ):SizedBox(),
          widget.user.recess==2?breaks(w):SizedBox(),
          lessthan(4)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"3st"),  r(w,widget.user.m3),   r(w,widget.user.t3), r(w,widget.user.w3), r(w,widget.user.th3), r(w,widget.user.fr3), r(w,widget.user.s3),
            ],
          ):SizedBox(),
          widget.user.recess==3?breaks(w):SizedBox(),
          lessthan(4)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"4st"),  r(w,widget.user.m4),   r(w,widget.user.t4), r(w,widget.user.w4), r(w,widget.user.th4), r(w,widget.user.fr4), r(w,widget.user.s4),
            ],
          ):SizedBox(),
          widget.user.recess==4?breaks(w):SizedBox(),
          lessthan(5)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"5st"),  r(w,widget.user.m5),   r(w,widget.user.t5), r(w,widget.user.w5), r(w,widget.user.th5), r(w,widget.user.fr5), r(w,widget.user.s5),
            ],
          ):SizedBox(),
          widget.user.recess==5?breaks(w):SizedBox(),
          lessthan(6)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"6st"),  r(w,widget.user.m6),   r(w,widget.user.t6), r(w,widget.user.w6), r(w,widget.user.th6), r(w,widget.user.fr6), r(w,widget.user.s6),
            ],
          ):SizedBox(),
          widget.user.recess==6?breaks(w):SizedBox(),
          lessthan(7)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"7st"),  r(w,widget.user.m7),   r(w,widget.user.t7), r(w,widget.user.w7), r(w,widget.user.th7), r(w,widget.user.fr7), r(w,widget.user.s7),
            ],
          ):SizedBox(),
          widget.user.recess==7?breaks(w):SizedBox(),
          lessthan(8)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"8st"),  r(w,widget.user.m8),   r(w,widget.user.t8), r(w,widget.user.w8), r(w,widget.user.th8), r(w,widget.user.fr8), r(w,widget.user.s8),
            ],
          ):SizedBox(),
          widget.user.recess==8?breaks(w):SizedBox(),
          lessthan(9)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"9st"),  r(w,widget.user.m9),   r(w,widget.user.t9), r(w,widget.user.w9), r(w,widget.user.th9), r(w,widget.user.fr9), r(w,widget.user.s9),
            ],
          ):SizedBox(),
          widget.user.recess==9?breaks(w):SizedBox(),
         lessthan(10)?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              r1(w,"10st"),  r(w,widget.user.m10),   r(w,widget.user.t10), r(w,widget.user.w10), r(w,widget.user.th10), r(w,widget.user.fr10), r(w,widget.user.s10),
            ],
          ):SizedBox(),
        ],
      ),
    );
  }
  bool lessthan(int y){
    return widget.user.noofperiods>=y;
  }
  Widget breaks(double w)=>Container(
      width: w-10,
      height: 10,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: w/6,),
          Text("B",style: TextStyle(color: Colors.white,fontSize: 5),),
          Text("R",style: TextStyle(color: Colors.white,fontSize: 5),),
          Text("E",style: TextStyle(color: Colors.white,fontSize: 5),),
          Text("A",style: TextStyle(color: Colors.white,fontSize: 5),),
          Text("K",style: TextStyle(color: Colors.white,fontSize: 5),),
          SizedBox(width: w/6,),
        ],
      )
  );
  Map<String, dynamic> person = {};
  Widget r(double w,String gh) {
    if(person.containsKey(gh)){

    }else{
      person[gh]= ct(y);
      y=y+1;
    }
    return Container(
      width: w / 7 - 2.5,
      color:gh.isEmpty?Colors.white: person[gh],
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(gh, style: TextStyle(fontSize: 8, color: Colors.black,fontWeight: FontWeight.w800),),
      ),
    );
  }
  Widget r1(double w,String gh) {
    return Container(
      width: w / 7 - 2.5,
      color: Colors.orangeAccent.shade100,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(gh, style: TextStyle(fontSize: 8, color: Colors.black,fontWeight: FontWeight.w800),),
      ),
    );
  }
  Color cts(int ai){
    if(ai%9==0){
      return Colors.yellow.shade100;
    }else if(ai%8==0){
      return Colors.blue.shade100;
    }else if(ai%7==0&&ai%2==0){
      return Colors.brown.shade100;
    }else if(ai%7==0){
      return Colors.greenAccent.shade100;
    }else if(ai%6==0){
      return Colors.purpleAccent.shade100;
    }else if(ai%5==0){
      return Colors.red.shade100 ;
    }else if(ai%4==0){
      return Colors.indigo.shade100 ;
    }else if(ai%3==0){
      return Colors.blueGrey.shade100 ;
    }else if(ai%2==0){
      return Colors.pink.shade100 ;
    }else{
      return Colors.teal.shade100;
    }
  }
}

class TimetableScreen extends StatefulWidget {
  bool teacher;
  TimetableScreen({super.key,required this.clas,required this.school,required this.id,required this.session,required this.teacher});
  String school,id,session,clas;

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  // This function will simulate saving the timetable and print the JSON to console
  final TextEditingController idController = TextEditingController();

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

  final TextEditingController m1Controller = TextEditingController();

  final TextEditingController m2Controller = TextEditingController();

  final TextEditingController m3Controller = TextEditingController();

  final TextEditingController m4Controller = TextEditingController();

  final TextEditingController m5Controller = TextEditingController();

  final TextEditingController m6Controller = TextEditingController();

  final TextEditingController m7Controller = TextEditingController();

  final TextEditingController m8Controller = TextEditingController();

  final TextEditingController m9Controller = TextEditingController();

  final TextEditingController m10Controller = TextEditingController();

  final TextEditingController t1Controller = TextEditingController();

  final TextEditingController t2Controller = TextEditingController();

  final TextEditingController t3Controller = TextEditingController();

  final TextEditingController t4Controller = TextEditingController();

  final TextEditingController t5Controller = TextEditingController();

  final TextEditingController t6Controller = TextEditingController();

  final TextEditingController t7Controller = TextEditingController();

  final TextEditingController t8Controller = TextEditingController();

  final TextEditingController t9Controller = TextEditingController();

  final TextEditingController t10Controller = TextEditingController();

  final TextEditingController w1Controller = TextEditingController();

  final TextEditingController w2Controller = TextEditingController();

  final TextEditingController w3Controller = TextEditingController();

  final TextEditingController w4Controller = TextEditingController();

  final TextEditingController w5Controller = TextEditingController();

  final TextEditingController w6Controller = TextEditingController();

  final TextEditingController w7Controller = TextEditingController();

  final TextEditingController w8Controller = TextEditingController();

  final TextEditingController w9Controller = TextEditingController();

  final TextEditingController w10Controller = TextEditingController();

  final TextEditingController fr1Controller = TextEditingController();

  final TextEditingController fr2Controller = TextEditingController();

  final TextEditingController fr3Controller = TextEditingController();

  final TextEditingController fr4Controller = TextEditingController();

  final TextEditingController fr5Controller = TextEditingController();

  final TextEditingController fr6Controller = TextEditingController();

  final TextEditingController fr7Controller = TextEditingController();

  final TextEditingController fr8Controller = TextEditingController();

  final TextEditingController fr9Controller = TextEditingController();

  final TextEditingController fr10Controller = TextEditingController();

  final TextEditingController th1Controller = TextEditingController();

  final TextEditingController th2Controller = TextEditingController();

  final TextEditingController th3Controller = TextEditingController();

  final TextEditingController th4Controller = TextEditingController();

  final TextEditingController th5Controller = TextEditingController();

  final TextEditingController th6Controller = TextEditingController();

  final TextEditingController th7Controller = TextEditingController();

  final TextEditingController th8Controller = TextEditingController();

  final TextEditingController th9Controller = TextEditingController();

  final TextEditingController th10Controller = TextEditingController();
int _lowerValue=4;
int _upperValue=10;
int mean=2;
TextEditingController note=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            da("No of Period Grids",Colors.blue),
            FlutterSlider(
              values: [_lowerValue.toDouble()],
              max: 10,
              min: 2,
              onDragging: (handlerIndex, lowerValue, upperValue) {
                print(lowerValue);
                print(upperValue);
                print(handlerIndex);
                setState(() {
                  double f=double.parse(lowerValue.toString());
                  _lowerValue = f.toInt();
                });
              },
            ),
            Text("Total Periods : "+_lowerValue.toString(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
            SizedBox(height: 2,),
            Text("Recess At : ",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(3, (index) {  // Always show 3 values
                  int centerValue = (_lowerValue / 2).round();  // Get the center value
                  int startValue = centerValue - 1;
                  bool b=(startValue + index)==mean;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        mean=(startValue + index);
                        setState(() {

                        });
                      },
                      child: Container(
                        color:b?Colors.black: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Text(
                            (startValue + index).toString(),
                            style: TextStyle(fontWeight: FontWeight.w700,color: b?Colors.white:Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            da("Monday",Colors.blue),
            Row(
              children: [
                d(m1Controller, '1',w),
                d(m2Controller, '2',w),
                d(m3Controller, '3',w),
              ],
            ),
            Row(
              children: [
                d(m4Controller, '4',w),
                d(m5Controller, '5',w),
                d(m6Controller, '6',w),
              ],
            ),
            Row(
              children: [
                d(m7Controller, '7',w),
                d(m8Controller, '8',w),
                d(m9Controller, '9',w),
              ],
            ),
            d(m10Controller, '10',w),

            da("Tuesday",Colors.pink),
            Row(
              children: [
                d(t1Controller, '1',w),
                d(t2Controller, '2',w),
                d(t3Controller, '3',w),
              ],
            ),
            Row(
              children: [
                d(t4Controller, '4',w),
                d(t5Controller, '5',w),
                d(t6Controller, '6',w),
              ],
            ),
            Row(
              children: [
                d(t7Controller, '7',w),
                d(t8Controller, '8',w),
                d(t9Controller, '9',w),
              ],
            ),
            d(t10Controller, '10',w),

            da("Wednesday",Colors.purple),
            Row(
              children: [
                d(w1Controller, '1',w),
                d(w2Controller, '2',w),
                d(w3Controller, '3',w),
              ],
            ),
            Row(
              children: [
                d(w4Controller, '4',w),
                d(w5Controller, '5',w),
                d(w6Controller, '6',w),
              ],
            ),
            Row(
              children: [
                d(w7Controller, '7',w),
                d(w8Controller, '8',w),
                d(w9Controller, '9',w),
              ],
            ),
            d(w10Controller, '10',w),

            da("Thursday",Colors.deepPurpleAccent),
            Row(
              children: [
                d(th1Controller, '1',w),
                d(th2Controller, '2',w),
                d(th3Controller, '3',w),
              ],
            ),
            Row(
              children: [
                d(th4Controller, '4',w),
                d(th5Controller, '5',w),
                d(th6Controller, '6',w),
              ],
            ),
            Row(
              children: [
                d(th7Controller, '7',w),
                d(th8Controller, '8',w),
                d(th9Controller, '9',w),
              ],
            ),
            d(th10Controller, '10',w),
            da("Friday",Colors.green),
            Row(
              children: [
                d(fr1Controller, '1',w),
                d(fr2Controller, '2',w),
                d(fr3Controller, '3',w),
              ],
            ),
            Row(
              children: [
                d(fr4Controller, '4',w),
                d(fr5Controller, '5',w),
                d(fr6Controller, '6',w),
              ],
            ),
            Row(
              children: [
                d(fr7Controller, '7',w),
                d(fr8Controller, '8',w),
                d(fr9Controller, '9',w),
              ],
            ),
            d(fr10Controller, '10',w),

            da("Saturday",Colors.red),
            Row(
              children: [
                d(s1Controller, '1',w),
                d(s2Controller, '2',w),
                d(s3Controller, '3',w),
              ],
            ),
           Row(
             children: [
               d(s4Controller, '4',w),
               d(s5Controller, '5',w),
               d(s6Controller, '6',w),
             ],
           ),
            Row(
              children: [
                d(s7Controller, '7',w),
                d(s8Controller, '8',w),
                d(s9Controller, '9',w),
              ],
            ),
            d(s10Controller, '10',w),
            SizedBox(height: 10,),
            da("Additional Notes",Colors.pink),
            Container(
              width: w-10,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: note,
                  keyboardType: TextInputType.text,
                  minLines: 3,maxLines: 20,
                  decoration: InputDecoration(
                    labelText: "Any Additional Note",
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
              ),
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {

            Timetable j=Timetable(id: hy, s1: s1Controller.text, s2: s2Controller.text, s3: s3Controller.text, s4: s4Controller.text,
                s5: s5Controller.text, s6: s6Controller.text, s7: s7Controller.text, s8: s8Controller.text, s9: s9Controller.text, s10: s10Controller.text, m1: m1Controller.text,
                m2: m2Controller.text, m3: m3Controller.text, m4: m4Controller.text, m5: m5Controller.text, m6: m6Controller.text, m7: m7Controller.text, m8: m8Controller.text, m9: m9Controller.text,
                m10: m10Controller.text, t1: t1Controller.text, t2: t2Controller.text, t3: t3Controller.text, t4: t4Controller.text, t5: t5Controller.text, t6: t6Controller.text, t7:
                t7Controller.text, t8: t8Controller.text, t9: t9Controller.text, t10: t10Controller.text, w1: w1Controller.text, w2: w2Controller.text, w3: w3Controller.text, w4: w4Controller.text, w5: w5Controller.text,
                w6: w6Controller.text, w7: w7Controller.text, w8: w8Controller.text, w9: w9Controller.text, w10: w10Controller.text, th1: th1Controller.text, th2: th2Controller.text, th3: th3Controller.text,
                th4: th4Controller.text, th5: th5Controller.text, th6: th6Controller.text, th7: th7Controller.text, th8: th8Controller.text, th9: th9Controller.text, th10: th10Controller.text,
                fr1: fr1Controller.text, fr2: fr2Controller.text, fr3: fr3Controller.text, fr4: fr4Controller.text, fr5: fr5Controller.text, fr6: fr6Controller.text,
                fr7: fr7Controller.text, fr8: fr8Controller.text, fr9: fr9Controller.text, fr10: fr10Controller.text, noofperiods: _lowerValue, recess: mean, Note: note.text);
           try{
             await FirebaseFirestore.instance.collection('School').doc(widget.school).
             collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
                 .collection("Timetable").doc(hy).set(j.toJson());
             Navigator.pop(context);
             Send.message(context, "Sucess ! Updating......", true);
           }catch(e){
             Send.message(context, "$e", false);
           }

          },
          child: Container(
            height:45,width:w-15,
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
            child: Center(child: Text("Update TimeTable",style: TextStyle(
                color: Colors.white,
                fontFamily: "RobotoS",fontWeight: FontWeight.w800
            ),)),
          ),
        ),
      ],
    );
  }
  final String hy=DateTime.now().millisecondsSinceEpoch.toString();
  Widget d(TextEditingController c, String label,double w) {
    return Container(
      width: w/3,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
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
      ),
    );
  }

  Widget da(String h,Color  color){
    return Row(
      children: [
        SizedBox(width: 10,),
        Container(
          width: 30,
          height: 20,
          color: color,
        ),
        SizedBox(width: 5,),
        Text(h,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
      ],
    );
  }
}

class Timetable {
  final String id;
  final String s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;
  final String m1, m2, m3, m4, m5, m6, m7, m8, m9, m10;
  final String t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
  final String w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
  final String th1, th2, th3, th4, th5, th6, th7, th8, th9, th10;
  final String fr1, fr2, fr3, fr4, fr5, fr6, fr7, fr8, fr9, fr10;
  final String Note;
  final int recess ;
  final int noofperiods;
  // Constructor
  Timetable({
    required this.id,
    required this.s1,
    required this.s2,
    required this.s3,
    required this.s4,
    required this.s5,
    required this.s6,
    required this.s7,
    required this.s8,
    required this.s9,
    required this.s10,
    required this.m1,
    required this.m2,
    required this.m3,
    required this.m4,
    required this.m5,
    required this.m6,
    required this.m7,
    required this.m8,
    required this.m9,
    required this.m10,
    required this.t1,
    required this.t2,
    required this.t3,
    required this.t4,
    required this.t5,
    required this.t6,
    required this.t7,
    required this.t8,
    required this.t9,
    required this.t10,
    required this.w1,
    required this.w2,
    required this.w3,
    required this.w4,
    required this.w5,
    required this.w6,
    required this.w7,
    required this.w8,
    required this.w9,
    required this.w10,
    required this.th1,
    required this.th2,
    required this.th3,
    required this.th4,
    required this.th5,
    required this.th6,
    required this.th7,
    required this.th8,
    required this.th9,
    required this.th10,
    required this.fr1,
    required this.fr2,
    required this.fr3,
    required this.fr4,
    required this.fr5,
    required this.fr6,
    required this.fr7,
    required this.fr8,
    required this.fr9,
    required this.fr10,
    required this.noofperiods,
  required this.Note,
  required this.recess
  });

  // Convert Timetable to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,'noofperiods':noofperiods,'Note':Note,'recess':recess,
      's1': s1, 's2': s2, 's3': s3, 's4': s4, 's5': s5, 's6': s6, 's7': s7, 's8': s8, 's9': s9, 's10': s10,
      'm1': m1, 'm2': m2, 'm3': m3, 'm4': m4, 'm5': m5, 'm6': m6, 'm7': m7, 'm8': m8, 'm9': m9, 'm10': m10,
      't1': t1, 't2': t2, 't3': t3, 't4': t4, 't5': t5, 't6': t6, 't7': t7, 't8': t8, 't9': t9, 't10': t10,
      'w1': w1, 'w2': w2, 'w3': w3, 'w4': w4, 'w5': w5, 'w6': w6, 'w7': w7, 'w8': w8, 'w9': w9, 'w10': w10,
      'th1': th1, 'th2': th2, 'th3': th3, 'th4': th4, 'th5': th5, 'th6': th6, 'th7': th7, 'th8': th8, 'th9': th9, 'th10': th10,
      'fr1': fr1, 'fr2': fr2, 'fr3': fr3, 'fr4': fr4, 'fr5': fr5, 'fr6': fr6, 'fr7': fr7, 'fr8': fr8, 'fr9': fr9, 'fr10': fr10,
    };
  }

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'] ?? '',recess:json['recess']??4,Note:json['Note']??"",noofperiods:json['noofperiods']??7,
      s1: json['s1'] ?? '', s2: json['s2'] ?? '', s3: json['s3'] ?? '', s4: json['s4'] ?? '', s5: json['s5'] ?? '',
      s6: json['s6'] ?? '', s7: json['s7'] ?? '', s8: json['s8'] ?? '', s9: json['s9'] ?? '', s10: json['s10'] ?? '',
      m1: json['m1'] ?? '', m2: json['m2'] ?? '', m3: json['m3'] ?? '', m4: json['m4'] ?? '', m5: json['m5'] ?? '',
      m6: json['m6'] ?? '', m7: json['m7'] ?? '', m8: json['m8'] ?? '', m9: json['m9'] ?? '', m10: json['m10'] ?? '',
      t1: json['t1'] ?? '', t2: json['t2'] ?? '', t3: json['t3'] ?? '', t4: json['t4'] ?? '', t5: json['t5'] ?? '',
      t6: json['t6'] ?? '', t7: json['t7'] ?? '', t8: json['t8'] ?? '', t9: json['t9'] ?? '', t10: json['t10'] ?? '',
      w1: json['w1'] ?? '', w2: json['w2'] ?? '', w3: json['w3'] ?? '', w4: json['w4'] ?? '', w5: json['w5'] ?? '',
      w6: json['w6'] ?? '', w7: json['w7'] ?? '', w8: json['w8'] ?? '', w9: json['w9'] ?? '', w10: json['w10'] ?? '',
      th1: json['th1'] ?? '', th2: json['th2'] ?? '', th3: json['th3'] ?? '', th4: json['th4'] ?? '', th5: json['th5'] ?? '',
      th6: json['th6'] ?? '', th7: json['th7'] ?? '', th8: json['th8'] ?? '', th9: json['th9'] ?? '', th10: json['th10'] ?? '',
      fr1: json['fr1'] ?? '', fr2: json['fr2'] ?? '', fr3: json['fr3'] ?? '', fr4: json['fr4'] ?? '', fr5: json['fr5'] ?? '',
      fr6: json['fr6'] ?? '', fr7: json['fr7'] ?? '', fr8: json['fr8'] ?? '', fr9: json['fr9'] ?? '', fr10: json['fr10'] ?? '',
    );
  }

}