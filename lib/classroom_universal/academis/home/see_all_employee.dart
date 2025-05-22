import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/classroom_universal/add/add_all_employee.dart';
import 'package:student_managment_app/model/employee_model.dart';

class All_My_Teachers extends StatelessWidget {
  String school;bool admi;String classid;
   All_My_Teachers({super.key,required this.school,required this.admi,required this.classid});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Color(0xff029A81),
        title: Text("My Teachers",style:TextStyle(color:Colors.white)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School').doc(school).
        collection('Employee').where("teacher",arrayContains: classid).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => EmployeeModel.fromJson(e.data())).toList() ?? [];
              if(list.isEmpty){
                return Column(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Center(child: Text("No Teachers found",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500))),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(textAlign:TextAlign.center,"Look likes No Subject Teacher find",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
                        ),
                      ),
                      SizedBox(height:40),
                    ]
                );
              }
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  EmployeeModel user=list[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.Pic),
                      ),
                      title: Text(user.Name,style: TextStyle(fontWeight: FontWeight.w700),),
                      subtitle: Text(user.Profession,style: TextStyle(fontWeight: FontWeight.w200),),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton:admi?FloatingActionButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Add_My_Teachers(
                school: school, admi: true, classid: classid,)),
        );
      },child: Icon(Icons.add,),):SizedBox(),
    );
  }
  List<EmployeeModel> list = [];
  late Map<String, dynamic> userMap;
}
