import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Portal/as.dart';

import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/loginnow_function/profile.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/model/usermodel.dart';
import 'package:student_managment_app/school_class/class/classH.dart';
import 'package:student_managment_app/school_class/class/classP.dart';
import 'package:student_managment_app/school_class/class/classc.dart';

const List<TabItem> items = [
  TabItem(
      icon: Icons.dashboard,
      title: "Home"
  ),
  TabItem(
    icon: Icons.calculate_rounded,
    title: 'Academics',
  ),
  TabItem(
    icon: Icons.face_unlock_outlined,
    title: 'Structure',
  ),
  TabItem(
    icon: Icons.person,
    title: 'Profile',
  ),
];

class ClassHome extends StatefulWidget {
  UserModel user;

   ClassHome({super.key,required this.user});

  @override
  State<ClassHome> createState() => _ClassHomeState();
}

class _ClassHomeState extends State<ClassHome> {
  int visit = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return widget.user.schoolid.isEmpty || !widget.user.probation ? Scaffold(
      drawer:Global.buildDrawer(context),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff029A81),
        leading:InkWell(
          onTap:() {
            _scaffoldKey.currentState?.openDrawer();  // Opens the drawer
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(Icons.more_vert,color: Color(0xff029A81),size: 22,)),
            ),
          ),
        ),
        title: Text("Class Teacher",style:TextStyle(color:Colors.white)),
      ),
      body: Column(
        children: [
          Image.asset("assets/images/school/class-teacher.jpg",width: w),
          SizedBox(height: 40,),
          InkWell(
            onTap: () async {
             await Navigator.push(
                  context, PageTransition(
                  child: FindS(st: widget.user,),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)
              ));
            },
            child: widget.user.schoolid.isEmpty?Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.user.probation?Colors.blue:Colors.grey,
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
                      radius: 30,
                      child: Icon(Icons.perm_identity_sharp,color: Colors.blue,),
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request School',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Now ask Permission from School',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('to be added as Scanner',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
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
            ):Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:Colors.blue,
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
                      radius: 30,
                      backgroundImage: NetworkImage(widget.user.pic),
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Class : "+widget.user.school,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text("Waiting for Approval from School",
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.red),),
                        Text('Do Contact if delay !',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.red),)
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
          ),
          SizedBox(height: 10,),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Container(
                width: w-30,
                height:90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: widget.user.probation?Colors.blue:Colors.grey,
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
                      backgroundColor: Colors.red,
                      radius: 30,
                    ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Complete Profile',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text('Add basic Details like Phone, Adhaar',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text('and basic other Details',
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
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
          ),
        ],
      ),
    ):Kop(user: widget.user,);
  }
}

class Kop extends StatefulWidget {
   Kop({super.key,required this.user});
  UserModel user;
  @override
  State<Kop> createState() => _KopState();
}

class _KopState extends State<Kop> {
  late SchoolModel userr;
  int visit = 0;
  void initState(){
    getUserByUid(widget.user.schoolid);
  }

  void getUserByUid(String uid) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
      QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        SchoolModel usery = SchoolModel.fromSnap(querySnapshot.docs.first);
        setState(() {
          userr=usery;
        });
      } else {
        print("chdhg");
      }
    } catch (e) {
      print("Error fetching user by uid: $e");
      print("chdhg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: as(visit),
      bottomNavigationBar: Container(
        child:  BottomBarDefault(
          items: items,
          backgroundColor: Colors.white,
          color: Colors.black,
          colorSelected: colorSelect,
          indexSelected: visit,
           onTap: (int index) => setState(() {
            visit = index;
          }),
        ),
      ),
    );
  }

  Widget as(int i ){
    if( i == 0){
      return Classh(user: userr, c: widget.user,);
    }else if(i == 1){
      return Classc(user: userr, c: widget.user,);
    }else if(i == 2){
      return Classp(c: userr, user: widget.user,);
    }else{
      return Profile(user: widget.user,);
    }
  }

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);
}




class FindS extends StatefulWidget {
  FindS({super.key,required this.st});
  UserModel st;

  @override
  State<FindS> createState() => _FindSState();
}

class _FindSState extends State<FindS> {
  final _emailController = TextEditingController();

  bool Stream=false;

  String photo="",name="",address="";
  SchoolModel user1 = SchoolModel(Address: "Address", csession: "csession", Email: "Email", Name: "Name", Pic_link: "Pic_link", Students: 0,
    Pic: "Pic", id: "id", Adminemail: "Adminemail", Clientemail: "Clientemail", Phone: "Phone", AuthorizeSignature: "AuthorizeSignature", uidise: "uidise", Chief: "Chief",
    b: false, EmailB: false, BloodB: false, DepB: false, MotherB: false, RegisB: false, Other1B: false, Other2B: false, Other3B: false, Other4B: false,
    TReceice: [], TPaid: [], TMonth: [], TYear: [], total: 0, complete: 0, pending: 0, receive: 0, premium: false,
    SpName: "SpName", totse: 0, stampp: "stampp", paidp: "paidp",
    smsend: false, weatherlastupdate: '', lon: 566, lat: 878, weather: '', wind: 0.0, temp: 0.0,
    humidity: 0.0, pressure: 0.0, j: 0, token1: '', token2: '',
  );

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
                        Text(user1.Address,
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
                if(name.isEmpty){
                  try {
                    CollectionReference usersCollection = FirebaseFirestore.instance.collection('School');
                    QuerySnapshot querySnapshot = await usersCollection.where('UIDSE', isEqualTo: _emailController.text).get();
                    if (querySnapshot.docs.isNotEmpty) {
                      SchoolModel user = SchoolModel.fromSnap(querySnapshot.docs.first);
                      Send.message(context, "Found ${user.Name}",true);
                      setState(() {
                        user1=user;
                        Stream=false;
                        photo=user.Pic_link;
                        name=user.Name;
                        address=user.Address;
                      });
                    } else {
                      Send.message(context, "No School found with Current UDISE",false);
                      setState(() {
                        Stream=false;
                      });
                    }
                  } catch (e) {
                    print("Error fetching user by uid: $e");
                    Send.message(context, "${e}",false);
                    setState(() {
                      Stream=false;
                    });
                  }
                }else{
                  Navigator.push(
                      context,
                      PageTransition(
                          child:ClassP(b: user1.b,id: user1.id,session_id: user1.csession, st: widget.st,),
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
  UserModel st;

  ClassP({super.key, required this.id, required this.session_id, required this.b,required this.st});

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
                    b : b,st:st,
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
  bool b; UserModel st;
  ChatUser({super.key, required this.user, required this.id, required this.sessionid, required this.b,required this.st});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Class "+user.Name+" ( "+user.section+" )",style: TextStyle(fontWeight: FontWeight.w500),),
      subtitle: Text("Total Students : "+user.total.toString(),style: TextStyle(fontSize:9,fontWeight: FontWeight.w400,color:Colors.grey),),
      onTap: () async {
        try{
          await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
            "school":user.Name,
            "schoolid":id,
            "classid":user.id,
          });
          Navigator.pop(context);
          Navigator.pop(context);
          Send.message(context, "Success : Your Request sent to School for Approval",true);
        }catch(e){
          Send.message(context, "${e}",false);
        }
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
