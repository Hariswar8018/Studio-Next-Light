import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:student_managment_app/model/school_model.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:student_managment_app/after_login/session.dart';
import 'package:student_managment_app/model/birthday_student.dart';
import 'package:url_launcher/url_launcher.dart';

class Declare_Holi extends StatefulWidget {
  final SchoolModel user;
  Declare_Holi({super.key, required this.user});

  @override
  State<Declare_Holi> createState() => _Declare_HoliState();
}

class _Declare_HoliState extends State<Declare_Holi> {

  void initState(){
    DateTime dateTime = DateTime.now();

    // Format the DateTime in the desired format (DD/MM/YYYY)
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime );
    dob = TextEditingController(text: formattedDate);
    dob1 = TextEditingController(text: formattedDate);
    Textt.text = "Diwali";
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  bool? checkboxIconFormFieldValue = false;

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _singleDatePickerValueWithDefaultValue ,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                // Format the DateTime in the desired format (DD/MM/YYYY)
                setState(() {
                  _singleDatePickerValueWithDefaultValue  = values;
                  DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
                  String dateTimeString = date.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime = DateTime.parse(dateTimeString);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  dob = TextEditingController(text: formattedDate);
                });
              }
            },
            child: const Text('Holiday Starting'),
          ),
        ],
      ),
    );
  }

  _buildCalendarDialogButton1() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _singleDatePickerValueWithDefaultValue ,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                // Format the DateTime in the desired format (DD/MM/YYYY)
                setState(() {
                  _singleDatePickerValueWithDefaultValue  = values;
                  DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
                  String dateTimeString = date.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime = DateTime.parse(dateTimeString);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  dob1 = TextEditingController(text: formattedDate);
                });
              }
            },
            child: const Text('School Reopening'),
          ),
        ],
      ),
    );
  }

  TextEditingController dob = TextEditingController();
  TextEditingController dob1 = TextEditingController();
  TextEditingController Textt = TextEditingController();
  List<StudentModel2> list = [];
  late Map<String, dynamic> userMap;
  TextEditingController ud = TextEditingController();

  final Fire = FirebaseFirestore.instance;

  bool sms=false,whatsapp=false,inapp=true;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Declare Holiday", style : TextStyle(color : Colors.white)),
        backgroundColor: Color(0xff50008e),
      ),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          Image.asset("assets/images/school/holidaycelebrate.jpg",width: w,height: 250,),
          SizedBox(height: 20,),
          Text("   Choose Date of Holiday",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              as("SMS",sms,w,"assets/images/school/holi1.png"),
              as("Whatsapp",sms,w,"assets/images/school/holy2.jpg"),
              Container(
                width: w/3-40,
                height: w/3-40,
                foregroundDecoration: RotatedCornerDecoration.withColor(
                  color: Colors.red,
                  spanBaselineShift: 4,
                  badgeSize: Size(64, 64),
                  badgeCornerRadius: Radius.circular(8),
                  badgePosition: BadgePosition.topEnd,
                  textSpan: TextSpan(
                    text: 'FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(color: Colors.yellowAccent, blurRadius: 8),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/school/push-notifications-concept-illustration_114360-4730.jpg")
                    ),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey,
                        width: 2
                    )
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: w/2,
                child:   max(dob, "Date of Holiday", "Date of Holiday", true, 1),
              ),
              Container(
                width: w/2,
                child:  max(dob1, "Date of Re-Opening", "Date of Holiday", true, 1),
              )
            ],
          ),
          Container(
            width : MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children : [
                _buildCalendarDialogButton(),
                 _buildCalendarDialogButton1(),
              ]
            ),
          ),
          max(Textt, "Reason for Holiday", "Diwali", false, 1),
          SizedBox(height : 15),
          Text("   List of Students who will get Notification"),
          Container(
            height : 300, width : MediaQuery.of(context).size.width,
            child : StreamBuilder(
              stream: Fire.collection('School')
                  .doc(widget.user.id)
                  .collection('Students')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list =
                        data?.map((e) => StudentModel2.fromJson(e.data())).toList() ??
                            [];
                    return ListView.builder(
                        itemCount: list.length,
                        padding: EdgeInsets.only(top: 10),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUser(
                              user: list[index],
                              id : widget.user.id
                          );
                        });
                }
              },
            ),
          )
        ]
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Declare Holiday Now !',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              try {
                for (final student in list) {
                  await sendNotification(student.Mobile);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Success: All Mail sent!'),
                  ),
                );
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Falied : The API server is down or the APi is Wrong ! ${e}'),
                  ),
                );
                Navigator.pop(context);
              }

            },
          ),
        ),
      ],
    );
  }
  Widget as(String str2, bool hem, double w,String str){
    return  Column(
      children: [
        Container(
          width: w/3-40,
          height: w/3-40,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(str)
              ),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: Colors.grey,
                  width: 2
              )
          ),
        ),
        Text(str2,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "RobotoS"),)
      ],
    );
  }

  Future<void> sendNotification(String contact) async {
    final url = Uri.parse('https://sms.autobysms.com/app/smsapi/index.php?key=365E176C71F352&campaign=0&routeid=9&type=text&senderid=JAWRAM&template_id=1407171031437770667');
    final response = await http.post(
      url,
      body: {
        'contacts': contact ,
        'msg': 'Dear Students , <\n>Hearty congratulations from ${widget.user.Name} on the occasion of ${Textt.text}. Our Institute will be closed from ${dob.text} to ${dob1.text}. We hope you enjoy this holiday with your family and friends',
      },
    );
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print('Failed to send notification ');
    }
  }


  Widget max(TextEditingController c, String label, String hint, bool number,
      int max) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.text,
        readOnly: number,
        maxLines: max,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint, suffixIcon: number ? IconButton( onPressed: (){

        }, icon : Icon(Icons.calendar_month)) : SizedBox(),
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }
}



class ChatUser extends StatelessWidget {
  StudentModel2 user; String id ;

  ChatUser({
    super.key,
    required this.user, required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pic),
      ),
      title: Text(user.Name, style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}