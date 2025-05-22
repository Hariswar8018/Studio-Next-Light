import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_model.dart';
import 'package:student_managment_app/model/student_model.dart';

import 'student_result.dart';

class ResultAll extends StatefulWidget {
 ResultAll({super.key, required this.id,required this.session_id,required this.class_id,required this.user,required this.admin});
  String session_id;
  String class_id;
  String id;
 TestModel user;bool admin;
  @override
  State<ResultAll> createState() => _ResultAllState();
}

class _ResultAllState extends State<ResultAll> {
late final String register;
void initState(){
  dfs();
}
 Future<void> dfs() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   try{
     setState(() {
       register=prefs.getString('id') ?? "None";
     });
   }catch(e){
     setState(() {
       register="None";
     });

   }

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text("Class Results"),
      ),
      body: StreamBuilder(
          stream: widget.admin?FirebaseFirestore.instance
              .collection('School')
              .doc(widget.id)
              .collection('Session')
              .doc(widget.session_id)
              .collection("Class")
              .doc(widget.class_id)
              .collection("Student")
              .snapshots():FirebaseFirestore.instance
            .collection('School')
            .doc(widget.id)
            .collection('Session')
            .doc(widget.session_id)
            .collection("Class")
            .doc(widget.class_id)
            .collection("Student").where("Registration_number",isEqualTo: register)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs ?? [];
              list = data
                  ?.map((e) => StudentModel.fromJson(e.data()))
                  .toList() ??
                  [];
              if (list.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.blue, size: 30),
                    SizedBox(height: 10),
                    Center(
                      child: Text("No Student Found"),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    StudentModel users=list[index];
                    return ListTile(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child:StudentResult(id: widget.id, session_id: widget.session_id, class_id: widget.class_id, user:widget.user, admin: widget.admin, student: users,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 10)));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(users.pic),
                      ),
                      title: Text(users.Name,style: TextStyle(fontWeight: FontWeight.w600),),
                      subtitle: Text("Roll no : "+users.Roll_number.toString()),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }

 List<StudentModel> list = [];

 DateTime now = DateTime.now();

 TextEditingController ud = TextEditingController();

 final Fire = FirebaseFirestore.instance;
}
