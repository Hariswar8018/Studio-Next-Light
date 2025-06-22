import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';

class DutyForm extends StatefulWidget {
  String id;bool teacher;
   DutyForm({super.key,required this.id,required this.teacher});

  @override
  State<DutyForm> createState() => _DutyFormState();
}

class _DutyFormState extends State<DutyForm> {
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
        stream:FirebaseFirestore.instance.collection('School').doc(widget.id).collection("Timetable").snapshots(),
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
                              child:TimetableForm(id: widget.id),
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
              child: JobUh(small:small,user: _list.last, teacher: widget.teacher, )
          );
        },
      ),
      floatingActionButton: widget.teacher?InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child:TimetableForm(id: widget.id),
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
  JobUh({super.key,required this.small,required this.user,required this.teacher});

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
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                r1(w,"1st",widget.user.a1,widget.user.sat1),  r(w,widget.user.m1),   r(w,widget.user.t1), r(w,widget.user.w1), r(w,widget.user.th1), r(w,widget.user.fr1), r(w,widget.user.s1),
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
            */
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


class TimetableForm extends StatefulWidget {
  String id;
  TimetableForm({required this.id});
  @override
  _TimetableFormState createState() => _TimetableFormState();
}

class _TimetableFormState extends State<TimetableForm> {
  final _formKey = GlobalKey<FormState>();

  // Variables
  String id = '';
  List<String> recesses = [];
  DateTime lastupdate = DateTime.now();
  String Note = '';

  Map<String, String> fields = {
    for (var field in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'])
      for (var i = 1; i <= 12; i++) '$field$i': ''
  };

  // Save as JSON
  void saveToJson() {

  }


  // Build TextFormField
  Widget buildTextFormField(String label, String key) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      initialValue: fields[key],
      onSaved: (value) {
        fields[key] = value ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  bool show=false;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Form'),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            InkWell(
              onTap: (){
                try {
                  _formKey.currentState!.save();

                  final data = {
                    'id': id.isEmpty ? 'default_id' : id, // Default value for id
                    'recesses': recesses.isEmpty ? ['default_recess'] : recesses, // Default value for recesses
                    'lastupdate': lastupdate.toIso8601String(),
                    'Note': Note.isEmpty ? 'No notes provided' : Note, // Default value for Note
                    ...fields.map((key, value) => MapEntry(key, value.isEmpty ? 'default' : value)), // Default value for fields
                  };

                  final timetable = Timetable.fromJson(data);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimetableGrid(
                        timetable: timetable,
                      ),
                    ),
                  );

                  print("Saved JSON: ${data.toString()}");
                } catch (e) {
                  Send.message(context, "$e", false);
                }
              },
              child: Center(
                child: Container(
                  width: w-20,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text("Check Form",style: TextStyle(fontSize: 18),)),
                ),
              ),
            ),SizedBox(height: 5,),
            Center(
              child: Container(
                width: w-20,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Save / Update",style: TextStyle(fontSize: 18),)),
              ),
            ),
          ],
        ),
      ],
      body: show?Container():Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '   Notes ',
                  border: OutlineInputBorder(),
                ),minLines: 3,maxLines: 4,
                onSaved: (value) {
                  Note = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Note';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Dynamically Generated TextFormFields
              ...fields.keys.map((key) {
                if(send(key)){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: buildTextFormField(key, key),
                  );
                }else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2,),
                      ListTile(
                        leading: Icon(Icons.accessibility_sharp,color: Colors.blue,),tileColor:Colors.grey.shade200,
                        title:  Text(key.substring(0,1).compareTo("B").toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),),
                        trailing: Icon(Icons.arrow_drop_down_outlined,color: Colors.red,),
                      ),SizedBox(height: 9,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: buildTextFormField(key, key),
                      ),
                    ],
                  );
                }

              }).toList(),

              // Save Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveToJson,
                child: Text('Save as JSON'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String s="";
  bool send(String s1){
    String s2=s1.substring(0,1);
    if(s2==s){
      return true;
    }else{
      s=s2;
      return false;
    }
  }
}


class Timetable {
  final String id;
  final List recesses;
  final DateTime lastupdate;
  final String Note;
  late final Map<String, String> fields;
  final int noofperiods;
  // Fields a1 to m12
  final String a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12;
  final String b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12;
  final String c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12;
  final String d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12;
  final String e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12;
  final String f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12;
  final String g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12;
  final String h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12;
  final String i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12;
  final String j1, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12;
  final String k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12;
  final String l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12;
  final String m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12;

  // Constructor
  Timetable({
    required this.id,
    required this.noofperiods,
    required this.recesses,
    required this.lastupdate,
    required this.Note,
    required this.a1, required this.a2, required this.a3, required this.a4, required this.a5,
    required this.a6, required this.a7, required this.a8, required this.a9, required this.a10, required this.a11, required this.a12,
    required this.b1, required this.b2, required this.b3, required this.b4, required this.b5, required this.b6, required this.b7,
    required this.b8, required this.b9, required this.b10, required this.b11, required this.b12,
    required this.c1, required this.c2, required this.c3, required this.c4, required this.c5, required this.c6, required this.c7,
    required this.c8, required this.c9, required this.c10, required this.c11, required this.c12,
    required this.d1, required this.d2, required this.d3, required this.d4, required this.d5, required this.d6, required this.d7,
    required this.d8, required this.d9, required this.d10, required this.d11, required this.d12,
    required this.e1, required this.e2, required this.e3, required this.e4, required this.e5, required this.e6, required this.e7,
    required this.e8, required this.e9, required this.e10, required this.e11, required this.e12,
    required this.f1, required this.f2, required this.f3, required this.f4, required this.f5, required this.f6, required this.f7,
    required this.f8, required this.f9, required this.f10, required this.f11, required this.f12,
    required this.g1, required this.g2, required this.g3, required this.g4, required this.g5, required this.g6, required this.g7,
    required this.g8, required this.g9, required this.g10, required this.g11, required this.g12,
    required this.h1, required this.h2, required this.h3, required this.h4, required this.h5, required this.h6, required this.h7,
    required this.h8, required this.h9, required this.h10, required this.h11, required this.h12,
    required this.i1, required this.i2, required this.i3, required this.i4, required this.i5, required this.i6, required this.i7,
    required this.i8, required this.i9, required this.i10, required this.i11, required this.i12,
    required this.j1, required this.j2, required this.j3, required this.j4, required this.j5, required this.j6, required this.j7,
    required this.j8, required this.j9, required this.j10, required this.j11, required this.j12,
    required this.k1, required this.k2, required this.k3, required this.k4, required this.k5, required this.k6, required this.k7,
    required this.k8, required this.k9, required this.k10, required this.k11, required this.k12,
    required this.l1, required this.l2, required this.l3, required this.l4, required this.l5, required this.l6, required this.l7,
    required this.l8, required this.l9, required this.l10, required this.l11, required this.l12,
    required this.m1, required this.m2, required this.m3, required this.m4, required this.m5, required this.m6, required this.m7,
    required this.m8, required this.m9, required this.m10, required this.m11, required this.m12,
  });

  // Convert Timetable to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recesses': recesses,
      'lastupdate': lastupdate.toIso8601String(),
      'Note': Note,
      'noofperiods':noofperiods,
      // a1 to m12 fields
      'a1': a1, 'a2': a2, 'a3': a3, 'a4': a4, 'a5': a5, 'a6': a6, 'a7': a7, 'a8': a8, 'a9': a9, 'a10': a10, 'a11': a11, 'a12': a12,
      'b1': b1, 'b2': b2, 'b3': b3, 'b4': b4, 'b5': b5, 'b6': b6, 'b7': b7, 'b8': b8, 'b9': b9, 'b10': b10, 'b11': b11, 'b12': b12,
      'c1': c1, 'c2': c2, 'c3': c3, 'c4': c4, 'c5': c5, 'c6': c6, 'c7': c7, 'c8': c8, 'c9': c9, 'c10': c10, 'c11': c11, 'c12': c12,
      'd1': d1, 'd2': d2, 'd3': d3, 'd4': d4, 'd5': d5, 'd6': d6, 'd7': d7, 'd8': d8, 'd9': d9, 'd10': d10, 'd11': d11, 'd12': d12,
      'e1': e1, 'e2': e2, 'e3': e3, 'e4': e4, 'e5': e5, 'e6': e6, 'e7': e7, 'e8': e8, 'e9': e9, 'e10': e10, 'e11': e11, 'e12': e12,
      'f1': f1, 'f2': f2, 'f3': f3, 'f4': f4, 'f5': f5, 'f6': f6, 'f7': f7, 'f8': f8, 'f9': f9, 'f10': f10, 'f11': f11, 'f12': f12,
      'g1': g1, 'g2': g2, 'g3': g3, 'g4': g4, 'g5': g5, 'g6': g6, 'g7': g7, 'g8': g8, 'g9': g9, 'g10': g10, 'g11': g11, 'g12': g12,
      'h1': h1, 'h2': h2, 'h3': h3, 'h4': h4, 'h5': h5, 'h6': h6, 'h7': h7, 'h8': h8, 'h9': h9, 'h10': h10, 'h11': h11, 'h12': h12,
      'i1': i1, 'i2': i2, 'i3': i3, 'i4': i4, 'i5': i5, 'i6': i6, 'i7': i7, 'i8': i8, 'i9': i9, 'i10': i10, 'i11': i11, 'i12': i12,
      'j1': j1, 'j2': j2, 'j3': j3, 'j4': j4, 'j5': j5, 'j6': j6, 'j7': j7, 'j8': j8, 'j9': j9, 'j10': j10, 'j11': j11, 'j12': j12,
      'k1': k1, 'k2': k2, 'k3': k3, 'k4': k4, 'k5': k5, 'k6': k6, 'k7': k7, 'k8': k8, 'k9': k9, 'k10': k10, 'k11': k11, 'k12': k12,
      'l1': l1, 'l2': l2, 'l3': l3, 'l4': l4, 'l5': l5, 'l6': l6, 'l7': l7, 'l8': l8, 'l9': l9, 'l10': l10, 'l11': l11, 'l12': l12,
      'm1': m1, 'm2': m2, 'm3': m3, 'm4': m4, 'm5': m5, 'm6': m6, 'm7': m7, 'm8': m8, 'm9': m9, 'm10': m10, 'm11': m11, 'm12': m12,
    };
  }


  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'] ?? '',noofperiods:json['noofperiods']??1,
      recesses: json['recesses'] ?? [],
      lastupdate: DateTime.parse(json['lastupdate'] ?? DateTime.now().toIso8601String()),
      Note: json['Note'] ?? '',
      a1: json['a1'] ?? '',
      a2: json['a2'] ?? '',
      a3: json['a3'] ?? '',
      a4: json['a4'] ?? '',
      a5: json['a5'] ?? '',
      a6: json['a6'] ?? '',
      a7: json['a7'] ?? '',
      a8: json['a8'] ?? '',
      a9: json['a9'] ?? '',
      a10: json['a10'] ?? '',
      a11: json['a11'] ?? '',
      a12: json['a12'] ?? '',
      b1: json['b1'] ?? '',
      b2: json['b2'] ?? '',
      b3: json['b3'] ?? '',
      b4: json['b4'] ?? '',
      b5: json['b5'] ?? '',
      b6: json['b6'] ?? '',
      b7: json['b7'] ?? '',
      b8: json['b8'] ?? '',
      b9: json['b9'] ?? '',
      b10: json['b10'] ?? '',
      b11: json['b11'] ?? '',
      b12: json['b12'] ?? '',
      c1: json['c1'] ?? '',
      c2: json['c2'] ?? '',
      c3: json['c3'] ?? '',
      c4: json['c4'] ?? '',
      c5: json['c5'] ?? '',
      c6: json['c6'] ?? '',
      c7: json['c7'] ?? '',
      c8: json['c8'] ?? '',
      c9: json['c9'] ?? '',
      c10: json['c10'] ?? '',
      c11: json['c11'] ?? '',
      c12: json['c12'] ?? '',
      d1: json['d1'] ?? '',
      d2: json['d2'] ?? '',
      d3: json['d3'] ?? '',
      d4: json['d4'] ?? '',
      d5: json['d5'] ?? '',
      d6: json['d6'] ?? '',
      d7: json['d7'] ?? '',
      d8: json['d8'] ?? '',
      d9: json['d9'] ?? '',
      d10: json['d10'] ?? '',
      d11: json['d11'] ?? '',
      d12: json['d12'] ?? '',
      e1: json['e1'] ?? '',
      e2: json['e2'] ?? '',
      e3: json['e3'] ?? '',
      e4: json['e4'] ?? '',
      e5: json['e5'] ?? '',
      e6: json['e6'] ?? '',
      e7: json['e7'] ?? '',
      e8: json['e8'] ?? '',
      e9: json['e9'] ?? '',
      e10: json['e10'] ?? '',
      e11: json['e11'] ?? '',
      e12: json['e12'] ?? '',
      f1: json['f1'] ?? '',
      f2: json['f2'] ?? '',
      f3: json['f3'] ?? '',
      f4: json['f4'] ?? '',
      f5: json['f5'] ?? '',
      f6: json['f6'] ?? '',
      f7: json['f7'] ?? '',
      f8: json['f8'] ?? '',
      f9: json['f9'] ?? '',
      f10: json['f10'] ?? '',
      f11: json['f11'] ?? '',
      f12: json['f12'] ?? '',
      g1: json['g1'] ?? '',
      g2: json['g2'] ?? '',
      g3: json['g3'] ?? '',
      g4: json['g4'] ?? '',
      g5: json['g5'] ?? '',
      g6: json['g6'] ?? '',
      g7: json['g7'] ?? '',
      g8: json['g8'] ?? '',
      g9: json['g9'] ?? '',
      g10: json['g10'] ?? '',
      g11: json['g11'] ?? '',
      g12: json['g12'] ?? '',
      h1: json['h1'] ?? '',
      h2: json['h2'] ?? '',
      h3: json['h3'] ?? '',
      h4: json['h4'] ?? '',
      h5: json['h5'] ?? '',
      h6: json['h6'] ?? '',
      h7: json['h7'] ?? '',
      h8: json['h8'] ?? '',
      h9: json['h9'] ?? '',
      h10: json['h10'] ?? '',
      h11: json['h11'] ?? '',
      h12: json['h12'] ?? '',
      i1: json['i1'] ?? '',
      i2: json['i2'] ?? '',
      i3: json['i3'] ?? '',
      i4: json['i4'] ?? '',
      i5: json['i5'] ?? '',
      i6: json['i6'] ?? '',
      i7: json['i7'] ?? '',
      i8: json['i8'] ?? '',
      i9: json['i9'] ?? '',
      i10: json['i10'] ?? '',
      i11: json['i11'] ?? '',
      i12: json['i12'] ?? '',
      j1: json['j1'] ?? '',
      j2: json['j2'] ?? '',
      j3: json['j3'] ?? '',
      j4: json['j4'] ?? '',
      j5: json['j5'] ?? '',
      j6: json['j6'] ?? '',
      j7: json['j7'] ?? '',
      j8: json['j8'] ?? '',
      j9: json['j9'] ?? '',
      j10: json['j10'] ?? '',
      j11: json['j11'] ?? '',
      j12: json['j12'] ?? '',
      k1: json['k1'] ?? '',
      k2: json['k2'] ?? '',
      k3: json['k3'] ?? '',
      k4: json['k4'] ?? '',
      k5: json['k5'] ?? '',
      k6: json['k6'] ?? '',
      k7: json['k7'] ?? '',
      k8: json['k8'] ?? '',
      k9: json['k9'] ?? '',
      k10: json['k10'] ?? '',
      k11: json['k11'] ?? '',
      k12: json['k12'] ?? '',
      l1: json['l1'] ?? '',
      l2: json['l2'] ?? '',
      l3: json['l3'] ?? '',
      l4: json['l4'] ?? '',
      l5: json['l5'] ?? '',
      l6: json['l6'] ?? '',
      l7: json['l7'] ?? '',
      l8: json['l8'] ?? '',
      l9: json['l9'] ?? '',
      l10: json['l10'] ?? '',
      l11: json['l11'] ?? '',
      l12: json['l12'] ?? '',
      m1: json['m1'] ?? '',
      m2: json['m2'] ?? '',
      m3: json['m3'] ?? '',
      m4: json['m4'] ?? '',
      m5: json['m5'] ?? '',
      m6: json['m6'] ?? '',
      m7: json['m7'] ?? '',
      m8: json['m8'] ?? '',
      m9: json['m9'] ?? '',
      m10: json['m10'] ?? '',
      m11: json['m11'] ?? '',
      m12: json['m12'] ?? '',
    );
  }

}




class TimetableGrid extends StatelessWidget {
  final Timetable timetable;

  const TimetableGrid({Key? key, required this.timetable}) : super(key: key);

  // Function to create a cell widget
  Widget buildCell(String content) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Text(content),
      ),
    );
  }

  // Function to create a row widget
  Widget buildRow(String rowPrefix) {
    return Row(
      children: [
        for (var i = 1; i <= 12;)
          buildCell(timetable.fields['$rowPrefix$i'] ?? 'default'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Grid'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                for (var i = 1; i <= 12;) buildCell('a$i'),
              ],
            ),
            // Data Rows
            buildRow('b'),
            buildRow('c'),
            buildRow('d'),
            buildRow('e'),
            buildRow('f'),
            buildRow('g'),
            buildRow('h'),
            buildRow('i'),
            buildRow('j'),
            buildRow('k'),
            buildRow('l'),
            buildRow('m'),
          ],
        ),
      ),
    );
  }
}

