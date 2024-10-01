import 'package:flutter/material.dart';
import 'package:student_managment_app/bus/function/edit.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/bus.dart';

class Timings extends StatelessWidget {
  BusModel bus;
   Timings({super.key,required this.bus});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF6BA24),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close,color: Colors.black,)),
        title: Text("Timings",style: TextStyle(color: Colors.black),),),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Center(child: Icon(Icons.calendar_month,color: Colors.blueAccent,size: 45,)),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18),
            child: Container(
              width: w,
              child: Text(bus.timing2,textAlign: TextAlign.left),
            ),
          ),
          SizedBox(height: 20,),
          bus.iseditable?InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    BusEdit(id: bus.id, docid: "timing2", name: bus.name, isdesc: true, what: "Bus Timing",)));
              },
              child: Center(child: Send.se(w, "Edit Timing"))):SizedBox(),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}
