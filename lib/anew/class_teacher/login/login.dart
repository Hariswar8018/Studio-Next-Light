import 'package:flutter/material.dart';

class TeacherL extends StatefulWidget {
  const TeacherL({super.key});

  @override
  State<TeacherL> createState() => _TeacherLState();
}

class _TeacherLState extends State<TeacherL> {
  String st = "";

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
            SizedBox(height: 80,),
            Center(
              child: Container(
                  width:w-40,height:300,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          image:AssetImage("assets/images/login/depositphotos_599896340-stock-illustration-young-teacher-woman-explain-front.jpg"),
                          fit: BoxFit.contain
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14,top: 14),
              child: Center(
                child: Text("Welcome "+"Class Teacher",
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 24),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0,right: 14),
              child: Center(
                child: Text("Let's Find your Class by your attached School",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
              ),
            ),
            SizedBox(height: 7,),
            InkWell(
              onTap: (){
                if(st=="QR"){

                }
                setState(() {
                  st="QR";
                });
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
                      Image.network(height: 80,
                          "https://img.freepik.com/free-vector/qr-code-scanning-concept-with-characters_23-2148654288.jpg"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login by School QR',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Directly Scan School QR to Login',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('directly to your Class',
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
                if(st=="ST"){

                }
                setState(() {
                  st="ST";
                });
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
                      Image.network(height: 80,
                          "https://img.freepik.com/free-vector/qr-code-scanning-concept-with-characters_23-2148654288.jpg"),
                      SizedBox(width: 5,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login Manually',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                          SizedBox(height: 3,),
                          Text('Login by finding School>Session>',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey),),
                          Text('Class>Student',
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
            SizedBox(height: 23,),
          ],
        ),
      ),
    );
  }
}
