import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/attendance/notice.dart';

class NoticeMeeting extends StatelessWidget {
  bool teacher;
  NoticeMeeting({super.key,required this.clas,required this.school,required this.id,required this.session,required this.teacher});
  String school,id,session,clas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Color(0xff029A81),
        title: Text("My Notices",style:TextStyle(color:Colors.white)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School').doc(school).
        collection('Session').doc(session).collection("Class").doc(clas)
            .collection("Notices").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => Notice.fromJson(e.data())).toList() ?? [];
              if(list.isEmpty){
                return Column(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Center(child: Text("No Parents & Teachers Meeting",style:TextStyle(fontSize:21,fontWeight:FontWeight.w500))),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(textAlign:TextAlign.center,"Look likes Parents Teachers Meeting was not decided by Teachers still",style:TextStyle(fontSize:17,fontWeight:FontWeight.w400)),
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
                  return ChatUserR(
                    user: list[index],
                  );
                },
              );
          }
        },
      ),
    );
  }
  List<Notice> list = [];
  late Map<String, dynamic> userMap;
}
