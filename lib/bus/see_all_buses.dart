import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/anew/parents/home/portal_student.dart';
import 'package:student_managment_app/bus/bus_card.dart';
import 'package:student_managment_app/bus/function/details.dart';
import 'package:student_managment_app/bus/function/timings.dart';
import 'package:student_managment_app/bus/make_route.dart';
import 'package:student_managment_app/bus/students/add.dart';
import 'package:student_managment_app/bus/track/track.dart';
import 'package:student_managment_app/classroom_universal/timetable.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/bus.dart';
import '../../../school_class/bus/display.dart';
class CheckAllBus1 extends StatelessWidget {
  String schoolid, studentid;
  CheckAllBus1({super.key,required this.schoolid,required this.studentid});
  List<BusModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BusModel.color,
        title: Text("All Buses"),
      ),
      body:  StreamBuilder(
        stream: Fire.collection('Bus').where("number",isEqualTo: schoolid).snapshots(),
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
                  return Lis(bus:list[index],schoolid: schoolid,);
                },
              );
          }
        },
      ),
    );
  }
}
class Lis extends StatefulWidget {
  BusModel bus;String schoolid;
  Lis({super.key,required this.bus,required this.schoolid});

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
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child:BusDetails(bus: widget.bus, id: widget.schoolid,),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 10)));
            },
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/newportal/bus-svgrepo-com.svg",
                semanticsLabel: 'Acme Logo',
                height: 50,
              ),
            ),
            title: Text("Bus Name : "+widget.bus.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
            subtitle:Text("Route : "+widget.bus.routeId,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),) ,
            trailing: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.bus.people.length.toString(),style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:ViewRouteScreen(id: widget.bus.id,edit:true),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 10)));
                  },
                  child: r("Route")),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:BusDetails(bus: widget.bus,id: widget.schoolid),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 10)));
                  },
                  child: r("Bus Info")),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:Timings(bus: widget.bus),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 10)));
                  },
                  child: r("Timings")),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:TrackBus(id: widget.bus.id,edit:true, bus: widget.bus,),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 10)));
                  },
                  child: r("Track")),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:AddS(id: widget.schoolid, busid: widget.bus.id, buss: widget.bus,),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 10)));
                  },
                  child: r("Check/Add Students")),
            ],
          ),
          SizedBox(height: 15,)
        ],
      ),
    );
  }
  Widget r(String s1)=>Container(
    decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(2)
    ),
    child: Center(child: Padding(
      padding: const EdgeInsets.only(bottom: 6.0,top: 6,left: 22,right: 22),
      child: Text(s1,style: TextStyle(color: Colors.white,fontSize: 14),),
    )),
  );
}
