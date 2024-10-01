
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/anew/parents/two_factor_authenticate.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/student_model.dart';

class FindParentSchool extends StatefulWidget {
  bool student;
  FindParentSchool({super.key,required this.student});

  @override
  State<FindParentSchool> createState() => _FindParentSchoolState();
}

class _FindParentSchoolState extends State<FindParentSchool> {
  final _emailController = TextEditingController();

  bool Stream=false;
  String photo="",name="",address="";
  String id="g",session="bjh";

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Stream?Scaffold(
      backgroundColor:Colors.white,
      body:Center(child: Image.asset("assets/images/login/search.gif")),
    ):Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
            ),
          ),
        ),
        title: Text("Find School"),
      ),
      body: Container(
        width: w,height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90,),
            Center(
              child: Container(
                  width:w-40,height:300,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          image:AssetImage("assets/images/login/search2.gif"),
                          fit: BoxFit.contain
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text("Search by UDISE of School",
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text("Find the School by Typing UDISE of School",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 12,),
            name.isEmpty?Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'School UDISE',  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your School email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {

                },
              ),
            ):Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(photo),
                      radius: 30,
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text(address,
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                      ],
                    ),
                    Spacer(),
                    "ST"=="ST"? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                      ),
                    ):SizedBox(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            InkWell(
              onTap: () async {
                setState(() {
                  Stream=true;
                });
                if(name.isEmpty) {
                  try {
                    CollectionReference usersCollection = FirebaseFirestore
                        .instance.collection('School');
                    QuerySnapshot querySnapshot = await usersCollection.where(
                        'UIDSE', isEqualTo: _emailController.text).get();
                    if (querySnapshot.docs.isNotEmpty) {
                      SchoolModel user = SchoolModel.fromSnap(
                          querySnapshot.docs.first);
                      Send.message(context, "Found ${user.Name}",true);
                      setState(() {
                        Stream = false;
                        photo = user.Pic_link;
                        name = user.Name;
                        address = user.Address;
                        id = user.id;
                        session = user.csession;
                      });
                    } else {
                      Send.message(
                          context, "No School found with Current UDISE",false);
                      setState(() {
                        Stream = false;
                      });
                    }
                  } catch (e) {
                    print("Error fetching user by uid: $e");
                    Send.message(context, "${e}",false);
                    setState(() {
                      Stream = false;
                    });
                  }
                }else{
                  Navigator.push(
                      context,
                      PageTransition(
                          child:ClassP(b: widget.student,id: id,session_id: session,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 10)));
                }
              },
              child: Center(
                child: Container(
                  height:45,width:w-20,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(7),
                    color:Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                        spreadRadius: 5, // The extent to which the shadow spreads
                        blurRadius: 7, // The blur radius of the shadow
                        offset: Offset(0, 3), // The position of the shadow
                      ),
                    ],
                  ),
                  child: Center(child: Text(name.isEmpty?"Search School":"Confirm this School",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RobotoS",fontWeight: FontWeight.w800
                  ),)),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Container(
                width: w-100,height: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login/design.png"),
                    )
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}


class ClassP extends StatelessWidget {
  String id;
  String session_id;
  bool b ;

  ClassP({super.key, required this.id, required this.session_id, required this.b});

  List<SessionModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ),
        title: Text("Choose Class",style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School').doc(id).collection('Session').doc(session_id).collection("Class").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => SessionModel.fromJson(e.data()))
                  .toList() ??
                  [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(bottom : 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index], id: id, sessionid: session_id,
                    b : b,
                  );
                },
              );
          }
        },
      ),

    );
  }
}

class ChatUser extends StatelessWidget {
  SessionModel user;
  String id ;
  String sessionid;
  bool b;
  ChatUser({super.key, required this.user, required this.id, required this.sessionid, required this.b});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Class "+user.Name+" ( "+user.section+" )",style: TextStyle(fontWeight: FontWeight.w500),),
      subtitle: Text("Total Students : "+user.total.toString(),style: TextStyle(fontSize:9,fontWeight: FontWeight.w400,color:Colors.grey),),
      onTap: () {
        Navigator.push(
            context, PageTransition(
            child: StudentsP(id: id, session_id: sessionid, class_id: user.id, b : b), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
        ));
      },
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.blue,
        size: 20,
      ) ,
      splashColor: Colors.orange.shade100,
      tileColor: Colors.white,
    );
  }
}

class SessionModel {
  SessionModel({
    required this.Name,
    required this.id,required this.sset,
    required this.feet,
    required this.status,
    required this.total ,
    required this.Total_Fee,
    required this.MTF,
    required this.Ad_Fee,
    required this.DevF,
    required this.ExamF,
    required this.TutionF,
    required this.MonthlyF,
    required this.LetF,
    required this.TransportF,
    required this.ID_Card_Fee,
    required this.section,
  });

  late final String Name;
  late final int feet;
  late final String id;
  late final String section ;
  late final String status;
  late final int total ;
  late final String Total_Fee;
  late final String MTF;
  late final String Ad_Fee;
  late final String DevF;
  late final String ExamF;
  late final String TutionF;
  late final int pcount ;
  late final String MonthlyF;
  late final String LetF;
  late final String TransportF;
  late final String ID_Card_Fee;
  late final int sset ;
  late final String ou;
  SessionModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? 'samai';
    ou=json['ou']??"h";
    sset = json['sset'] ?? 0;
    pcount = json['pcount'] ?? 0;
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    status = json['status'] ?? "Still Uploading";
    total = json['total'] ?? 0 ;
    Total_Fee = json['Total_Fee'] ?? "";
    MTF = json['MTF'] ?? "";
    feet = json['feet'] ?? 0 ;
    Ad_Fee = json['Ad_Fee'] ?? "";
    DevF = json['DevF'] ?? "";
    ExamF = json['ExamF'] ?? "";
    section = json["S"] ?? "A";
    TutionF = json['TutionF'] ?? "";
    MonthlyF = json['MonthlyF'] ?? "";
    LetF = json['LetF'] ?? "";
    TransportF = json['TransportF'] ?? "";
    ID_Card_Fee = json['ID_Card_Fee'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['S'] = section ;
    data['status'] = status;
    data['id'] = id ;
    data['feet'] = feet ;
    data['Total_Fee'] = Total_Fee;
    data['MTF'] = MTF;
    data['Ad_Fee'] = Ad_Fee;
    data['DevF'] = DevF;
    data['ExamF'] = ExamF;
    data['TutionF'] = TutionF;
    data['sset'] = sset ;
    data['MonthlyF'] = MonthlyF;
    data['LetF'] = LetF;
    data['TransportF'] = TransportF;
    data['ID_Card_Fee'] = ID_Card_Fee;
    data['total'] = total ;
    return data;
  }
}



class StudentsP extends StatelessWidget {
  String id;
  String session_id;
  String class_id;

  bool b;

  StudentsP(
      {super.key,
        required this.id,
        required this.session_id,
        required this.class_id,
        required this.b});

  List<StudentModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation:0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.blue,size: 22,)),
            ),
          ),
        ),
        title: Text("Choose Student",style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: Fire.collection('School')
            .doc(id)
            .collection('Session')
            .doc(session_id)
            .collection("Class")
            .doc(class_id)
            .collection("Student").orderBy("Name",descending:false)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data
                  ?.map((e) => StudentModel.fromJson(e.data()))
                  .toList() ??
                  [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUserr(
                    user: list[index],
                    c : class_id,
                    s : session_id,
                    school: id,
                    b : b,
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class ChatUserr extends StatelessWidget {
  bool b ;
  String c;
  String s;
  String school;
  StudentModel user;

  ChatUserr({super.key, required this.user, required this.school, required this.s ,required this.c, required this.b});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text("Roll no : " +
          user.Roll_number.toString() +
          "   " +
          user.Class +
          user.Section
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: TwoFactorAuthenticate(u: user, student:b, id: school, sessionid: s, classid: c,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 10)));
      },
      trailing: Icon(Icons.verified_user_rounded,color: Colors.green,),
      splashColor: Colors.orange.shade100,
      tileColor: Colors.grey.shade50,
    );
  }
}

