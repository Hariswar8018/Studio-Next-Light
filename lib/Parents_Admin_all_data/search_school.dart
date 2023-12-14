import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studio_next_light/Parents_Admin_all_data/session_school.dart';
import 'package:studio_next_light/after_login/session.dart';
import 'package:flutter/material.dart';
import 'package:studio_next_light/model/school_model.dart';

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
              labelText: "Search by UIDSE",
              hintText: "MGM English School",
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
            Image.network("https://i.pinimg.com/originals/4b/54/c3/4b54c302d999845551baa77c995f5bbb.gif"),
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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.Pic_link),
              ),
              trailing: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person_pin),
                  label: Text(widget.user.Students.toString())),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
