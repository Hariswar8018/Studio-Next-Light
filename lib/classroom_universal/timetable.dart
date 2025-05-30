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
  bool small=true;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          InkWell(
            onTap: () async {
              setState(() {
                small=!small;
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: small?Icon(Icons.zoom_out_map):Icon(Icons.zoom_in_map),
            ),
          ),
          SizedBox(width: 5,),
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
              child: JobUh(small:small,user: _list.last, clas: widget.clas, school: widget.school, id: widget.id, session: widget.session, teacher: widget.teacher, )
          );
        },
      ),
      floatingActionButton: widget.teacher?InkWell(
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
    );
  }
}

class JobUh extends StatefulWidget {
  Timetable user;
  bool teacher;

  bool small;
  String school,id,session,clas;
  JobUh({super.key,required this.small,required this.user,required this.clas,required this.school,required this.id,required this.session,required this.teacher});

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
      height: h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"","",""),  r1(w,"Monday","",""),  r1(w,"Tuesday","",""),  r1(w,"Wednesday","",""),  r1(w,"Thursday","",""),  r1(w,"Friday","",""),  r1(w,"Saturday","",""),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"1st",widget.user.timing1,widget.user.sat1),  r(w,widget.user.m1),   r(w,widget.user.t1), r(w,widget.user.w1), r(w,widget.user.th1), r(w,widget.user.fr1), r(w,widget.user.s1),
              ],
            ),
            widget.user.recesses.contains(1)?breaks(w):SizedBox(),
            lessthan(2)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"2st",widget.user.timing2,widget.user.sat2),  r(w,widget.user.m2),   r(w,widget.user.t2), r(w,widget.user.w2), r(w,widget.user.th2), r(w,widget.user.fr2), r(w,widget.user.s2),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(2)?breaks(w):SizedBox(),
            lessthan(4)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"3st",widget.user.timing3,widget.user.sat3),  r(w,widget.user.m3),   r(w,widget.user.t3), r(w,widget.user.w3), r(w,widget.user.th3), r(w,widget.user.fr3), r(w,widget.user.s3),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(3)?breaks(w):SizedBox(),
            lessthan(4)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"4st",widget.user.timing4,widget.user.sat4),  r(w,widget.user.m4),   r(w,widget.user.t4), r(w,widget.user.w4), r(w,widget.user.th4), r(w,widget.user.fr4), r(w,widget.user.s4),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(4)?breaks(w):SizedBox(),
            lessthan(5)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"5st",widget.user.timing5,widget.user.sat5),  r(w,widget.user.m5),   r(w,widget.user.t5), r(w,widget.user.w5), r(w,widget.user.th5), r(w,widget.user.fr5), r(w,widget.user.s5),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(5)?breaks(w):SizedBox(),
            lessthan(6)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"6st",widget.user.timing6,widget.user.sat6),  r(w,widget.user.m6),   r(w,widget.user.t6), r(w,widget.user.w6), r(w,widget.user.th6), r(w,widget.user.fr6), r(w,widget.user.s6),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(6)?breaks(w):SizedBox(),
            lessthan(7)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"7st",widget.user.timing7,widget.user.sat7),  r(w,widget.user.m7),   r(w,widget.user.t7), r(w,widget.user.w7), r(w,widget.user.th7), r(w,widget.user.fr7), r(w,widget.user.s7),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(7)?breaks(w):SizedBox(),
            lessthan(8)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"8st",widget.user.timing8,widget.user.sat8),  r(w,widget.user.m8),   r(w,widget.user.t8), r(w,widget.user.w8), r(w,widget.user.th8), r(w,widget.user.fr8), r(w,widget.user.s8),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(8)?breaks(w):SizedBox(),
            lessthan(9)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"9st",widget.user.timing9,widget.user.sat9),  r(w,widget.user.m9),   r(w,widget.user.t9), r(w,widget.user.w9), r(w,widget.user.th9), r(w,widget.user.fr9), r(w,widget.user.s9),
              ],
            ):SizedBox(),
            widget.user.recesses.contains(9)?breaks(w):SizedBox(),
           lessthan(10)?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"10st",widget.user.timing10,widget.user.sat10),  r(w,widget.user.m10),   r(w,widget.user.t10), r(w,widget.user.w10), r(w,widget.user.th10), r(w,widget.user.fr10), r(w,widget.user.s10),
              ],
            ):SizedBox(),
            SizedBox(height: 8,),
            Text("Some Notes",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
            Text(widget.user.Note,textAlign: TextAlign.start)
          ],
        ),
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
      height: w/16,
      color:gh.isEmpty?Colors.white: person[gh],
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(child: Text(gh, style: TextStyle(fontSize: 8, color: Colors.black,fontWeight: FontWeight.w800),)),
      ),
    );
  }
  Widget r1(double w,String gh,String str1,String str2) {
    return Container(
      width: w / 7 - 2.5,
      height: w/16,
      color: Colors.orangeAccent.shade100,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(gh, style: TextStyle(fontSize: 8, color: Colors.black,fontWeight: FontWeight.w800),),
            widget.small?SizedBox():Text(str1, style: TextStyle(fontSize: 6, color: Colors.black,fontWeight: FontWeight.w400),),
            widget.small?SizedBox():Text(str2.isEmpty?"":("Sat ("+(str2)+")"), style: TextStyle(fontSize: 6, color: Colors.black,fontWeight: FontWeight.w400),),
          ],
        ),
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

  final TextEditingController timing1 = TextEditingController();
  final TextEditingController timing2 = TextEditingController();
  final TextEditingController timing3 = TextEditingController();
  final TextEditingController timing4 = TextEditingController();
  final TextEditingController timing5 = TextEditingController();
  final TextEditingController timing6 = TextEditingController();
  final TextEditingController timing7 = TextEditingController();
  final TextEditingController timing8 = TextEditingController();
  final TextEditingController timing9 = TextEditingController();
  final TextEditingController timing10 = TextEditingController();

  final TextEditingController class1 = TextEditingController();
  final TextEditingController class2 = TextEditingController();
  final TextEditingController class3 = TextEditingController();
  final TextEditingController class4 = TextEditingController();
  final TextEditingController class5 = TextEditingController();
  final TextEditingController class6 = TextEditingController();

  final TextEditingController satt1 = TextEditingController();
  final TextEditingController satt2 = TextEditingController();
  final TextEditingController satt3 = TextEditingController();
  final TextEditingController satt4 = TextEditingController();
  final TextEditingController satt5 = TextEditingController();
  final TextEditingController satt6 = TextEditingController();
  final TextEditingController satt7 = TextEditingController();
  final TextEditingController satt8 = TextEditingController();
  final TextEditingController satt9 = TextEditingController();
  final TextEditingController satt10 = TextEditingController();



  int _lowerValue=4;
int _upperValue=10;
List<int> mean=[2];
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
                ...List.generate(7, (index) {
                  int startValue = 2 ;
                  bool b=mean.contains((startValue + index));
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        int thison=(startValue + index);
                        if(mean.contains((startValue + index))){
                          mean.remove(thison);
                        }else{
                          mean=mean+[thison];
                        }
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
            da("Additional Notes ( Subject Teachers, Class Teachers, etc )",Colors.pink),
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
            ),
            SizedBox(height: 20,),
            da("Timing ( Optional )",Colors.pink),
            Row(
              children: [
                dx(timing1, '1st',w),
                dx(timing2, '2nd',w),
                dx(timing3, '3rd',w),
              ],
            ),
            Row(
              children: [
                dx(timing4, '4th',w),
                dx(timing5, '5th',w),
                dx(timing6, '6th',w),
              ],
            ),
            Row(
              children: [
                dx(timing7, '7th',w),
                dx(timing8, '8th',w),
                dx(timing9, '9th',w),
              ],
            ),
            dx(timing10, '10th',w),
            SizedBox(height: 20,),
            da("Saturday Timing",Colors.pink),
            Row(
              children: [
                dx(satt1, '1sattt',w),
                dx(satt2, '2nd',w),
                dx(satt3, '3rd',w),
              ],
            ),
            Row(
              children: [
                dx(satt4, '4th',w),
                dx(satt5, '5th',w),
                dx(satt6, '6th',w),
              ],
            ),
            Row(
              children: [
                dx(satt7, '7th',w),
                dx(satt8, '8th',w),
                dx(satt9, '9th',w),
              ],
            ),
            dx(satt10, '10th',w),
            SizedBox(height: 14,),
            da("Class Teacher",Colors.pink),
            Row(
              children: [
                dx(class1, 'Monday',w),
                dx(class2, 'Tuesday',w),
                dx(class3, 'Wednesday',w),
              ],
            ),
            Row(
              children: [
                dx(class4, 'Thursday',w),
                dx(class5, 'Friday',w),
                dx(class6, 'Saturday',w),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            Timetable j=Timetable(id: "Timetable", s1: s1Controller.text, s2: s2Controller.text, s3: s3Controller.text, s4: s4Controller.text,
                s5: s5Controller.text, s6: s6Controller.text, s7: s7Controller.text, s8: s8Controller.text, s9: s9Controller.text, s10: s10Controller.text, m1: m1Controller.text,
                m2: m2Controller.text, m3: m3Controller.text, m4: m4Controller.text, m5: m5Controller.text, m6: m6Controller.text, m7: m7Controller.text, m8: m8Controller.text, m9: m9Controller.text,
                m10: m10Controller.text, t1: t1Controller.text, t2: t2Controller.text, t3: t3Controller.text, t4: t4Controller.text, t5: t5Controller.text, t6: t6Controller.text, t7: t7Controller.text, t8: t8Controller.text, t9: t9Controller.text, t10: t10Controller.text, w1: w1Controller.text, w2: w2Controller.text, w3: w3Controller.text, w4: w4Controller.text, w5: w5Controller.text,
                w6: w6Controller.text, w7: w7Controller.text, w8: w8Controller.text, w9: w9Controller.text, w10: w10Controller.text, th1: th1Controller.text, th2: th2Controller.text, th3: th3Controller.text,
                th4: th4Controller.text, th5: th5Controller.text, th6: th6Controller.text, th7: th7Controller.text, th8: th8Controller.text, th9: th9Controller.text, th10: th10Controller.text,
                fr1: fr1Controller.text, fr2: fr2Controller.text, fr3: fr3Controller.text, fr4: fr4Controller.text, fr5: fr5Controller.text, fr6: fr6Controller.text,
                fr7: fr7Controller.text, fr8: fr8Controller.text, fr9: fr9Controller.text, fr10: fr10Controller.text, noofperiods: _lowerValue, recess: 2, Note: note.text,
                timing1: timing1.text, timing2: timing2.text, timing3: timing3.text, timing4: timing4.text, timing5: timing5.text, timing6: timing6.text, timing7: timing7.text, timing8: timing8.text, timing9: timing9.text, timing10: timing10.text,
                sat1: satt1.text, sat2: satt2.text, sat3: satt3.text, sat4: satt4.text, sat5: satt5.text, sat6: satt6.text, sat7: satt7.text, sat8: satt8.text, sat9: satt9.text, sat10: satt10.text,
                classteacher1: class1.text, classteacher2: class2.text, classteacher3: class3.text, classteacher4: class4.text, classteacher5: class5.text, classteacher6: class6.text, recesses:mean,
            );
           try{
             await FirebaseFirestore.instance.collection('School').doc(widget.school).
             collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
                 .collection("Timetable").doc("Timetable").set(j.toJson());
             Navigator.pop(context);
             Send.message(context, "Sucess ! Updating......", true);
           }catch(e){

             try{
               await FirebaseFirestore.instance.collection('School').doc(widget.school).
               collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
                   .collection("Timetable").doc("Timetable").update(j.toJson());
               Navigator.pop(context);
               Send.message(context, "Sucess ! Updating......", true);
             }catch(e){
               Send.message(context, "$e", false);
             }

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
  Widget dx(TextEditingController c, String label,double w) {
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
  final List recesses;
  final String s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;
  final String m1, m2, m3, m4, m5, m6, m7, m8, m9, m10;
  final String t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
  final String w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
  final String th1, th2, th3, th4, th5, th6, th7, th8, th9, th10;
  final String fr1, fr2, fr3, fr4, fr5, fr6, fr7, fr8, fr9, fr10;
  final String sat1, sat2, sat3, sat4, sat5, sat6, sat7, sat8, sat9, sat10;

  // Timings
  final String timing1, timing2, timing3, timing4, timing5,
      timing6, timing7, timing8, timing9, timing10;

  // Class teachers
  final String classteacher1, classteacher2, classteacher3,
      classteacher4, classteacher5, classteacher6;

  final String Note;
  final int recess;
  final int noofperiods;

  // Constructor
  Timetable({
    required this.id,
    required this.recesses,
    required this.s1, required this.s2, required this.s3, required this.s4, required this.s5,
    required this.s6, required this.s7, required this.s8, required this.s9, required this.s10,
    required this.m1, required this.m2, required this.m3, required this.m4, required this.m5,
    required this.m6, required this.m7, required this.m8, required this.m9, required this.m10,
    required this.t1, required this.t2, required this.t3, required this.t4, required this.t5,
    required this.t6, required this.t7, required this.t8, required this.t9, required this.t10,
    required this.w1, required this.w2, required this.w3, required this.w4, required this.w5,
    required this.w6, required this.w7, required this.w8, required this.w9, required this.w10,
    required this.th1, required this.th2, required this.th3, required this.th4, required this.th5,
    required this.th6, required this.th7, required this.th8, required this.th9, required this.th10,
    required this.fr1, required this.fr2, required this.fr3, required this.fr4, required this.fr5,
    required this.fr6, required this.fr7, required this.fr8, required this.fr9, required this.fr10,
    required this.sat1, required this.sat2, required this.sat3, required this.sat4, required this.sat5,
    required this.sat6, required this.sat7, required this.sat8, required this.sat9, required this.sat10,
    // Timings
    required this.timing1, required this.timing2, required this.timing3, required this.timing4,
    required this.timing5, required this.timing6, required this.timing7, required this.timing8,
    required this.timing9, required this.timing10,
    // Class teachers
    required this.classteacher1, required this.classteacher2, required this.classteacher3,
    required this.classteacher4, required this.classteacher5, required this.classteacher6,
    // Other fields
    required this.noofperiods,
    required this.Note,
    required this.recess
  });

  // Convert Timetable to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, 'noofperiods': noofperiods, 'Note': Note, 'recess': recess,'recesses':recesses,
      // Subjects
      's1': s1, 's2': s2, 's3': s3, 's4': s4, 's5': s5, 's6': s6, 's7': s7, 's8': s8, 's9': s9, 's10': s10,
      'm1': m1, 'm2': m2, 'm3': m3, 'm4': m4, 'm5': m5, 'm6': m6, 'm7': m7, 'm8': m8, 'm9': m9, 'm10': m10,
      't1': t1, 't2': t2, 't3': t3, 't4': t4, 't5': t5, 't6': t6, 't7': t7, 't8': t8, 't9': t9, 't10': t10,
      'w1': w1, 'w2': w2, 'w3': w3, 'w4': w4, 'w5': w5, 'w6': w6, 'w7': w7, 'w8': w8, 'w9': w9, 'w10': w10,
      'th1': th1, 'th2': th2, 'th3': th3, 'th4': th4, 'th5': th5, 'th6': th6, 'th7': th7, 'th8': th8, 'th9': th9, 'th10': th10,
      'fr1': fr1, 'fr2': fr2, 'fr3': fr3, 'fr4': fr4, 'fr5': fr5, 'fr6': fr6, 'fr7': fr7, 'fr8': fr8, 'fr9': fr9, 'fr10': fr10,
      'sat1': sat1, 'sat2': sat2, 'sat3': sat3, 'sat4': sat4, 'sat5': sat5,
      'sat6': sat6, 'sat7': sat7, 'sat8': sat8, 'sat9': sat9, 'sat10': sat10,
      // Timings
      'timing1': timing1, 'timing2': timing2, 'timing3': timing3, 'timing4': timing4, 'timing5': timing5,
      'timing6': timing6, 'timing7': timing7, 'timing8': timing8, 'timing9': timing9, 'timing10': timing10,
      // Class teachers
      'classteacher1': classteacher1, 'classteacher2': classteacher2, 'classteacher3': classteacher3,
      'classteacher4': classteacher4, 'classteacher5': classteacher5, 'classteacher6': classteacher6,
    };
  }

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'] ?? '',
      recess: json['recess'] ?? 4,
      Note: json['Note'] ?? "",
      noofperiods: json['noofperiods'] ?? 7,
      recesses:json['recesses']??[],
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
      sat1: json['sat1'] ?? '', sat2: json['sat2'] ?? '', sat3: json['sat3'] ?? '', sat4: json['sat4'] ?? '', sat5: json['sat5'] ?? '',
      sat6: json['sat6'] ?? '', sat7: json['sat7'] ?? '', sat8: json['sat8'] ?? '', sat9: json['sat9'] ?? '', sat10: json['sat10'] ?? '',
      // Timings
      timing1: json['timing1'] ?? '', timing2: json['timing2'] ?? '', timing3: json['timing3'] ?? '', timing4: json['timing4'] ?? '',
      timing5: json['timing5'] ?? '', timing6: json['timing6'] ?? '', timing7: json['timing7'] ?? '', timing8: json['timing8'] ?? '',
      timing9: json['timing9'] ?? '', timing10: json['timing10'] ?? '',
      // Class teachers
      classteacher1: json['classteacher1'] ?? '', classteacher2: json['classteacher2'] ?? '',
      classteacher3: json['classteacher3'] ?? '', classteacher4: json['classteacher4'] ?? '',
      classteacher5: json['classteacher5'] ?? '', classteacher6: json['classteacher6'] ?? '',
    );
  }
}