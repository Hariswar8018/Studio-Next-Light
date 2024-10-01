import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/function/send.dart';



int y =0;
class Sticky extends StatelessWidget {
  bool teacher;
  Sticky({super.key,required this.clas,required this.school,required this.id,required this.session,required this.teacher});
  String school,id,session,clas;

  List<Note> _list = [];

  void initState(){
    y=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("My Sticky Notes",style:TextStyle(color:Colors.white,fontSize: 23)),
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Color(0xff1491C7),size: 22,)),
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: Add(id: id, clas: clas, school: school, session: session, teacher: teacher,),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)));
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add,color: Colors.white,size: 20,),
        ),
      ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection('School').doc(school).
        collection('Session').doc(session).collection("Class").doc(clas)
            .collection("Notes").snapshots(),
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
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Sticky Notes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "No Sticky Notes for your Classroom",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              Note.fromJson(e.data())).toList() ?? []);
          return GridView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 5.0, // Space between columns
              mainAxisSpacing: 5.0, // Space between rows
            ),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: JobUhj(user: _list[index], clas: clas, school: school, id: id, session: session, teacher: teacher, )
              );
            },
          );
        },
      ),
    );
  }
}

class JobUhj extends StatefulWidget {
  Note user;
  bool teacher;

  String school,id,session,clas;
  JobUhj({super.key,required this.user,required this.clas,required this.school,required this.id,required this.session,required this.teacher});

  @override
  State<JobUhj> createState() => _JobUhjState();
}

class _JobUhjState extends State<JobUhj> {

  late Color color ;
  void initState(){
    setState(() {
      y++;
    });
    color=ct();
  }

  Color ct(){
    if(y%9==0){
      return Colors.yellow.shade100;
    }else if(y%8==0){
      return Colors.blue.shade100;
    }else if(y%7==0){
      return Colors.greenAccent.shade100;
    }else if(y%6==0){
      return Colors.purpleAccent.shade100;
    }else if(y%5==0){
      return Colors.red.shade100 ;
    }else if(y%4==0){
      return Colors.indigo.shade100 ;
    }else if(y%3==0){
      return Colors.lightGreenAccent.shade100 ;
    }else if(y%2==0){
      return Colors.pink.shade100 ;
    }else{
      return Colors.yellow.shade100 ;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageTransition(
                child: FuL(id: widget.id, clas: widget.clas, school: widget.school,
                  session: widget.session, teacher: widget.teacher, user: widget.user, color: color,),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 50)));
      },
      child: Container(
        width: w-10,
        height: w-10,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19,),),
              Container(
                  width: w-10, child: Text(widget.user.description,maxLines: 7,style: TextStyle(fontSize: 14),)),
            ],
          ),
        ),
      ),
    );
  }
}

class FuL extends StatelessWidget {
  Note user;Color color;
  bool teacher;

  String school,id,session,clas;
  FuL({super.key,required this.color,required this.user,required this.clas,required this.school,required this.id,required this.session,required this.teacher});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text(user.title,style:TextStyle(color:Colors.white,fontSize: 23)),
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Color(0xff1491C7),size: 22,)),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap:() async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Note '),
                    content: Text('You Sure to Delete the Note Permanently'),
                    actions: [
                      ElevatedButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('School').doc(school).
                          collection('Session').doc(session).collection("Class").doc(clas)
                              .collection("Notes").doc(user.id)
                              .delete();
                          Navigator.pop(context);
                          Send.message(context, "Delete Success", true);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Center(child: Icon(Icons.delete,color:Colors.white,size: 22,)),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,),),
            Text(user.description,style: TextStyle(fontSize: 14),)
          ],
        ),
      ),
    );
  }
}


class Add extends StatefulWidget {
  bool teacher;
  String school,id,session,clas;
  Add({super.key,required this.clas,required this.school,required this.id,required this.session,required this.teacher});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  bool up=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Sticky Notes",style:TextStyle(color:Colors.white,fontSize: 23)),
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Color(0xff1491C7),size: 22,)),
            ),
          ),
        ),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text("  Title",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          dcc(name,"Title of Note","Please type topic of post",false),
          SizedBox(height: 10,),
          Text("  Description",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          dccc(link,"Full Description","Enter Link to file or Web",false),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 9.0, right: 9),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Add Sticky Note',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                String d=DateTime.now().microsecondsSinceEpoch.toString();
                Note u=Note(id: d, title: name.text, description: link.text);
                await  FirebaseFirestore.instance.collection('School').doc(widget.school).
                collection('Session').doc(widget.session).collection("Class").doc(widget.clas)
                    .collection("Notes").doc(d)
                    .set(u.toJson());
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
  Widget as(){
    if(st=="PDF"){
      return Icon(Icons.picture_as_pdf,size: 50,);
    }else if(st=="Picture"){
      return Icon(Icons.photo,size: 50,);
    }else{
      return Icon(Icons.upload_file_rounded,size: 50,);
    }
  }
  TextEditingController link = TextEditingController();
  TextEditingController name = TextEditingController();
  String st="PDF";
  Widget dcc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,minLines: 1,
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
        onChanged: (value){
          setState(() {

          });
        },
      ),
    );
  }
  Widget dccc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,minLines: 15,maxLines: 200,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
        onChanged: (value){
          setState(() {

          });
        },
      ),
    );
  }
  Widget rt(String jh){
    return InkWell(
        onTap : () async {
          setState(() {
            st=jh;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(jh, style : TextStyle(fontSize: 16, color :  st == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
}


class Note {
  late final String id;
  late final String title;
  late final String description;

  // Constructor
  Note({
    required this.id,
    required this.title,
    required this.description,
  });

  // Convert from JSON
  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    title = json['title'] ?? '';
    description = json['description'] ?? '';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

