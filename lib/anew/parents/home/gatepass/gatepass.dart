import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_managment_app/anew/parents/home/gatepass/virtual.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/school_model.dart';

import '../../../../model/student_model.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Gatepass extends StatelessWidget {
  SchoolModel user;StudentModel st;
  Gatepass({super.key,required this.user,required this.st});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
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
      ),
      body: Container(
        width: w,height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Center(
              child: Container(
                  width:w-40,height:200,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          image:AssetImage("assets/images/login/Back-to-School-Illustration.jpg"),
                          fit: BoxFit.contain
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text("Enter School Easily with Gate Pass",textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            SizedBox(height: 2.0),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text("As a verified Parent you could Enter School any time for Parents Meeting, Fee Payment, etc",textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Center(
                child: Container(
                  width: w-20,
                  height:90,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(width: 5,),
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.Pic_link),
                        radius: 30,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.Name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text(user.Address,
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        ],
                      ),
                      Spacer(),
                      SizedBox(width: 5,)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 7,),
            InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final bool Admin = prefs.getBool('Verified') ?? false ;
                Navigator.push(
                    context,
                    PageTransition(
                        child: Virtual(user:st, st: user, verified:Admin,),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)));
                   },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: w-40,
                  height:90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: st=="QR"?Colors.blue:Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(width: 5,),
                      Image.asset(height: 80,
                          "assets/images/login/qr-code-scanning-concept-with-characters_23-2148654288 (1).png"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Virtual Parent/Student Card',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Get Entry Easily by Showing Parent Digital',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('Card on Parents Meeting, Exhibition, etc',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                        ],
                      ),
                      Spacer(),
                      st=="QR"? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                        ),
                      ):SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: GatePassFormPage(studentid: user.id, user: st, token1:user.token1, token2: user.token2,),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15),
                child: Container(
                  width: w-40,
                  height:90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: st=="ST"?Colors.blue:Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(width: 5,),
                      Image.asset(height: 80,
                          "assets/images/login/secure-login-illustration-in-flat-design-vector.jpg"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enter by Sheduling',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Enter by taking Permission from Teacher',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('or Principal with Verification',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),)
                        ],
                      ),
                      Spacer(),
                      st=="ST"? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 22,)),
                        ),
                      ):SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: History(str: user.id, res: st.Registration_number,),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)));
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
                  child: Center(child: Text("Check History of Gate Pass",style: TextStyle(
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
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}


class History extends StatelessWidget {
  String str;String res;
  History({super.key,required this.str,required this.res});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text("History",style: TextStyle(color: Colors.white),),
      ),
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('School').doc(str).collection("Pass").where("time3",isEqualTo:res)
            .snapshots() ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network("https://cdn-icons-png.freepik.com/512/7486/7486744.png", width : MediaQuery.of(context).size.width - 200),
                  Text(
                    "No found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks like there's isn't any History", textAlign : TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => GatePassForm.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Noticec(user: _list[index],id: str);
            },
          );
        },
      ) ,
    );
  }
  List<GatePassForm> _list = [];
}

class Noticec extends StatelessWidget {
  GatePassForm user;String id;
  Noticec({super.key,required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Done(user: user, id: id,),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              user.stpic
            ),
          ),
          title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800),),
          subtitle: Text("Reason for Visiting : "+user.reason),
          trailing: Text(user.accepted?"Accept":"Wait",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.w700),),
        ),
      ),
    );
  }
}

class Done extends StatefulWidget {
  GatePassForm user;String id;
  Done({super.key,required this.user,required this.id});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  final GlobalKey boundaryKey = GlobalKey();

  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData('${widget.user.id}');
    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: Text("Student Parent Gate Pass"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            width: w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width:9,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(9)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: w/2-14,height: w/2-14,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: PrettyQrView(
                          qrImage: qrImage,
                          decoration: const PrettyQrDecoration(
                            image: PrettyQrDecorationImage(
                              image: AssetImage('assets/WhatsApp_Image_2023-11-22_at_17.13.30_388ceeb5-transformed.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 9,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9,),
                    Text("Parents /",style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/18),),
                    Text("Guardian Detail",style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/18),),
                    SizedBox(height: 13,),
                    Text(widget.user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/29),),
                    Text(widget.user.email,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/29),),
                    Text(widget.user.phone,style: TextStyle(fontWeight: FontWeight.w800,fontSize: w/29),),

                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: Container(
                width: w-20,
                height:70,
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.grey.shade900,
                      width: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(width: 5,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.stpic),
                      radius: 24,
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.stname,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(height: 3,),
                        Text("Class : "+ widget.user.stclass ,
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        Text( "",
                          style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                      ],
                    ),
                    Spacer(),
                    SizedBox(width: 5,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: Container(
                width: w-20,
                height:70,
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.grey.shade900,
                      width: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: ListTile(
                  leading: Icon(Icons.verified),
                  title: Text("Verified : "+widget.user.verified.toString(),style: TextStyle(fontSize: 19,color: Colors.green),),
                  subtitle: Text("Verified as it's come from Parent Porta;"),
                )
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: widget.user.accepted?Container(
                  width: w-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.settings_accessibility,color: Colors.white,),
                    title: Text("Meeting Accepted",style: TextStyle(fontSize: 19,color: Colors.white),),
                    subtitle: Text("Meeting is accepted by Principal",style: TextStyle(color: Colors.white),),
                  )
              ):Container(
                  width: w-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.warning,color: Colors.white,),
                    title: Text("Meeting Still Not Accepted",style: TextStyle(fontSize: 19,color: Colors.white),),
                    subtitle: Text("Meeting is NOT accepted by Principal",style: TextStyle(color: Colors.white),),
                  )
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Center(
              child: Container(
                  width: w-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.share_arrival_time),
                    title: Text("Decided for : "+s(widget.user.time2),style: TextStyle(fontSize:19,color: Colors.blue,fontWeight: FontWeight.w800),),
                      subtitle: Text("Desired for : "+s(widget.user.time),style: TextStyle(color: Colors.grey),),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
  String s(String entry) {
    try {
      DateTime dateTime = DateTime.parse(entry);

      // Format the DateTime to dd/mm/yy on hh:mm using DateFormat from intl package
      String formattedTime = DateFormat('dd/MM/yy on HH:mm').format(dateTime);

      return formattedTime;
    } catch (e) {
      return "NA"; // Return "NA" if parsing fails
    }
  }
}

class GatePassFormPage extends StatefulWidget {
  
String studentid="";StudentModel user; String token1,token2;
  GatePassFormPage({Key? key,required this.studentid,required this.user,required this.token1, required this.token2}) : super(key: key);

  @override
  State<GatePassFormPage> createState() => _GatePassFormPageState();
}

class _GatePassFormPageState extends State<GatePassFormPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController reasonController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  final TextEditingController time2Controller = TextEditingController();

  final TextEditingController time3Controller = TextEditingController();

  final TextEditingController videoidController = TextEditingController();

  final TextEditingController videopassController = TextEditingController();

  final TextEditingController stnameController = TextEditingController();

  final TextEditingController stpicController = TextEditingController();

  final TextEditingController stclassController = TextEditingController();

  final TextEditingController positionController = TextEditingController();

  bool verified = false;

  bool accepted = false;


  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
  Widget buildTextField1(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget rt(String jh){
    return InkWell(
        onTap : () async {
          reasonController.text = jh;
          setState(() {

          });
        }, child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: reasonController.text==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(jh, style : TextStyle(fontSize: 16, color :  reasonController.text==jh? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
  final TextEditingController startd = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController endd = TextEditingController();
  final TextEditingController endt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Gate Pass Application',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.dashboard, size: 30, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Your Info",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            buildTextField('Name', nameController),
            buildTextField('Email', emailController),
            buildTextField('Phone', phoneController),
            SizedBox(height: 9,),
            Row(
              children: [
                rt("Fee Payment"),rt("Student Checkout"),rt("Teacher Meeting")
              ],
            ),
            Row(
              children: [
                rt("General Inquiry"),rt("Admission")
              ],
            ),
            SizedBox(height: 9,),
            buildTextField('Reason', reasonController),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.calendar_month, size: 30, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Date & Time",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            buildTextField1('Time', timeController),
            Container(
              width: w,
              height: 50,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        DateTime? dateTimeList =
                        await showOmniDateTimePicker(
                          context: context,
                          is24HourMode: false,
                          isShowSeconds: false,
                          minutesInterval: 1,
                          secondsInterval: 1,
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          constraints: const BoxConstraints(
                            maxWidth: 350,
                            maxHeight: 650,
                          ),
                          transitionBuilder: (context, anim1, anim2, child) {
                            return FadeTransition(
                              opacity: anim1.drive(
                                Tween(
                                  begin: 0,
                                  end: 1,
                                ),
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 200),
                          barrierDismissible: true,
                          selectableDayPredicate: (dateTime) {
                            // Disable 25th Feb 2023
                            if (dateTime == DateTime(2023, 2, 25)) {
                              return false;
                            } else {
                              return true;
                            }
                          },
                        );
                        setState(() {
                          timeController.text=dateTimeList.toString() ;
                        });
                      },
                      child: Center(
                        child: Container(
                          height:45,width:w/2-20,
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
                          child: Center(child: Text("Choose Date/Time",style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RobotoS",fontWeight: FontWeight.w800
                          ),)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.person, size: 30, color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Student Info",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Center(
                child: Container(
                  width: w-20,
                  height:70,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SizedBox(width: 5,),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.pic),
                        radius: 24,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.user.Name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text("Class : "+ widget.user.Class + " (${widget.user.Section})",
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text( widget.user.Address,
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                        ],
                      ),
                      Spacer(),
                      SizedBox(width: 5,)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            if(nameController.text.isNotEmpty&&timeController.text.isNotEmpty&&reasonController.text.isNotEmpty){
              String id = DateTime.now().millisecondsSinceEpoch.toString();
              GatePassForm form = GatePassForm(
                name: nameController.text, email: emailController.text, phone: phoneController.text,
                reason: reasonController.text, id: id, verified: true, accepted: false,
                time: timeController.text, time2: time2Controller.text, time3: widget.user.Registration_number,
                videoid: videoidController.text, videopass: videopassController.text, stname: widget.user.Name,
                stpic: widget.user.pic, stclass: widget.user.Class + " (${widget.user.Section})", position: "Parent", token: widget.user.token, status: 'Waiting for Response',
              );
              await FirebaseFirestore.instance.collection("School").doc(widget.studentid).collection("Pass").doc(id).set(form.toJson());

              String mses= "${nameController.text} want Gate Pass to enter the School for ${reasonController.text}";
              try{
                Send.sendNotificationsToTokens("New Gate Access Request by a Parent", mses, widget.token1);
              }catch(e){
                print(e);
              }
              try{
                Send.sendNotificationsToTokens("New Gate Access Request by a Parent", mses, widget.token2);
              }catch(e){
                print(e);
              }
              Navigator.pop(context);

            }else{
              Send.message(context, "Please Fill all Details",false);
              print(widget.token1);
              print(widget.token2);
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
              child: Center(child: Text("Apply for GATE PASS/ENTRY",style: TextStyle(
                  color: Colors.white,
                  fontFamily: "RobotoS",fontWeight: FontWeight.w800
              ),)),
            ),
          ),
        ),
      ],
    );
  }
}
class GatePassForm {
  GatePassForm({
    required this.name,
    required this.email,
    required this.phone,
    required this.reason,
    required this.id,
    required this.verified,
    required this.accepted,
    required this.time,
    required this.time2,
    required this.time3,
    required this.videoid,
    required this.videopass,
    required this.stname,
    required this.stpic,
    required this.stclass,
    required this.position,
    required this.token,     // New field
    required this.status,    // New field
  });

  late final String name;
  late final String email;
  late final String phone;
  late final String reason;
  late final String id;
  late final bool verified;
  late final bool accepted;
  late final String time;
  late final String time2;
  late final String time3;
  late final String videoid;
  late final String videopass;
  late final String stname;
  late final String stpic;
  late final String stclass;
  late final String position;
  late final String token;    // New field
  late final String status;   // New field

  GatePassForm.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    reason = json['reason'] ?? '';
    id = json['id'] ?? '';
    verified = json['verified'] ?? false;
    accepted = json['accepted'] ?? false;
    time = json['time'] ?? '';
    time2 = json['time2'] ?? '';
    time3 = json['time3'] ?? '';
    videoid = json['videoid'] ?? '';
    videopass = json['videopass'] ?? '';
    stname = json['stname'] ?? '';
    stpic = json['stpic'] ?? '';
    stclass = json['stclass'] ?? '';
    position = json['position'] ?? '';
    token = json['token'] ?? '';     // New field initialization
    status = json['status'] ?? '';   // New field initialization
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['reason'] = reason;
    data['id'] = id;
    data['verified'] = verified;
    data['accepted'] = accepted;
    data['time'] = time;
    data['time2'] = time2;
    data['time3'] = time3;
    data['videoid'] = videoid;
    data['videopass'] = videopass;
    data['stname'] = stname;
    data['stpic'] = stpic;
    data['stclass'] = stclass;
    data['position'] = position;
    data['token'] = token;     // New field in toJson
    data['status'] = status;   // New field in toJson
    return data;
  }
}

