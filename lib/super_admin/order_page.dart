import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/session_school.dart';
import 'package:student_managment_app/model/orders_model.dart';
import 'package:student_managment_app/super_admin/superhome.dart';

class Order_J extends StatelessWidget {
  String s ;
  String name;
  Order_J({super.key, required this.s, required this.name});
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
        stream: Fire.collection('Admin').doc('Order').collection(s).snapshots(),
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
    return Card(
      color: s == "Orders" ? Colors.red.shade200 : ( s == "Complete" ? Colors.blue.shade200 : Colors.green.shade300)  ,
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onDoubleTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Change Order ?'),
                  content: Text('Change the Order Status Now, Please Confirm It once again'),
                  actions: <Widget>[
                    s != "Progress" || s == "Complete"? TextButton(
                      onPressed: () async {
                        try{
                          await change("Id in Progress"); // change in Session
                          await adding("Progress"); // Adding to new var
                          await delete(s); // del the order
                          await add1("PR", "OR"); //Add + Remove
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Order will be marked In Progress"),
                            ),
                          );
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$e'),
                            ),
                          );
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text('ID CARD in Progress'),
                    ) : SizedBox(),
                    s != "Complete" ? TextButton(
                      onPressed: () async {
                        await change("Id Done"); // change in Session
                        await adding("Complete"); // Adding to new var
                        await delete(s); // del the order
                        await add1("CO", "PR"); //Add + Remove
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Order will be marked Done"),
                          ),
                        );
                        await FirebaseFirestore.instance.collection("School").doc(user.School_id).update({
                          'Complete': FieldValue.increment(user.num),
                          'Pending' : FieldValue.increment(-user.num),
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('ID CARD Done'),
                    ) : SizedBox(),
                    TextButton(
                      onPressed: () async {
                        await change("Shipped");
                        await FirebaseFirestore.instance.collection("School").doc(user.School_id).update({
                          'Receive': FieldValue.increment(user.num),
                          'Complete' : FieldValue.increment(-user.num),
                        }); //Update School Panel
                      },
                      child: Text('ID CARD shipped'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("School Name : " + user.School_Name, style : TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                    Spacer(),
                    Icon(Icons.supervised_user_circle_rounded),SizedBox(width : 5), Text(user.num.toString())
                  ],
                ),
                Text("Session : " + user.session_name, style : TextStyle(fontWeight: FontWeight.w700)),
                Text("Class : " + user.class_name, style : TextStyle(fontWeight: FontWeight.w700)),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ordered on : " + user.Time, style : TextStyle(fontWeight: FontWeight.w700)),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SessionP(id: user.School_id, b: true,),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 400)));
                        }, child : Text("Check >"),)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> change(String status) async {
    try{
    CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(user.School_id).collection('Session').doc(user.session_id).collection('Class');
    await collection.doc(user.class_id).update({
      'status' : status,
      // Add more fields as needed
    });
    }catch(e){
      print(e);
    }
  }

  Future<void> adding(String coll_name) async {
    try{
      OrderModel s = OrderModel(
          School_id: user.School_id,
          session_id: user.session_id,
          class_id: user.class_id,
          class_name: user.class_name,
          session_name: user.session_name,
          status: "In Progress",
          School_Name: user.School_Name,
          Time: user.Time, num: user.num);
      CollectionReference collectionn = FirebaseFirestore.instance.collection('Admin').doc("Order").collection(coll_name);
      await collectionn.doc(user.Time).set(s.toJson());
    }catch(e){
      print(e);
    }

  }

  Future<void> delete(String coll_name) async {
    try{
    CollectionReference collectionnn = FirebaseFirestore.instance.collection('Admin').doc("Order").collection(coll_name);
    await collectionnn.doc(user.Time).delete();
    }catch(e){
      print(e);
    }
  }

  Future<void> add1(String toa, String tod) async {
    try{
    CollectionReference collectionn = FirebaseFirestore.instance.collection('Admin');
    await collectionn.doc("Order").update(
      {
        "$toa" : FieldValue.arrayUnion([user.Time]),
        "$tod" : FieldValue.arrayRemove([user.Time]),
      }
    );}catch(e){
      print(e);
    }
  }



}

