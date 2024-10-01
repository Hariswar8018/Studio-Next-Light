
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/dormitory/chat.dart';

class DormitoryStudent extends StatelessWidget {
  String id;bool adding;
  UserModel user;
  bool on;bool inn;bool making;
  DormitoryStudent({super.key, required this.id,required this.adding,required this.on,required this.inn,required this.user, this.making=false });

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  String checking(){
    if(adding){
      return "Add Students";
    }else if(!inn) {
      return "In Students";
    }else if(inn){
      return "Out Students";
    }
    return "All Students";
  }
  Stream check(){
    if(adding){
      return Fire.collection('School').doc(id).collection('Students').snapshots();
    }else if(inn){
      return Fire.collection('School').doc(id).collection('Students').where("dormitoryid",isEqualTo: user.uid).where("dorout",isEqualTo: false).snapshots();
    }else if(!inn){
      return Fire.collection('School').doc(id).collection('Students').where("dormitoryid",isEqualTo: user.uid).where("dorout",isEqualTo: true).snapshots();
    }
    return Fire.collection('School').doc(id).collection('Students').where("dormitoryid",isEqualTo: user.uid).snapshots();
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text(checking()),
      ),
      body: StreamBuilder(
        stream: check(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Column(
                children: [
                  Icon(Icons.hourglass_empty,size: 45,),
                  Center(child: Text("No Children")),
                ],
              );
            }
            final data = snapshot.data.docs; // Firestore documents
            list = data.map<StudentModel>((doc) {
              return StudentModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
            return ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUser(
                  user: list[index],
                  id: id,
                  adding: adding,
                  on: on,
                  inn: inn,
                  u: user,
                  making: making,
                );
              },
            );
          } else {
            return Center(child: Text("Something went wrong!"));
          }
        },
      ),
    );
  }

}

class ChatUser extends StatefulWidget {
  StudentModel user;String id;
  bool adding;bool making;
  UserModel u;
  bool on;bool inn;
  ChatUser({super.key,required this.making, required this.user,required this.id,required this.adding,required this.on,required this.inn,required this.u});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {

  @override
  void initState() {
    super.initState();
    if (widget.user.dorin.isEmpty) {
      FirebaseFirestore.instance
          .collection('School')
          .doc(widget.id)
          .collection('Students')
          .doc(widget.user.Registration_number)
          .update({
        "dorin": DateTime.now().millisecondsSinceEpoch.toString(),
        "dorout": true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        if(widget.adding){
          try{
            await FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Students').doc(widget.user.Registration_number).update({
              "dormitoryid":widget.u.uid,
            });
            Send.message(context, "Done !", true);
          }catch(e){
            Send.message(context, "$e", false);
          }
        }else if(widget.making){
          if(widget.inn){
            try{
              await FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Students').doc(widget.user.Registration_number).update({
                "dorin":DateTime.now().millisecondsSinceEpoch.toString(),
                "dorout":true,
              });
              Send.message(context, "Done ! Student is Inside", true);
              final id=DateTime.now().millisecondsSinceEpoch.toString();
              DormitoryHistory us=DormitoryHistory(
                  id: id, name: widget.user.Name, pic: widget.user.pic,
                  inTime:'IN', day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year
              );
              await FirebaseFirestore.instance.collection("School").doc(widget.u.schoolid).collection("Dormitory").doc(id).set(us.toJson());
            }catch(e){
              Send.message(context, "$e", false);
            }
          }else{
            try{
              await FirebaseFirestore.instance.collection('School').doc(widget.id).collection('Students').doc(widget.user.Registration_number).update({
                "dorin":DateTime.now().millisecondsSinceEpoch.toString(),
                "dorout":false,
              });
              Send.message(context, "Done ! Student is Outside", true);
              final id=DateTime.now().millisecondsSinceEpoch.toString();
              DormitoryHistory us=DormitoryHistory(
                  id: id, name: widget.user.Name, pic: widget.user.pic,
                  inTime:'OUT', day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year
              );
              await FirebaseFirestore.instance.collection("School").doc(widget.u.schoolid).collection("Dormitory").doc(id).set(us.toJson());
            }catch(e){
              Send.message(context, "$e", false);
            }
          }
        }

      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.pic),
      ),
      title: Text(widget.user.Name, style : TextStyle( fontWeight: FontWeight.w700)),
      // subtitle:
      subtitle: Text("Class : " + widget.user.Class+ " (${widget.user.Section})",style: TextStyle(fontSize: 12),),
      trailing: widget.user.dormitoryid.isEmpty? Container(
        width: 110,
        height: 30,
        color:Colors.red,
        child: Center(child: Text("Not from Dormitory",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
      ):Container(
        width: 120,
        height: 45,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 30,
              color:Colors.blue,
              child: Center(child: Text(widget.user.dorout?"IN":"OUT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
            ),
            Container(
              width: 60,
              height: 30,
              color:Colors.green,
              child: Center(child: Text(convertMillisecondsToTime(widget.user.dorin),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)),
            )
          ],
        ),
      ),
      splashColor: Colors.orange.shade300,
      tileColor:  Colors.white,
    );
  }
  String convertMillisecondsToTime(String millisecondsString) {
    try {
      int milliseconds = int.parse(millisecondsString);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);

      String formattedTime = "${date.hour.toString().padLeft(2, '0')}:${date
          .minute.toString().padLeft(2, '0')}";

      return formattedTime;
    }catch(e){
      return "NA";
    }
  }

  String hjk( String g ) {
    String dateTimeString = g; // Replace with your DateTime string
    print(g);
    // Convert DateTime string to DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate ;
  }
}
