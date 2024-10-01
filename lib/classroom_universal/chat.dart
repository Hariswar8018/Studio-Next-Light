import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_managment_app/model/message.dart';

import '../model/usermodel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  String school , clas , Name, Pic,idd;
  bool teacher;
  ChatPage({Key? key, required this.Name,required this.Pic,required this.school,required this.clas,required this.teacher,required this.idd}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Fire = FirebaseFirestore.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Messages> _list = [];
  TextEditingController textcon = TextEditingController();


  TextEditingController onh = TextEditingController();

  Future<void> sendMessage(String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages messages = Messages(
      teach: widget.teacher,
      read: 'me', uidd :widget.idd, name : widget.Name, pic: widget.Pic,
      told:widget.idd,
      from:widget.school+widget.clas,
      mes: msg,
      type: Type.text,
      sent: time,
    );

    await _firestore.collection('Chat/${widget.school+widget.clas}/messages/').doc(time).set(
      messages.toJson(
          Messages(
            teach: widget.teacher,
            read: 'me', uidd :widget.idd, name : widget.Name, pic: widget.Pic,
            told: widget.idd,
            from:widget.school+widget.clas,
            mes: msg,
            type: Type.text,
            sent: time,
          ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return _firestore.collection('Chat/${widget.school+widget.clas}/messages/').orderBy("sent",descending: true).snapshots();
  }

  Future<void> updateStatus(Messages message) async {
    _firestore.collection('Chat/${widget.school+widget.clas}/messages/').doc(message.sent).update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _AppBar(),
          backgroundColor: Colors.white,
          actions: [
            InkWell(
                onTap: (){

                },
                child: Icon(Icons.more_vert)),
            SizedBox(width : 8)
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://mrwallpaper.com/images/thumbnail/cute-emoticons-whatsapp-chat-9j4qccr8lqrkcwaj.webp"),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: getAllMessages(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SizedBox(height: 10);
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: 10),
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index], uid: widget.idd,);
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Say Hi to your Friends 👋 ",
                              style: TextStyle(fontSize: 22),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              _ChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _AppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.Pic),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _ChatInput() {
    String s = " ";
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.emoji_emotions),
                ),
                Expanded(
                  child: TextField(
                    controller: textcon,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type Something........",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      s = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          shape: CircleBorder(),
          color: Colors.blue,
          minWidth: 0,
          onPressed: () async {
            if (s.isNotEmpty) {
              sendMessage(s);
              setState(() {
                s = " ";
                textcon = TextEditingController(text: "");
              });
            }
          },
          child: Icon(Icons.send, color: Colors.white),
        ),
      ],
    );
  }

  String fo(String dateTimeString) {
    // Parse the DateTime string
    /*DateTime dateTime = DateTime.parse(dateTimeString);

    // Get the current date
    DateTime now = DateTime.now();

    // Check if the dateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    // Define date formats
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yy');*/
    return "now ";
    // Return the formatted date
    /*return isToday ? timeFormat.format(dateTime) : dateFormat.format(dateTime);*/
  }
}


class MessageCard extends StatefulWidget {
   MessageCard({Key? key, required this.message,required this.uid}) : super(key: key);
  final Messages message;String uid;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  @override
  Widget build(BuildContext context) {
    return  widget.message.teach ? _redMessage() : ( widget.uid.toString() != widget.message.told
        ? _blueMessage()
        : _greenMessage() );
  }

  Widget _blueMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.message.pic),
            radius: 14,
          ),
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      widget.message.name,
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
                  Text(
                      getFormattedTime(
                          widget.message.sent),
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 1,
          ),
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: Row(
                      children: [
                        Text(
                            getFormattedTime(
                                widget.message.sent) ,
                            style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
                        Spacer(),
                        widget.message.read.isNotEmpty?
                        Icon(
                          Icons.done_all,
                          color: Colors.grey,
                          size: 18,
                        ) : Icon(
                          Icons.done_all,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _redMessage() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.message.pic),
            radius: 14,
          ),
          Flexible(
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 12),
              margin: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width : 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.school),
                        SizedBox(width : 4),
                        Text("Teacher"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.message.mes,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      widget.message.name,
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)),
                  Text(
                      getFormattedTime(
                          widget.message.sent),
                      style:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w300)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFormattedTime( String time ) {
    // Convert the string to an integer
    int millisecondsSinceEpoch = int.parse(time);

    // Create a DateTime object from the millisecondsSinceEpoch
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    // Get the current date
    DateTime now = DateTime.now();

    // Check if the dateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    // Define date formats
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yy');
    // Return the formatted date
    return isToday ? timeFormat.format(dateTime) : dateFormat.format(dateTime);
  }
}
