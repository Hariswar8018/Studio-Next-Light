import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/results/add_result.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_model.dart';
import 'package:student_managment_app/model/student_model.dart';

class StudentResult extends StatelessWidget {
   StudentResult({super.key,required this.student,required this.id,required this.session_id,required this.class_id,required this.user,required this.admin});
   StudentModel student;
  String session_id;
  String class_id;
  String id;
  TestModel user;bool admin;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text("${student.Name} Result"),
      ),
      floatingActionButton: admin?FloatingActionButton(onPressed:(){
        Navigator.push(
            context,
            PageTransition(
                child:AddResult(clas: class_id, school: id, session: session_id, test: !user.exam, student: student, testmodel: user,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 10)));
      },child: Icon(Icons.add),):SizedBox(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('School')
            .doc(id)
            .collection('Session')
            .doc(session_id)
            .collection("Class")
            .doc(class_id)
            .collection("Student").doc(student.Registration_number).collection("Results").where("subtitle",isEqualTo: user.id)
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
                  ?.map((e) => TestModel.fromJson(e.data()))
                  .toList() ??
                  [];
              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      width: w-20,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                            Text("Test Result haven't been Added Yet"),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    TestModel users=list[index];
                    return Container(
                      width: w,
                      height: w*1.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1
                        ),
                        color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Text("RESULT",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900,color: Colors.indigo,letterSpacing: 3),)),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                SizedBox(width: 4,),
                                CircleAvatar(
                                  radius: 17,
                                  backgroundImage: NetworkImage(student.pic),
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.Name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                                    Text("Class : "+student.Class+" (${student.Section})",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                                  ],
                                ),
                                 ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: w,
                              height: 3,
                              color: Colors.black,
                            ), SizedBox(height: 5,),
                            Text(users.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                            Text(user.subtitle,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w100),),
                            SizedBox(height: 9,),
                            r1(users.s1, users.d1,w),
                            r1(users.s2, users.d2,w),
                            r1(users.s3, users.d3,w),
                            r1(users.s4, users.d4,w),
                            r1(users.s5, users.d5,w),
                            r1(users.s6, users.d6,w),
                            r1(users.s7, users.d7,w),
                            r1(users.s8, users.d8,w),
                            r1(users.s9, users.d9,w),
                            r1(users.s10, users.d10,w),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(width: 5,),
                                Container(
                                    width: w/3,
                                    child: Text("Total Marks")),
                                Text(" : "),
                                Text(users.syllabus),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 5,),
                                Container(
                                    width: w/3,
                                    child: Text("Total Average ")),
                                Text(" : "),
                                Text(users.totalsubjects),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 5,),
                                Container(
                                    width: w/3,
                                    child: Text("Total Percentage")),
                                Text(" : "),
                                Text(users.totalmarks),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Spacer(),
                            Container(
                              width: w,
                              height: 3,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0,bottom: 3),
                              child: Text("Remarks",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.blue),),
                            ),
                            Text(users.notes,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
  Widget r1(String s,String s2,double w){
    if(s.isEmpty||s2.isEmpty){
      return SizedBox();
    }
    return Row(
      children: [
        SizedBox(width: 5,),
        Container(
            width: w/3,
            child: Text(s)),
        Text(" : "),
        Text(s2),
      ],
    );
  }
  List<TestModel> list = [];

  DateTime now = DateTime.now();

  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
}
