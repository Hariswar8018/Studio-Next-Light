
import 'package:flutter/material.dart';
import 'package:studio_next_light/model/student_model.dart';

class StudentProfileN extends StatelessWidget {

  StudentModel user;
  StudentProfileN(
      {super.key,
        required this.user,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.Name),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.pic),
                  radius: 120,
                ),
              ),
            ),
            SizedBox(height: 10),
             s("Name", user.Name, false, true),
             s("Father Name", user.Father_Name, true, true),
            user.Mother_Name == " " ? s("Mother Name", user.Mother_Name, false, true): SizedBox(),
            user.BloodGroup == " " ? s("Blood Group", user.BloodGroup, true, true) : SizedBox(),
            s("Mobile", user.Mobile.toString(), false, true),
            user.Email == " " ?  s("Email", user.Email, true, true) : SizedBox(),
            SizedBox(height: 20),
            user.Admission_number == " " ? s("Admission Number", user.Admission_number, false, true): SizedBox(),
            s("Registration Number", user.Registration_number, true, true),
            s("ID", user.id, false, true),
            s("Session", user.Session, true, true),
            s("Roll Number", user.Roll_number.toString(), false, true),
            SizedBox(height: 20),
            s("Batch", user.Batch, true,true),
            s("Class", user.Class, false, true),
            s("Section", user.Section, true, true),
            user.Department == " " ? s("Department", user.Department, false, true): SizedBox(),
             s("Address", user.Address, true, true),
          ],
        ),
      ),
    );
  }

  Widget s(String s, String n, bool b, bool j) {
    return ListTile(
      leading: Icon(Icons.circle, color: Colors.black, size: 20),
      title: Text(s + " :"),
      trailing:
      Text(n, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      splashColor: Colors.orange.shade300,
      tileColor: b ? Colors.grey.shade50 : Colors.white,
    );
  }
}
