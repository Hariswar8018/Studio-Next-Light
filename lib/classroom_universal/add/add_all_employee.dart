import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/employee_model.dart';
import 'package:student_managment_app/model/usermodel.dart';

class Add_My_Teachers extends StatefulWidget {
  String school;bool admi;String classid;
  Add_My_Teachers({super.key,required this.school,required this.admi,required this.classid});

  @override
  State<Add_My_Teachers> createState() => _Add_My_TeachersState();
}

class _Add_My_TeachersState extends State<Add_My_Teachers> {
  bool add=false;

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
        title: Text("Add Teachers",style:TextStyle(color:Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        add=!add;
        setState(() {

        });
      },child: Icon(Icons.swipe),),
      body:add? StreamBuilder(
        stream:FirebaseFirestore.instance.collection('Users').where("schoolid",isEqualTo: widget.school).where("position",isEqualTo: "Class Teacher").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
              if(_list.isEmpty){
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
                itemCount: _list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  UserModel user=_list[index];
                  return InkWell(
                    onTap: () async {
                      try {
                        EmployeeModel emp=EmployeeModel(
                            Name: user.name, present: [], Pic: user.pic, DOB: "",
                            Profession: "Teacher", Address:"",
                            Phone: "", Email: user.email, BloodG: "",
                            Emergency_Contact: "", Father_Name: "",
                            Id_number: user.uid, Registration_Number: ""
                        );
                        await FirebaseFirestore.instance.collection('School')
                            .doc(widget.school).collection('Employee').doc(user.uid).set(emp.toJson());
                        await FirebaseFirestore.instance.collection('School')
                            .doc(widget.school).
                        collection('Employee').doc(user.uid)
                            .update({
                          "teacher": FieldValue.arrayUnion([widget.classid]),
                        });
                        Send.message(context, "Added Successfully!", true);
                      }catch(e){
                        Send.message(context, "$e", false);
                      }
                    },
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.pic),
                        ),
                        title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w700),),
                        subtitle: Text(user.position,style: TextStyle(fontWeight: FontWeight.w200),),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ):StreamBuilder(
        stream:FirebaseFirestore.instance.collection('School').doc(widget.school).
        collection('Employee').snapshots(),
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
                  return InkWell(
                    onTap: () async {
                      try {
                        await FirebaseFirestore.instance.collection('School')
                            .doc(widget.school).
                        collection('Employee').doc(user.Id_number)
                            .update({
                          "teacher": FieldValue.arrayUnion([widget.classid]),
                        });
                        Send.message(context, "Added !", true);
                      }catch(e){
                        Send.message(context, "$e", false);
                      }
                    },
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.Pic),
                        ),
                        title: Text(user.Name,style: TextStyle(fontWeight: FontWeight.w700),),
                        subtitle: Text(user.Profession,style: TextStyle(fontWeight: FontWeight.w200),),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }

  List<EmployeeModel> list = [];
  List<UserModel> _list = [];
  late Map<String, dynamic> userMap;
}
