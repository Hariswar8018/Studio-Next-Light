import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/function/send.dart';


class BusEdit extends StatelessWidget {
  String id, docid,name, what;bool isdesc;
   BusEdit({super.key,required this.id,required this.docid,required this.name,required this.what,required this.isdesc});
   TextEditingController str=TextEditingController();
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
        title: Text("Edit $name's $what",style: TextStyle(color: Colors.black),),),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Center(
            child: Container(
              width: w-10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
                child: TextField(
                  controller: str,
                  keyboardType:TextInputType.name,
                  textAlign: TextAlign.left,
                  minLines: 4,maxLines: 17,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Enter $what",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          InkWell(
              onTap: () async {
                try{
                  await FirebaseFirestore.instance.collection("Bus").doc(id).update({
                    docid:str.text,
                  });
                  Navigator.pop(context);
                  Send.message(context, "Updated in few Minutes", true);
                }catch(e){
                  Send.message(context, "$e", false);
                }
              },
              child: Center(child: Send.se(w, "Save $what"))),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}
