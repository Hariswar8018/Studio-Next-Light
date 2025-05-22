import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_managment_app/classroom_universal/add/log_warning.dart';
import 'package:student_managment_app/model/logmodel.dart';
import 'package:student_managment_app/model/student_model.dart';

class LogsWarnings extends StatelessWidget {
   LogsWarnings({super.key,required this.h , required this.r,
     required this.user,required this.showonly,
     required this.sname,
     required this.length, required this.st, required this.b,
     required this.id,
     required this.session_id,
     required this.class_id,required this.type});
   StudentModel user;bool showonly;
   int length; bool h ; //attendance edit
   String st ; bool b ; // not yet
   String id;
   bool r ; //message
   String type;
   String session_id;
   String sname ;
   String class_id;
  List<LogModel> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text('${user.Name} ${type}'),
      ),
      floatingActionButton: (showonly&&type!="LoginSecurity")?FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LogForm(
                  h:h, r: r, sname: sname,showonly: showonly,
                  st: st, length: length, b: b, session_id: session_id,
                  class_id: class_id, user: user, type: type, id: id,))
        );
      },child: Icon(Icons.add),):SizedBox(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('School')
            .doc(id)
            .collection('Session')
            .doc(session_id)
            .collection("Class")
            .doc(class_id)
            .collection("Student").doc(user.Registration_number).collection(type)
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
                  ?.map((e) => LogModel.fromJson(e.data()))
                  .toList() ??
                  [];
              if (list.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, color: Colors.blue, size: 30),
                    SizedBox(height: 10),
                    Center(
                      child: Text("No $type Found for ${user.Name}"),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    LogModel userr=list[index];
                    return Card(
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width-15,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userr.title,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
                              Text(userr.description,style: TextStyle(fontWeight: FontWeight.w200,fontSize: 10),),
                              SizedBox(height: 7),
                              Text("Reported on : "+getDayAndMonth(userr.date),style: TextStyle(fontWeight: FontWeight.w200,fontSize: 10),),
                            ],
                          ),
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
   String getDayAndMonth(String dateTimeString) {
     try {
       // Parse the input string to DateTime
       DateTime dateTime = DateTime.parse(dateTimeString);

       // Format day name (e.g., "Monday")
       String dayName = DateFormat('EEEE').format(dateTime); // Full day name

       // Format month name (e.g., "January")
       String monthName = DateFormat('MMMM').format(dateTime); // Full month name

       return '${dateTime.day} ($dayName), $monthName';
     } catch (e) {
       return "Invalid date format";
     }
   }
}
