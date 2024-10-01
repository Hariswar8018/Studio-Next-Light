import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class Student_Data_Update extends StatelessWidget {

  String school_id;
  String session_id;
  String class_id;
  String student_id;
  String to_change;
  String change_change ;
  String pic ;


  Student_Data_Update({ required this.class_id, required this.session_id, required this.pic,
  required this.school_id, required this.student_id, required this.change_change, required this.to_change
  });
  final TextEditingController Admission = TextEditingController();

  final TextEditingController Registration = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color : Colors.white,
          ),
          title : Text("Update $change_change", style : TextStyle(color : Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
        body : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(pic),
                  radius: 40,
                ),
              ),
            ),
            SizedBox(height : 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text( textAlign: TextAlign.center, "Please type new $change_change for the Student")),
            ),
            d( Admission, "His New $change_change" , "AN000123", false,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                backgroundColor:  Color(0xff50008e),
                height: 40,
                text: 'Update $change_change',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  CollectionReference collection = FirebaseFirestore.instance.collection('School').doc(school_id).collection('Session').doc(session_id).collection('Class').doc(class_id).collection("Student");
                  if ( change_change == "Fees" ){
                    int gst = int.tryParse(Admission.text) ?? 0;
                    await collection.doc(student_id).update({
                      "$to_change" : gst,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! Updating ! It may take a While'),
                      ),
                    );
                    Navigator.pop(context);
                  }else{
                    await collection.doc(student_id).update({
                      "$to_change" : Admission.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success ! Updating ! It may take a While'),
                      ),
                    );
                    Navigator.pop(context);
                  }

                },
              ),
            ),
          ],
        )
    );
  }
  Widget d( TextEditingController c , String label, String hint, bool number,  ){
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: change_change == "Fees" ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }
}
