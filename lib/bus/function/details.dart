import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/bus/function/edit.dart';
import 'package:student_managment_app/bus/function/timings.dart';
import 'package:student_managment_app/bus/students/add.dart';

import 'package:student_managment_app/model/bus.dart';


class BusDetails extends StatelessWidget {
  BusModel bus;String id;
  BusDetails({super.key,required this.bus,required this.id});

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
        title: Text("Bus Details",style: TextStyle(color: Colors.black),),),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: w,height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/busgif.gif"))
              ),
            ),
            SizedBox(height: 20,),
            r(bus.iseditable, "Bus Name", bus.name,context,"name"),
            r(bus.iseditable, "Bus RouteId", bus.routeId,context,"routeId"),
            r(false, "Bus ID", bus.uid,context,""),
            r(false, "School ID", bus.number,context,""),
            r(false, "School Name", bus.schoolname,context,""),
            r(false, "Default Session", bus.sessionid,context,""),
            r(bus.iseditable, "Bus Timings", bus.timing,context,"timing",on: true,f:true),
            r(bus.couldadd, "Bus Persons", bus.people.length.toString(),context,"bus",on:true),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Text("Description",style: TextStyle(fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      BusEdit(id: bus.id, docid: "timing2", name: bus.name, isdesc: false, what: "Description",)));
                },
                child: Container(
                  width: w,
                  child: Text(bus.timing2,textAlign: TextAlign.left),
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
  int i=0;
  Widget r(bool editable,String str, String str2,BuildContext context,String strf3,{bool on=false,bool f=false}){
    i+=1;
    return on?ListTile(
      onTap: (){
        if(!editable){
          return ;
        }
        if(f){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              Timings(bus:bus)));
        }else if(strf3=="bus"){
          Navigator.push(
              context,
              PageTransition(
                  child:AddS(id: id, busid: bus.id, buss: bus,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 10)));
        }
      },
      tileColor: i%2==0?Colors.white:Colors.grey.shade100,
      leading: Icon(Icons.square_sharp),
      title: Text(str),
      trailing:editable? Icon(Icons.arrow_forward_ios_outlined,color: Colors.blueAccent,):SizedBox(),
    ):ListTile(
      onTap: (){
        if(editable){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              BusEdit(id: bus.id, docid: strf3, name: bus.name, isdesc: false, what: str,)));
        }
      },
      tileColor: i%2==0?Colors.white:Colors.grey.shade100,
      leading: editable?Icon(Icons.edit):Icon(Icons.circle),
      title: Text(str),
      trailing: Text(str2,style: TextStyle(color: Colors.black),),
    );
  }
}
