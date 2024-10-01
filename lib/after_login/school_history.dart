import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/session_school.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/super_admin/superhome.dart';

class Order_K extends StatelessWidget {
  String s ;
  String name;
  String school_id ;
  Order_K({super.key, required this.s, required this.name, required this.school_id});
  List<OrderModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        title : Text("$name", style : TextStyle(color : Colors.white)),
        backgroundColor:  Color(0xff50008e),
      ),
      body : StreamBuilder(
        stream: Fire.collection('Admin').doc('Order').collection(s).where("School", isEqualTo : school_id).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => OrderModel.fromJson(e.data())).toList() ??
                      [];
              if(list.isEmpty){
                return Column(
                  children : [
                    Image.network("https://img.freepik.com/premium-vector/happy-cute-boy-carry-wrong-sign_97632-1364.jpg"),
                    SizedBox(height : 10),
                    Text( "Looks like there's No " + name + " for You", style : TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ]
                );
              }else {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 7),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Chat(
                      user: list[index],
                      s : s,
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class Chat extends StatelessWidget {
  OrderModel user; String s ;
  Chat({super.key, required this.user, required  this.s});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white, splashColor: Colors.orangeAccent,
      leading: s == "Orders" ? Icon(Icons.shopping_cart_rounded, color : Colors.red) :
      ( s == "Progress" ? Icon(Icons.print, color : Colors.green) : Icon(Icons.verified, color : Colors.blue)),
      title: Text("Ordered on : " + user.Time, style : TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      subtitle: Text("Class : " + user.class_name + ", Session : " + user.session_name, style : TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
    );
  }
}

