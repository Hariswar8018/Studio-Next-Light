import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class On_Off extends StatefulWidget {
  bool EmailB;
  bool BloodB;
  bool DepB;
  bool MotherB;
  bool RegisB;
  bool Other1B;
  bool Other2B;
  bool Other3B;
  bool Other4B;
  String school_id;
   On_Off({super.key, required this.EmailB, required this.RegisB, required this.Other4B, required this.Other3B,
    required this.Other2B, required this.Other1B, required this.MotherB, required this.DepB, required this.school_id, required this.BloodB
  });

  @override
  State<On_Off> createState() => _On_OffState();
}

class _On_OffState extends State<On_Off> {
  bool EmailB = true ;
  bool BloodB = true ;
  bool DepB = true ;
  bool MotherB = true ;
  bool RegisB = true ;
  bool Other1B = true ;
  bool Other2B = true ;
  bool Other3B = true ;
  bool Other4B = true ;
  void initState(){
    EmailB = widget.EmailB ;
    BloodB= widget.BloodB ;
    DepB = widget.DepB ;
    MotherB = widget.MotherB ;
    RegisB = widget.RegisB ;
    Other1B = widget.Other1B ;
    Other2B = widget.Other2B ;
    Other3B = widget.Other3B ;
    Other4B = widget.Other4B ;
  }

  bool b = true ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("On / Off Student Data for Edit"),
      ),
      body : SingleChildScrollView(
        child: Column(
          children: [
            bhh("Name"),
            bhh("Admission Number"),
            bhh("Mobile"),
            bhh("Class & Section"),
            bhh("DOB"),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Email"),
              trailing:  Switch(
                value: EmailB,
                onChanged: (value) async {
                  if(EmailB){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "EmailB" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! Now NO Teacher could Upload Data from this School'),
                      ),
                    );
                    setState(() {
                      EmailB = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "EmailB" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! Now Every Institution could Upload Data from this School'),
                      ),
                    );
                    setState(() {
                      EmailB = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Blood Group"),
              trailing:  Switch(
                value: BloodB,
                onChanged: (value) async {
                  if(BloodB){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "BloodB" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      BloodB = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "BloodB" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      BloodB = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Department"),
              trailing:  Switch(
                value: DepB,
                onChanged: (value) async {
                  if(DepB){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "DepB" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      DepB = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "DepB" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      DepB = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            bhh("Father\s Name"),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Mother Name"),
              trailing:  Switch(
                value: MotherB,
                onChanged: (value) async {
                  if(MotherB){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "MotherB" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      MotherB = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "MotherB" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      MotherB = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Registration Name"),
              trailing:  Switch(
                value: RegisB,
                onChanged: (value) async {
                  if(RegisB){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "RegisB" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      RegisB = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "RegisB" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      RegisB = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            bhh("Address"),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Other 1"),
              trailing:  Switch(
                value: Other1B,
                onChanged: (value) async {
                  if(Other1B){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other1B" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      Other1B = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other1B" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      Other1B = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Other 2"),
              trailing:  Switch(
                value: Other2B,
                onChanged: (value) async {
                  if(Other2B){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other2B" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      Other2B = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other2B" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      Other2B = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Other 3"),
              trailing:  Switch(
                value: Other3B,
                onChanged: (value) async {
                  if(Other3B){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other3B" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      Other3B = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other3B" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      Other3B = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade50 ,
              leading: Icon(Icons.toggle_on_outlined, color : Colors.pinkAccent),
              title: Text("Other 4"),
              trailing:  Switch(
                value: Other4B,
                onChanged: (value) async {
                  if(Other4B){
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other4B" : false,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some time'),
                      ),
                    );
                    setState(() {
                      Other4B = value ;
                    });
                  }else{
                    CollectionReference collection = FirebaseFirestore.instance.collection('School');
                    await collection.doc(widget.school_id).update({
                      "Other4B" : true,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! It would take some Time'),
                      ),
                    );
                    setState(() {
                      Other4B = value ;
                    });
                  }
                }, activeColor: Colors.green,
              ),
            ),
          ],
        ),
      )
    );
  }
  Widget bhh(String s ){
    return ListTile(
      tileColor: Colors.grey.shade50 ,
      leading: Icon(Icons.circle,color: Colors.black, size: 20),
      title: Text(s),
      trailing:  Switch(
        value: b,
        onChanged: (value) async {

        }, activeColor: Colors.red,
      ),
    );
  }

}
