import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/usermodel.dart';

class HomeDorw extends StatelessWidget {
  UserModel user;
  HomeDorw({super.key,required this.user});
  List<DormitoryHistory> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection('School').doc(user.schoolid).collection('Dormitory').snapshots(),
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
            list = data.map<DormitoryHistory>((doc) {
              return DormitoryHistory.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
            return ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUser(
                  user: list[index],
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
class ChatUser extends StatelessWidget {
  DormitoryHistory user;
  ChatUser({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            user.pic
          ),
        ),
        title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
        subtitle: Text(user.inTime+" from College"),
        trailing: Text(convertMillisecondsToTime(user.id),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
      ),
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
}

class DormitoryHistory {
  String id;
  String name;
  String pic;
  String inTime; // Stored as milliseconds since epoch (String)
  int day;
  int month;
  int year;

  DormitoryHistory({
    required this.id,
    required this.name,
    required this.pic,
    required this.inTime,
    required this.day,
    required this.month,
    required this.year,
  });

  // Factory constructor to create an instance from a JSON object
  factory DormitoryHistory.fromJson(Map<String, dynamic> json) {
    return DormitoryHistory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pic: json['pic'] ?? '',
      inTime: json['in'] ?? '',
      day: json['day'] ?? 0,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pic': pic,
      'in': inTime,
      'day': day,
      'month': month,
      'year': year,
    };
  }
}
