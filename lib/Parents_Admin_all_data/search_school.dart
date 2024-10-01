import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_managment_app/Parents_Admin_all_data/list_birthday.dart';
import 'package:student_managment_app/Parents_Admin_all_data/session_school.dart';
import 'package:student_managment_app/after_login/session.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:student_managment_app/picture.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
class Panel_School extends StatelessWidget {
  bool b ;
  Panel_School({super.key, required this.b});
  bool submitted = true ;
  List<SchoolModel> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();
  final Fire = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: ud,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Search by UDISE no.",
              hintText: "THH589NG",
              hintStyle: TextStyle( color : Colors.white, fontWeight: FontWeight.w100),
              labelStyle: TextStyle( color : Colors.white),
              fillColor: Colors.grey,
              icon : Icon(Icons.search, color : Colors.white, size : 25),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Set border color to white
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Set focused border color to white
              ),
              border: OutlineInputBorder(),
              isDense: true,
            isCollapsed: true,
            ),
            onFieldSubmitted: (value) {
              // Called when the user submits the form input
              submitted = false ;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please type It';
              }
              return null;
            },
          ),
        ),
        backgroundColor:  Color(0xff50008e),
      ),
      body: submitted ? ( b ? StreamBuilder(
        stream: Fire.collection('School').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => SchoolModel.fromJson(e.data())).toList() ??
                      [];
              return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatUser(
                    user: list[index],
                    b : b,
                  );
                },
              );
          }
        },
      ) : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height ,
        color : Colors.white,
        child: Column(
          children: [
            SizedBox(height: 40,),
            Image.network("https://confessionfreak.files.wordpress.com/2019/08/og_characters-with-cards-1.jpg"),
            SizedBox(height: 20,),
            Text("Search Institution by UDISE", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text("Type your Child Institution UDISE no. above to find the school", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network("https://play-lh.googleusercontent.com/tf9jh03D296H9GhJy9RWAdwLLOuTXgf-kIiXP16OKKWV2VknU1M7SBADm6opSZLOXXXL", height: 90,),
            )
          ],
        ),
      ) ) :
      StreamBuilder(
        stream: Fire.collection('School').where('UIDSE', isEqualTo: ud.text).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => SchoolModel.fromJson(e.data())).toList() ??
                      [];
              if(list.isEmpty){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children : [
                    SizedBox(height : 50),
                    Image.network("https://assets-v2.lottiefiles.com/a/92920ca4-1174-11ee-9d90-63f3a87b4e3d/c6NYERU5De.png"),
                    Text("No School found for that UDISE", style : TextStyle(fontSize : 20, fontWeight : FontWeight.w700)),
                    Text("Please check and try again or Contact us to find UDISE", textAlign : TextAlign.center),
                    SizedBox(height : 10),
                    TextButton(
                      child : Text("Inquire on Whatsapp"),
                      onPressed: () async {
                        final Uri _url = Uri.parse('https://wa.me/917000994158?text=Hello!%20We%20are%20contacting%20you%20for%20Students%20ID%20Card%20Services!');
                        if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                        }
                      },
                    )
                  ]
                );
              }else{
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(
                      user: list[index],
                      b : b,
                    );
                  },
                );
              }

          }
        },
      ),
    );
  }


}

class ChatUser extends StatefulWidget {
  final SchoolModel user;
  bool b ;

  ChatUser({Key? key, required this.user, required this.b}) : super(key: key);

  @override
  State<ChatUser> createState() => ChatUserState();
}

class ChatUserState extends State<ChatUser> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: SessionP(id: widget.user.id, b : widget.b),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 400)));
      },
      onDoubleTap: (){
        if(widget.b){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert ! All Data would be cleared'),
                content: Text('Are you sure you want to Delete ? Deleting the School would also delete each and every data inside that Institution'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('NO'),
                  ),
                  TextButton(
                    onPressed: () {

                      final snackBar = SnackBar(
                        content: Text('Please Long Press to Confirm It'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {
                            // Action to be performed when the "Close" button is pressed
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // Close the dialog
                    },
                    onLongPress: () async {
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).delete();
                      final snackBar = SnackBar(
                        content: Text('School Deletion Successfull !'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {
                            // Action to be performed when the "Close" button is pressed
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();

                    },
                    child: Text('I Confirm'),
                  ),
                ],
              );
            },
          );
        }
      },
      onLongPress: (){
        if(widget.b){
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return ra(context);
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(widget.user.Pic), fit: BoxFit.cover),
                ),
              ),
            ),
            ListTile(
              title: Text(widget.user.Name, style : TextStyle ( fontWeight: FontWeight.w700)),
              subtitle: Text(
                widget.user.Address,
                maxLines: 1,
              ),
              leading: Container(
                decoration: BoxDecoration(
                  color : widget.user.premium ? Colors.blue: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue, radius : 30,
                    backgroundImage: NetworkImage(widget.user.Pic_link),
                  ),
                ),
              ),
              trailing: TextButton.icon(
                  onPressed: () {

                  },
                  icon: Icon(Icons.person_pin),
                  label: Text(widget.user.total.toString())),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  Widget ra(BuildContext context){
    return Container(
      color:Colors.white,
      height: MediaQuery.of(context).size.height-100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration:BoxDecoration(
              image:DecorationImage(
                image:  NetworkImage(widget.user.Pic),fit:BoxFit.cover
              )
            )
          ),
          SizedBox(height: 10),
          Text("Advance Functions for School !",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 19)),
          SizedBox(height: 15),
          Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Pic(str: widget.user.Pic_link,name : widget.user.Chief),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400)));
                  },
                  child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(
                          context)
                          .size
                          .width /
                          3 -
                          30,
                      height: MediaQuery.of(context)
                          .size
                          .width /
                          3 -
                          30,
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Image.network(
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    3 -
                                    50,  widget.user.Pic_link),
                            Text("Download LOGO",
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.w700))
                          ])),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Pic(str: widget.user.AuthorizeSignature, name : widget.user.Chief),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400)));
                  },
                  child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(
                          context)
                          .size
                          .width /
                          3 -
                          30,
                      height: MediaQuery.of(context)
                          .size
                          .width /
                          3 -
                          30,
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Image.network(
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    3 -
                                    50,   widget.user.AuthorizeSignature),
                            Text("Download Sign",
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.w700))
                          ])),
                )
              ]),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Birthdayv(
                              logo: widget.user.Pic_link,
                              id : widget.user.id ,
                              School: widget.user.Name, address: widget.user.Address,                            ),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400)));
                  },
                  child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width / 3 - 30,
                      height: MediaQuery.of(context).size.width / 3 - 30,
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Image.network(
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    3 -
                                    50,  "https://i.pinimg.com/736x/3f/b5/34/3fb5340a30599c16b050ed5060d77bfa.jpg"),
                            Text("Birthdays",
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.w700))
                          ])),
                ),
                InkWell(
                  onTap: () async  {
                    if(widget.user.premium){
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        'premium' : false ,
                      });
                      final snackBar = SnackBar(
                        content: Text('School Now can\'t Avail Preium Service'),
                        duration: Duration(seconds: 3),

                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }else{
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        'premium' : true ,
                      });
                      final snackBar = SnackBar(
                        content: Text('Yey ! School can Now Avail Premium Services !'),
                        duration: Duration(seconds: 3),

                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 25,
                      height: MediaQuery.of(context).size.width / 3 - 25,
                      decoration : BoxDecoration(
                        borderRadius : BorderRadius.circular(10),
                        color: widget.user.premium ? Colors.blue.shade400 : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Image.network(
                                  height: MediaQuery.of(context)
                                      .size
                                      .width /
                                      3 -
                                      50,  "https://www.pngmart.com/files/13/Premium-PNG-Image.png",),
                              Text("Premium Service",
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.w700, color: widget.user.premium ? Colors.white : Colors.black,))
                            ]),
                      )),
                )
              ]),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async  {
                    if(widget.user.smsend){
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        'smsend' : false ,
                      });
                      final snackBar = SnackBar(
                        content: Text('School Now can\'t Avail Preium Service'),
                        duration: Duration(seconds: 3),

                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }else{
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        'smsend' : true ,
                      });
                      final snackBar = SnackBar(
                        content: Text('Yey ! School can Now Avail Premium Services !'),
                        duration: Duration(seconds: 3),

                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 25,
                      height: MediaQuery.of(context).size.width / 3 - 25,
                      decoration : BoxDecoration(
                        borderRadius : BorderRadius.circular(10),
                        color: widget.user.smsend ? Colors.blue.shade400 : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Image.network(
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    3 -
                                    50,  "https://cdn.pixabay.com/photo/2013/07/12/15/53/message-150505_1280.png",),
                              Text("SMS Service",
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.w700, color: widget.user.smsend ? Colors.white : Colors.black,))
                            ]),
                      )),
                ),
                InkWell(
                  onTap: () async  {
                    if(widget.user.premium){
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        'premium' : false ,
                      });
                      final snackBar = SnackBar(
                        content: Text('School Now can\'t Avail Preium Service'),
                        duration: Duration(seconds: 3),

                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }else{
                      CollectionReference collection = FirebaseFirestore.instance.collection('School');
                      await collection.doc(widget.user.id).update({
                        'premium' : true ,
                      });
                      final snackBar = SnackBar(
                        content: Text('Yey ! School can Now Avail Premium Services !'),
                        duration: Duration(seconds: 3),

                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 25,
                      height: MediaQuery.of(context).size.width / 3 - 25,
                      decoration : BoxDecoration(
                        borderRadius : BorderRadius.circular(10),
                        color: widget.user.premium ? Colors.blue.shade400 : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Image.network(
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    3 -
                                    50,  "https://www.pngmart.com/files/13/Premium-PNG-Image.png",),
                              Text("Premium Service",
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.w700, color: widget.user.premium ? Colors.white : Colors.black,))
                            ]),
                      )),
                )
              ]),
        ],
      ),
    );
  }
}
