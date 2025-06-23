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
        title: Text("School Duty Form",style:TextStyle(color:Colors.white,fontSize: 23)),
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection('School').doc(widget.id).collection("DutyForm").snapshots(),
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
                      Timetable au=Timetable(
                        id: "", title: false,
                        lastupdate: DateTime.now(), breaks: [], a1: a1.text, a2: a2.text,
                        a3: a3.text, a4: a4.text, a5: a5.text, a6: a6.text, a7: a7.text, a8: a8.text, a9: a9.text,
                        a10: a10.text, a11: a11.text, a12: a12.text, a13: a13.text, a14: a14.text, a15: a15.text,
                        b1: b1.text, b2: b2.text, b3: b3.text, b4: b4.text, b5: b5.text, b6: b6.text, b7: b7.text, b8: b8.text,
                        b9: b9.text, b10: b10.text, b11: b11.text, b12: b12.text, b13: b13.text, b14: b14.text, b15: b15.text, blankspace: false,);
                      Navigator.push(
                          context,
                          PageTransition(
                              child:TimetableForm(id: widget.id, au: au,),
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
                    "No Duty Table",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  widget.teacher? Text(
                    "No Duty Table added",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ): Text(
                    "No Duty Table added by Managment Yet",
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
            padding: const EdgeInsets.all(1.0),
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final timetable = _list[index];
                return JobUh(
                  small: small,
                  user: timetable,
                  teacher: widget.teacher,
                  id: widget.id,
                );
              },
            ),
          );

        },
      ),
      floatingActionButton: widget.teacher?InkWell(
        onTap: (){
          Timetable au=Timetable(
              id: "", title: false,
              lastupdate: DateTime.now(), breaks: [], a1: a1.text, a2: a2.text,
              a3: a3.text, a4: a4.text, a5: a5.text, a6: a6.text, a7: a7.text, a8: a8.text, a9: a9.text, 
              a10: a10.text, a11: a11.text, a12: a12.text, a13: a13.text, a14: a14.text, a15: a15.text, 
              b1: b1.text, b2: b2.text, b3: b3.text, b4: b4.text, b5: b5.text, b6: b6.text, b7: b7.text, b8: b8.text,
              b9: b9.text, b10: b10.text, b11: b11.text, b12: b12.text, b13: b13.text, b14: b14.text, b15: b15.text, blankspace: false,);
          Navigator.push(
              context,
              PageTransition(
                  child:TimetableForm(id: widget.id, au: au,),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)));
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add,color: Colors.white,size: 20,),
        ),
      ):SizedBox(),
      persistentFooterButtons: [
        Center(child: Text("Double Tap to Edit         Long Press to Delete         View in Landscape for Better View"))
      ],
    );
  }
  final TextEditingController a1 = TextEditingController();

  final TextEditingController a2 = TextEditingController();

  final TextEditingController a3 = TextEditingController();

  final TextEditingController a4 = TextEditingController();

  final TextEditingController a5 = TextEditingController();

  final TextEditingController a6 = TextEditingController();

  final TextEditingController a7 = TextEditingController();

  final TextEditingController a8 = TextEditingController();

  final TextEditingController a9 = TextEditingController();

  final TextEditingController a10 = TextEditingController();

  final TextEditingController a11 = TextEditingController();

  final TextEditingController a12 = TextEditingController();

  final TextEditingController a13 = TextEditingController();

  final TextEditingController a14 = TextEditingController();

  final TextEditingController a15 = TextEditingController();

  final TextEditingController b1 = TextEditingController();

  final TextEditingController b2 = TextEditingController();

  final TextEditingController b3 = TextEditingController();

  final TextEditingController b4 = TextEditingController();

  final TextEditingController b5 = TextEditingController();

  final TextEditingController b6 = TextEditingController();

  final TextEditingController b7 = TextEditingController();

  final TextEditingController b8 = TextEditingController();

  final TextEditingController b9 = TextEditingController();

  final TextEditingController b10 = TextEditingController();

  final TextEditingController b11 = TextEditingController();

  final TextEditingController b12 = TextEditingController();

  final TextEditingController b13 = TextEditingController();

  final TextEditingController b14 = TextEditingController();

  final TextEditingController b15 = TextEditingController();
}

class JobUh extends StatelessWidget {
  Timetable user;
  bool teacher;
  String id;
  bool small;
  JobUh({super.key,required this.id,required this.small,required this.user,required this.teacher});

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
    return InkWell(
      onDoubleTap: (){
        if(teacher){
          Navigator.push(
              context,
              PageTransition(
                  child:TimetableForm(id:id, au: user,on: true,),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)));
        }
      },
      onLongPress: (){
        if(teacher){
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
            title: const Text('Delete'),
            content: Text("You sure to Delete this Form ID....You could choose to edit ?"),
            actions: [
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('School').doc(id).collection("DutyForm").doc(user.id).delete();
                  Navigator.pop(context);
                },
                child: const Text('YES'),
              ),TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('NO'),
              ),
            ],
          ));
        }
      },
      child: user.blankspace?Container(
        height: 40,width: w,
        color: Colors.grey.shade50,
      ):Container(
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            a(user.a1, user.b1, w,1),a(user.a2, user.b2, w,2),
            a(user.a3, user.b3, w,3),a(user.a4, user.b4, w,4),
            a(user.a5, user.b5, w,5),a(user.a6, user.b6, w,6),
            a(user.a7, user.b7, w,7),a(user.a8, user.b8, w,8),
            a(user.a9, user.b9, w,9),a(user.a10, user.b10, w,10,),
            a(user.a11, user.b11, w,11),a(user.a12, user.b12, w,12),
            a(user.a13, user.b13, w,13),a(user.a14, user.b14, w,14),
            a(user.a15, user.b15, w,14),
          ],
        ),
      ),
    );
  }
  Widget a(String s,String s2, double w, int ui){

    if(user.title||small){
      if(user.breaks.contains(ui)){
        return Container(
          height: (w/15.5),
          width: w/15.1,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 0.5),
            color:Colors.grey.shade100,
          ),
        );
      }
      return Container(
        height: (w/15.5),
        width: w/15.1,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 0.5),
          color:Colors.grey.shade100,
        ),
        child: Center(child: Text(s,style: TextStyle(fontSize: w/70),)),
      );
    }else{
      if(user.breaks.contains(ui)){
        return Container(
            height: (w/15.5)*1.9,
            width: (w/15.1),
          decoration: BoxDecoration(

              color: Colors.grey.shade200
          ),
        );
      }
      return Container(
        height: (w/15.5)*1.9,
        width: (w/15.1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black,width: 0.3)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(s,style: TextStyle(fontSize: w/70),),
            s2.isEmpty?SizedBox():Text("( "+s2+" )",style: TextStyle(fontSize: w/80),),
          ],
        ),
      );
    }
  }

}
int y=0;

class TimetableForm extends StatefulWidget {
  final String id;
  bool on;
  
  Timetable au;
  TimetableForm({required this.id,this.on=false,required this.au});

  @override
  State<TimetableForm> createState() => _TimetableFormState();
}

class _TimetableFormState extends State<TimetableForm> {
  late String id;
  void initState(){
    as();
    if(widget.on){

      _isSwitched=widget.au.title;

      id=widget.au.id;
      breaks=widget.au.breaks;
      a1.text = widget.au.a1;
      a2.text = widget.au.a2;
      a3.text = widget.au.a3;
      a4.text = widget.au.a4;
      a5.text = widget.au.a5;
      a6.text = widget.au.a6;
      a7.text = widget.au.a7;
      a8.text = widget.au.a8;
      a9.text = widget.au.a9;
      a10.text = widget.au.a10;
      a11.text = widget.au.a11;
      a12.text = widget.au.a12;
      a13.text = widget.au.a13;
      a14.text = widget.au.a14;
      a15.text = widget.au.a15;

// Assign values for b1 to b15
      b1.text = widget.au.b1;
      b2.text = widget.au.b2;
      b3.text = widget.au.b3;
      b4.text = widget.au.b4;
      b5.text = widget.au.b5;
      b6.text = widget.au.b6;
      b7.text = widget.au.b7;
      b8.text = widget.au.b8;
      b9.text = widget.au.b9;
      b10.text = widget.au.b10;
      b11.text = widget.au.b11;
      b12.text = widget.au.b12;
      b13.text = widget.au.b13;
      b14.text = widget.au.b14;
      b15.text = widget.au.b15;

    }else{
      id=DateTime.now().microsecondsSinceEpoch.toString();
    }
    setState(() {

    });
  }
  as()async{
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController a1 = TextEditingController();

  final TextEditingController a2 = TextEditingController();

  final TextEditingController a3 = TextEditingController();

  final TextEditingController a4 = TextEditingController();

  final TextEditingController a5 = TextEditingController();

  final TextEditingController a6 = TextEditingController();

  final TextEditingController a7 = TextEditingController();

  final TextEditingController a8 = TextEditingController();

  final TextEditingController a9 = TextEditingController();

  final TextEditingController a10 = TextEditingController();

  final TextEditingController a11 = TextEditingController();

  final TextEditingController a12 = TextEditingController();

  final TextEditingController a13 = TextEditingController();

  final TextEditingController a14 = TextEditingController();

  final TextEditingController a15 = TextEditingController();

  final TextEditingController b1 = TextEditingController();

  final TextEditingController b2 = TextEditingController();

  final TextEditingController b3 = TextEditingController();

  final TextEditingController b4 = TextEditingController();

  final TextEditingController b5 = TextEditingController();

  final TextEditingController b6 = TextEditingController();

  final TextEditingController b7 = TextEditingController();

  final TextEditingController b8 = TextEditingController();

  final TextEditingController b9 = TextEditingController();

  final TextEditingController b10 = TextEditingController();

  final TextEditingController b11 = TextEditingController();

  final TextEditingController b12 = TextEditingController();

  final TextEditingController b13 = TextEditingController();

  final TextEditingController b14 = TextEditingController();

  final TextEditingController b15 = TextEditingController();

  Widget buildTextField(TextEditingController fieldName,String i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: fieldName,
        readOnly: blankspace,
        decoration: InputDecoration(
          labelText: "",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

bool _isSwitched=false;
  bool blankspace=false;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Timetable Form',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 13,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Text(
                    "IS this BLANKSPACE? : ${blankspace ? "YES" : "NO"}",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black),
                  ),
                  Spacer(),
                  Switch(
                    value:blankspace, // Boolean value controlling the switch
                    onChanged: (value) {
                      setState(() {
                       blankspace = value; // Update the boolean variable
                      });
                    },
                  ), SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 13,),
              blankspace?SizedBox():Row(
                children: [
                  SizedBox(width: 10,),
                  Text(
                    "This is : ${_isSwitched ? "TITLE" : "BODY"}",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black),
                  ),
                  Spacer(),
                  Switch(
                    value: _isSwitched, // Boolean value controlling the switch
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value; // Update the boolean variable
                      });
                    },
                  ), SizedBox(width: 10,),
                ],
              ), SizedBox(height: 15,),
              blankspace?SizedBox():Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.cut), SizedBox(width: 3,),
                  Text("Short Rows by Half",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black),),
                ],
              ),
              SizedBox(height: 10,),
              blankspace?SizedBox():Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  a(1),
                a(2),
                a(3),
                a(4),
                a(5),
                a(6),
                a(7),
                a(8),
              ],),
              SizedBox(height: 10,),
              blankspace?SizedBox():Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  a(9),
                  a(10),a(11),a(12),a(13),a(14),a(15)
                ],),
              SizedBox(height: 24,),
              blankspace?SizedBox(): Row(
                children: [
                  Container(
                    width: w/2+10,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.insert_drive_file), SizedBox(width: 3,),
                        Text("Main Info",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black),),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.info_outlined), SizedBox(width: 3,),
                  Text("Expand Info",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black),),
                ],
              ),
              _isSwitched?Row(
                children: [
                  Container(
                    width: w/2+10,
                  ),
                  SizedBox(width: 20,),
                  Text("( May Optional )",style: TextStyle(fontSize: 9,fontWeight: FontWeight.w400,color: Colors.red),),
                ],
              ):SizedBox(),
              blankspace?SizedBox():Container(
                width: w,
                child: Row(
                  children: [
                    Container(
                      width: w/2+15,
                      child: Column(
                        children: [
                          buildTextField(a1, "First"),
                          buildTextField(a2, "First"),
                          buildTextField(a3, "First"),
                          buildTextField(a4, "First"),
                          buildTextField(a5, "First"),
                          buildTextField(a6, "First"),
                          buildTextField(a7, "First"),
                          buildTextField(a8, "First"),
                          buildTextField(a9, "First"),
                          buildTextField(a10, "First"),
                          buildTextField(a11, "First"),
                          buildTextField(a12, "First"),
                          buildTextField(a13, "First"),
                          buildTextField(a14, "First"),
                          buildTextField(a15, "First"),
                        ],
                      ),
                    ),
                    Container(
                      width: w/2-15,
                      child: Column(
                        children: [
                          buildTextField(b1, "First"),
                          buildTextField(b2, "First"),
                          buildTextField(b3, "First"),
                          buildTextField(b4, "First"),
                          buildTextField(b5, "First"),
                          buildTextField(b6, "First"),
                          buildTextField(b7, "First"),
                          buildTextField(b8, "First"),
                          buildTextField(b9, "First"),
                          buildTextField(b10, "First"),
                          buildTextField(b11, "First"),
                          buildTextField(b12, "First"),
                          buildTextField(b13, "First"),
                          buildTextField(b14, "First"),
                          buildTextField(b15, "First"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            try {
            DateTime lastupdate=DateTime.now();
            Timetable user=Timetable(
                id: id, title: _isSwitched, lastupdate: lastupdate,
                breaks: breaks, a1: a1.text, a2: a2.text, a3: a3.text, a4: a4.text, a5: a5.text, a6: a6.text, a7: a7.text,
                a8: a8.text, a9: a9.text, a10: a10.text, a11: a11.text, a12: a12.text, a13: a13.text, a14: a14.text, a15:
            a15.text, b1: b1.text, b2: b2.text, b3: b3.text, b4: b4.text, b5: b5.text, b6: b6.text, b7: b7.text, b8: b8.text, b9: b9.text,
                b10: b10.text, b11: b11.text, b12: b12.text, b13: b13.text, b14: b14.text, b15: b15.text, blankspace: blankspace,
            );

              if(!(widget.on)) {
                await FirebaseFirestore.instance.collection('School').doc(
                    widget.id).collection("DutyForm").doc(id).set(
                    user.toJson());
              } else {
                await FirebaseFirestore.instance.collection('School').doc(
                    widget.id).collection("DutyForm").doc(id).update(
                    user.toJson());
              }
              Navigator.pop(context);
              Send.message(context, "Success ! ", false);
            }catch(e){
              Send.message(context, "$e", false);
            }

          },
          child: Container(
            width: w-15,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade200,
            ),
            child: Center(child: Text("Save",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800),)),
          ),
        )
      ],
    );
  }

  List<int> breaks=[];

  Widget a(int i){
    return InkWell(
      onTap: (){
        if(breaks.contains(i)){
          breaks.remove(i);
        }else{
          breaks=breaks+[i];
        }
        setState(() {
          
        });
      },
      child: Container(
        width: 33,
        height: 33,
        color: breaks.contains(i)?Colors.blue:Colors.black,
        child: Center(child: Text(i.toString(),style: TextStyle(color: breaks.contains(i)?Colors.black:Colors.white,fontWeight: FontWeight.w800),)),
      ),
    );
  }
}




class Timetable {
  final String id;
  final DateTime lastupdate;
  final List<int> breaks;

  bool blankspace;

 bool title;
  final String a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
  final String b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;

  // Constructor
  Timetable({
    required this.blankspace,
    required this.id,
    required this.title,
    required this.lastupdate,
    required this.breaks,
    required this.a1,
    required this.a2,
    required this.a3,
    required this.a4,
    required this.a5,
    required this.a6,
    required this.a7,
    required this.a8,
    required this.a9,
    required this.a10,
    required this.a11,
    required this.a12,
    required this.a13,
    required this.a14,
    required this.a15,
    required this.b1,
    required this.b2,
    required this.b3,
    required this.b4,
    required this.b5,
    required this.b6,
    required this.b7,
    required this.b8,
    required this.b9,
    required this.b10,
    required this.b11,
    required this.b12,
    required this.b13,
    required this.b14,
    required this.b15,
  });

  // Convert Timetable to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blank':blankspace,
      'lastupdate': lastupdate.toIso8601String(),
      'breaks': breaks,
      'a1': a1,
      'a2': a2,
      'a3': a3,
      'a4': a4,
      'title':title,
      'a5': a5,
      'a6': a6,
      'a7': a7,
      'a8': a8,
      'a9': a9,
      'a10': a10,
      'a11': a11,
      'a12': a12,
      'a13': a13,
      'a14': a14,
      'a15': a15,
      'b1': b1,
      'b2': b2,
      'b3': b3,
      'b4': b4,
      'b5': b5,
      'b6': b6,
      'b7': b7,
      'b8': b8,
      'b9': b9,
      'b10': b10,
      'b11': b11,
      'b12': b12,
      'b13': b13,
      'b14': b14,
      'b15': b15,
    };
  }

  // Create Timetable from JSON
  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'] ?? '',
      blankspace: json['blank']??false,
      lastupdate: DateTime.parse(json['lastupdate'] ?? DateTime.now().toIso8601String()),
      breaks: List<int>.from(json['breaks'] ?? []),
      a1: json['a1'] ?? '',
      a2: json['a2'] ?? '',
      a3: json['a3'] ?? '',
      title: json['title']??false,
      a4: json['a4'] ?? '',
      a5: json['a5'] ?? '',
      a6: json['a6'] ?? '',
      a7: json['a7'] ?? '',
      a8: json['a8'] ?? '',
      a9: json['a9'] ?? '',
      a10: json['a10'] ?? '',
      a11: json['a11'] ?? '',
      a12: json['a12'] ?? '',
      a13: json['a13'] ?? '',
      a14: json['a14'] ?? '',
      a15: json['a15'] ?? '',
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
      b13: json['b13'] ?? '',
      b14: json['b14'] ?? '',
      b15: json['b15'] ?? '',
    );
  }
}


