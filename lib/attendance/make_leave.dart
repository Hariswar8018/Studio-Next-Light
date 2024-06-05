import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:studio_next_light/aextra/session.dart';
import 'package:studio_next_light/model/school_model.dart';
import 'package:studio_next_light/model/student_model.dart';

class fS extends StatefulWidget {
  SchoolModel user ;
   fS({super.key, required this.user});

  @override
  State<fS> createState() => _fSState();
}

class _fSState extends State<fS> {

// Create the list with today's date and the date 4 days later
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 4)),
  ];

  String pic = " ", name = " ", classn = " ", sec = " ", cl = " ", rg = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.white),
          title:
          Text("Leave Application", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xff50008e),
        ),
      body : Column (
        children : [
          _buildDefaultRangeDatePickerWithValue(),
          pic == " "? ListTile(
            onTap: () async {
              StudentModel u = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SessionJust(id: widget.user.id, student: true, reminder : false, sname : widget.user.Name)),
              );
              print(u.Name);
              setState(() {
                pic = u.pic;
                name = u.Name;
                classn = u.Classn ;
                sec = u.Section ;
                cl = u.Class ;
                rg = u.Registration_number ;
              });
            },
            splashColor: Colors.orange,
            tileColor: Colors.greenAccent.shade100,
            leading: Icon(Icons.dataset_rounded),
            title: Text("Add from School Data",
                style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text("Add from already present Student Data"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ) :
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(pic),
            ),
            title: Text(name,style : TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(cl + " (" + sec + ")"), onTap: (){
              setState(() {
                pic = " ";
              });
          },
            trailing: Icon(Icons.verified, color : Colors.green),
          ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SocialLoginButton(
                backgroundColor: Color(0xff50008e),
                height: 40,
                text: 'Mark Leave ',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  List j = _generateFormattedDatesInRange( _rangeDatePickerValueWithDefaultValue[0]!  ,
                      _rangeDatePickerValueWithDefaultValue[1]!);
                  print(j);
                  try{
                    _generate( _rangeDatePickerValueWithDefaultValue[0]!  ,
                        _rangeDatePickerValueWithDefaultValue[1]!, rg);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error puttind data in calender"),
                      ),
                    );
                  }
                  try{
                    await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
                        .collection("Session")
                        .doc(widget.user.csession).collection("Class").doc(classn).collection("Student").doc(rg)
                        .update({
                      'Leave': FieldValue.arrayUnion(j),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(name + " is set as Leave on the Following Days Success !"),
                      ),
                    );

                    Navigator.pop(context);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error ! Either the Student is not from current session or have bad Registration ID"),
                      ),
                    );
                  }

                }
              ),
            ),
        ]
      )
    );
  }
  void _generate(DateTime start, DateTime end, String reg) async {
    List<String> formattedDates = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime currentDate = DateTime(start.year, start.month, start.day + i);

      // Manually format the date without leading zeros
      String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
      formattedDates.add(formattedDate); // Add the formatted date to the list

      // Use the formatted date in Firestore
      String sj = DateTime.now().microsecondsSinceEpoch.toString();
      await FirebaseFirestore.instance.collection('School').doc(widget.user.id)
          .collection("Students")
          .doc(reg)
          .collection("Colors")
          .doc(formattedDate)
          .set({
        'color': Colors.green.value,
        'date': currentDate, // Save the formatted date
        'st': formattedDate,
      });
    }
  }


  List<String> _generateFormattedDatesInRange(DateTime start, DateTime end) {
    List<String> formattedDates = [];

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime currentDate = DateTime(start.year, start.month, start.day + i);
      String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
      formattedDates.add(formattedDate);
    }

    return formattedDates;
  }

  Widget _buildDefaultRangeDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          value: _rangeDatePickerValueWithDefaultValue,
          onValueChanged: (dates) =>
              setState(() => _rangeDatePickerValueWithDefaultValue = dates),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _rangeDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
  String _getValueText(CalendarDatePicker2Type datePickerType, List<DateTime?> values,) {
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
}
