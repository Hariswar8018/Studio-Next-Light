import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/usermodel.dart';

class SeeAllRequest extends StatelessWidget {
  String id,tofind;

  bool history;
  SeeAllRequest({super.key,required this.id,required this.tofind,required this.history});
  List<UserModel> list = [];
  late Map<String, dynamic> userMap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
        title: Text("Requests for $tofind",style:TextStyle(color:Colors.white)),
        actions: [
          SizedBox(width: 45,),
        ],
      ),
      body:  StreamBuilder(
        stream:history?FirebaseFirestore.instance.collection('Users')
            .snapshots(): FirebaseFirestore.instance.collection('Users').where("position",isEqualTo: tofind)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return UserC(user: list[index]);
                },
              );
          }
        },
      ),
    );
  }
}

class UserC extends StatelessWidget {
  UserModel user;
  UserC({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5,top: 1),
      child: haveaccess(context),
    );
  }

  Widget haveaccess(BuildContext context)=>user.probation?Card(
    color: Colors.green.shade50,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.pic??"https://i.pinimg.com/736x/44/9f/2c/449f2c3c1b942bfd4b270d6ab4a3e5b7.jpg",),
          ),
          title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800),),
          subtitle: Text(user.email),
          trailing:InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child:Son(user:user),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 50)));
            },
            child: Icon(Icons.settings,color: Colors.blue,size: 25,),
          ),
        ),
        Text("     Status : ACCESS GIVEN",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w700),),
        SizedBox(height:10),
      ],
    ),
  ):InkWell(
    onTap: (){
      donee(context);
    },
    child: Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.pic??"https://i.pinimg.com/736x/44/9f/2c/449f2c3c1b942bfd4b270d6ab4a3e5b7.jpg",),
            ),
            title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800),),
            subtitle: Text(user.email),
            trailing: trail(),
          ),
          Text("     Status : NO ACCESS",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w700),),
          SizedBox(height:20),
        ],
      ),
    ),
  );

  Widget trail()=>user.verified?Container(
    height: 25,width: 80,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.green,
          width: 2,
        )
    ),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified,size: 12,color: Colors.blue,),
          Text("ID VERIFIED",style: TextStyle(fontSize: 9,color: Colors.blue),),
        ],
      ),
    ),
  ):
  Container(
    height: 25,width: 80,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.red,
          width: 2,
        )
    ),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_interested_outlined,size: 12,color: Colors.orange,),
          Text("NOT VERIFIED",style: TextStyle(fontSize: 9,color: Colors.red),),
        ],
      ),
    ),
  );

  void donee(BuildContext context){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: SizedBox(
            height: 550,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Icon(Icons.verified_rounded,size:100,color:Colors.green),
                  Text("Confirm to give Access?",style:TextStyle(fontWeight: FontWeight.w800,fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(textAlign: TextAlign.center,"By Confirming Access, The User will be able to access basic features of their Login Request. You sure ?"),
                  ),
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SocialLoginButton(
                      backgroundColor:  Color(0xff6001FF),
                      height: 40,
                      text: 'I Confirm to give Access',
                      borderRadius: 20,
                      fontSize: 21,
                      buttonType: SocialLoginButtonType.generalLogin,
                      onPressed: ()async{
                        Navigator.pop(context);
                        await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
                          "probation":true,
                        });
                        try{
                          sendnotify();
                        }catch(e){

                        }
                      Navigator.pop(context);
                        Send.topic(context, "${user.name} is given Access", "Access is given to ${user.name} ! They will now be able to have basic Access");

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void sendnotify(){
    Send.sendNotificationsToTokens("School given access", "School had Accepted your Access ! Open App to view", user.token);
  }
}

class Son extends StatefulWidget {
  UserModel user;
  Son({super.key,required this.user});

  @override
  State<Son> createState() => _SonState();
}

class _SonState extends State<Son> {


  void initState(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
