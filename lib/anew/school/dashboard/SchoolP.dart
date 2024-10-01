import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/admin/onoff.dart';
import 'package:student_managment_app/model/school_model.dart';

class SchoolP extends StatefulWidget {
  SchoolModel user;
  SchoolP({super.key,required this.user});

  @override
  State<SchoolP> createState() => _SchoolPState();
}

class _SchoolPState extends State<SchoolP> {
  int prc = 0;
  void countp() async {
    int totalMfValue = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
          .collection('Session')
          .doc(widget.user.csession).collection("Class").get();
      // Iterate over each document in the collection
      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if the document contains the 'Mf' field
          if (data.containsKey('pcount')) {
            // Get the value of the 'Mf' field and add it to the totalMfValue
            dynamic mfValue = data['pcount'];
            if (mfValue is int) {
              totalMfValue += mfValue;
            } else if (mfValue is double) {
              totalMfValue += mfValue.toInt();
            }else{
              totalMfValue += int.parse(mfValue) ;
            }
          }
        }
      });
      setState(() {
        prc = totalMfValue;
      });
      print("Total value of 'Mf' across all documents: $totalMfValue");
    } catch (error) {
      print("Error counting total 'Mf' value: $error");
    }
  }
  void initState() {
    countp();
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: NetworkImage(widget.user.Pic_link)),
        ),
        title: Text(widget.user.Name+" Profile"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.start,
            children:[
              Container(
                height: 200,
                width: w,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: w,
                      child:Container(
                        height: 100,
                        width: w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.user.Pic),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: w,
                      child: Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.start,
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0,bottom: 16),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(widget.user.Pic_link),
                              radius: 45,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.black, size: 20),
                title: Text("Students Functions "),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => On_Off(
                        EmailB: widget.user.EmailB,
                        RegisB: widget.user.RegisB,
                        Other4B: widget.user.Other4B,
                        Other3B: widget.user.Other3B,
                        Other2B: widget.user.Other2B,
                        Other1B: widget.user.Other1B,
                        MotherB: widget.user.MotherB,
                        DepB: widget.user.DepB,
                        BloodB: widget.user.BloodB,
                        school_id: widget.user.id,
                      ),
                    ),
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),
                splashColor: Colors.orange.shade300,
                tileColor: Colors.white,
              ),
              s("School Name", widget.user.Name, false, false),
              s("Your Mail", widget.user.Adminemail, true, true),
              s("School Login Email", widget.user.Clientemail, false, false),
              s("School Support Email", widget.user.Email, true, false),
              s("Chief Coordinator Name", widget.user.Chief, false, false),
              s("UIDISE Code", widget.user.uidise, false, false),
              s("Address", widget.user.Address, false, false),
              s("Special Access Password", widget.user.SpName, false, false),
              s("Phone", widget.user.Phone, false, false),
              s("No. of Students in School", widget.user.Students.toString(), false, false),
              s("Pending Data", (widget.user.Students-prc).toString(), true, true),
              s("Total Students in App", prc.toString(), true, true),
              s("Authorize Signature here ", " ", false, true),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.network(widget.user.AuthorizeSignature),
              ),
            ]
        ),
      ),
    );
  }

  Widget s(String s, String n, bool b, bool f) {
    return ListTile(
      title: Text(s + " :"),
      trailing:
      Text(n, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      splashColor: Colors.orange.shade300,
      tileColor: b ? Colors.grey.shade50 : Colors.white,
    );
  }
}
