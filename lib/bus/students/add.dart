import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:student_managment_app/model/bus.dart';
import 'package:student_managment_app/model/student_model.dart';
import 'package:student_managment_app/bus/students/select.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddS extends StatelessWidget {
  String id;String busid;BusModel buss;
  AddS({super.key,required this.id,required this.busid,required this.buss});
  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();
  TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Container(
          width : MediaQuery.of(context).size.width  , height : 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left : 18.0, right : 10),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,  hintText: "Search Students",
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
      ),
      body:_controller.text.isEmpty?StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School')
            .doc(id)
            .collection('Students')
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => StudentModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                        user: list[index],
                        id : id,busid: busid,
                      buss: buss,
                    );
                  });
          }
        },
      ):StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School')
            .doc(id)
            .collection('Students').where("Name",isGreaterThanOrEqualTo: _controller.text)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => StudentModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                        user: list[index],
                        id : id,busid:busid,buss: buss,
                    );
                  });
          }
        },
      ),
    );
  }
}


class ChatUser extends StatefulWidget {
  StudentModel user; String id ;
  BusModel buss;
String busid;
  ChatUser({
    super.key,
    required this.user, required this.id,required this.busid,required this.buss,
  });

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        if(widget.user.busid.isNotEmpty){
          if(widget.user.busid!=widget.busid){
            Send.message(context, "Not From your Bus", false);
            return ;
          }
        }
        if(widget.user.busid.isEmpty||!(widget.user.bus)){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Students to Bus"),
                content: Text("Add Students to the Bus and timing to it"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      if(widget.user.latitude==0.0||widget.user.longitude==0.0){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select Location"),
                              content: Text("Student don't have Real Location ! Select in Map"),
                              actions: [
                                TextButton(
                                  onPressed: () {

                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text("CANCEL"),
                                ),
                                TextButton(
                                  onPressed: ()async {
                                    LatLng yes =await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationPicker(onLocationPicked: (LatLng location) {

                                        },),
                                      ),
                                    );
                                    as(yes.latitude, yes.longitude);
                                  },
                                  child: Text("YES"),
                                ),
                              ],
                            );
                          },
                        );
                      }else{
                        as(widget.user.latitude, widget.user.longitude);
                      }
                    },
                    child: Text("YES"),
                  ),
                ],
              );
            },
          );
        }else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Remove Students to Bus"),
                content: Text("Remove Students to the Bus"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ass();
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("YES"),
                  ),
                ],
              );
            },
          );
        }

      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.pic),
      ),
      trailing:widget.user.bus? CircleAvatar(
        backgroundColor: Colors.blue,
        child: Center(
          child: Icon(Icons.bus_alert_rounded,color: widget.user.busid==widget.busid?Colors.white:Colors.red),
        ),
      ):SizedBox(),
      title: Text(widget.user.Name, style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Future<void> as(double lat,double lon)async{
    try {
     await FirebaseFirestore.instance.collection("School").doc(widget.id).collection("Students").doc(widget.user.Registration_number).update({
       "busid":widget.buss.id,
       "bus":true,
       "busout":true,
       "busin":widget.buss.id,
       "latitude":lat,
       "longitude":lon,
     });
     await FirebaseFirestore.instance.collection("Bus").doc(widget.busid).update({
       "people":FieldValue.arrayUnion([widget.user.Registration_number]),
       "tokens":FieldValue.arrayUnion([widget.user.token]),
     });
      Navigator.pop(context);
      Send.message(context, "$lat $lon", true);
      print(lon);
    }catch(e){
      Send.message(context, "$e", true);
    }
  }

  Future<void> ass()async{
    try {
      await FirebaseFirestore.instance.collection("School").doc(widget.id).collection("Students").doc(widget.user.Registration_number).update({
        "busid":"",
        "bus":false,
        "busout":false,
        "busin":"",
      });
      await FirebaseFirestore.instance.collection("Bus").doc(widget.busid).update({
        "people":FieldValue.arrayRemove([widget.user.Registration_number]),
        "tokens":FieldValue.arrayRemove([widget.user.token]),
      });
      Send.message(context, "Removed", true);
    }catch(e){
      Send.message(context, "$e", true);
    }
  }
}