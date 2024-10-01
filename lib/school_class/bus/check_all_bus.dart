import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/anew/parents/home/portal_student.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/bus.dart';
import '../../../school_class/bus/display.dart';
class CheckAllBus extends StatelessWidget {
  String schoolid, studentid;
   CheckAllBus({super.key,required this.schoolid,required this.studentid});
  List<BusModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BusModel.color,
        title: Text("Which Bus is yours?"),
      ),
      body:  StreamBuilder(
        stream: Fire.collection('Bus').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => BusModel.fromJson(e.data()))
                  .toList() ??
                  [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Lis(bus:list[index]);
                },
              );
          }
        },
      ),
    );
  }
}
class Lis extends StatefulWidget {
  BusModel bus;
  Lis({super.key,required this.bus});

  @override
  State<Lis> createState() => _LisState();
}

class _LisState extends State<Lis> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: ()async{
              try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final String id = prefs.getString('school') ?? "None";
                final String clas = prefs.getString('class') ?? "None";
                final String session = prefs.getString('session') ?? "None";
                final String regist = prefs.getString('id') ?? "None";
                FirebaseFirestore.instance.collection('School')
                    .doc(id)
                    .collection('Session')
                    .doc(session)
                    .collection("Class")
                    .doc(clas)
                    .collection("Student").doc(regist).update({
                  "busid": widget.bus.id,
                });
                FirebaseFirestore.instance.collection('School')
                    .doc(id)
                    .collection('Session')
                    .doc(session)
                    .collection("Students").doc(regist).update({
                  "busid": widget.bus.id,
                });
                mybusid = widget.bus.id;
                setState(() {

                });
                Send.message(context, "Success", true);
              }catch(e){
                Send.message(context, "$e", false);
              }
            },
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/newportal/bus-svgrepo-com.svg",
                semanticsLabel: 'Acme Logo',
                height: 50,
              ),
            ),
            title: Text("Bus Name "+widget.bus.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
            subtitle:Text("Bus Timing "+widget.bus.timing,style: TextStyle(fontSize: 7,fontWeight: FontWeight.w400),) ,
            trailing: widget.bus.id==mybusid?Text("Sent for Access"):Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("This Bus",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19.0,bottom: 8),
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ViewRouteScreen(id:widget.bus.id,edit:false)),
                );
              },
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(2)
                ),
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Verify Route >",style: TextStyle(color: Colors.white),),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
