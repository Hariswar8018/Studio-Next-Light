import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_model.dart';
import 'package:student_managment_app/function/send.dart';

class AddTests extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String school,session,clas;bool test;
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'subtitle': TextEditingController(),
    'notes': TextEditingController(),
    'attachment': TextEditingController(),
    'startdate': TextEditingController(),
    'enddate': TextEditingController(),
    'id': TextEditingController(),
    'totalmarks': TextEditingController(),
    'totalsubjects': TextEditingController(),
    'syllabus': TextEditingController(),
  };

  // Initialize s1-s10 and d1-d10 controllers
  final Map<String, TextEditingController> _sControllers = {};
  final Map<String, TextEditingController> _dControllers = {};

  bool _exam = false;

  AddTests({super.key,required this.clas,required this.school,required this.session,required this.test}) {
    // Initialize s1-s10 controllers
    for (int i = 1; i <= 10; i++) {
      _sControllers['s$i'] = TextEditingController();
      _dControllers['d$i'] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(!(test)?"Exams":"Tests")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionHeader('Test Information'),
              _buildTextFormField('Title of Test', 'title', required: true),
              _buildTextFormField('Subtitle', 'subtitle'),
              _buildTextFormField('Notes', 'notes', maxLines: 3),
              _buildTextFormField('Attachment Link ( Optional )', 'attachment'),


              _buildSectionHeader('Subjects & DateTime'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2-18,
                    child: Column(
                      children: [
                        ...List.generate(10, (index) =>
                            _buildTextFormField('Subject ${index+1}', 's${index+1}')),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2-18,
                    child: Column(
                      children: [
                        ...List.generate(10, (index) =>
                            _buildTextFormField4('Date ${index+1}', 'd${index+1}',context)),
                      ],
                    ),
                  ),
                ],
              ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(countNonEmptySControllers(_sControllers).toString()+" Subjects",style: TextStyle(fontWeight: FontWeight.w700),),
                   Text(countNonEmptyDControllers(_dControllers).toString()+" Dates",style: TextStyle(fontWeight: FontWeight.w700),),
                   SizedBox(),
                 ],
               ),
               _buildSectionHeader('Dates'),
              _buildTextFormField1('Start Date', 'startdate'),
              _buildTextFormField1('End Date', 'enddate'),
              _buildSectionHeader('Exam Details'),

              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*2/3,
                      child: _buildTextFormField('Total Marks for Each Subject', 'totalmarks')),
                  SizedBox(width: 8,),
                  Text(" x "+countNonEmptySControllers(_sControllers).toString()+" = "+ returnint().toString(),style: TextStyle(fontWeight: FontWeight.w700),),

                ],
              ),
              _buildTextFormField('Syllabus', 'syllabus', maxLines: 3),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            if(countNonEmptySControllers(_sControllers)!=countNonEmptyDControllers(_dControllers)){
              Send.message(context, "Date of each Subject must exists and equal", false);
              return;
            }
            if(_controllers['title']!.text.isEmpty){
              Send.message(context, "Title is Required", false);
              return;
            }
            if(_controllers['totalmarks']!.text.isEmpty){
              Send.message(context, "Mark of Each Subject Required", false);
              return;
            }
            try{
              TestModel testModel = TestModel(
                exam: !test,
                title: _controllers['title']!.text,
                subtitle: _controllers['subtitle']!.text,
                notes: _controllers['notes']!.text,
                attachment: _controllers['attachment']!.text,
                startdate: _controllers['startdate']!.text,
                enddate: _controllers['enddate']!.text,
                id:id,
                totalmarks: _controllers['totalmarks']!.text,
                totalsubjects: countNonEmptySControllers(_sControllers).toString(),
                syllabus: _controllers['syllabus']!.text,
                s1: _sControllers['s1']!.text,
                s2: _sControllers['s2']!.text,
                s3: _sControllers['s3']!.text,
                s4: _sControllers['s4']!.text,
                s5: _sControllers['s5']!.text,
                s6: _sControllers['s6']!.text,
                s7: _sControllers['s7']!.text,
                s8: _sControllers['s8']!.text,
                s9: _sControllers['s9']!.text,
                s10: _sControllers['s10']!.text,
                d1: _dControllers['d1']!.text,
                d2: _dControllers['d2']!.text,
                d3: _dControllers['d3']!.text,
                d4: _dControllers['d4']!.text,
                d5: _dControllers['d5']!.text,
                d6: _dControllers['d6']!.text,
                d7: _dControllers['d7']!.text,
                d8: _dControllers['d8']!.text,
                d9: _dControllers['d9']!.text,
                d10: _dControllers['d10']!.text,
              );

              // Convert to JSON
              final jsonData = testModel.toJson();
              print('TestModel JSON: $jsonData');

            await FirebaseFirestore.instance.collection('School').doc(school).
            collection('Session').doc(session).collection("Class").doc(clas)
                .collection(!(test)?"Exams":"Tests").doc(id).set(testModel.toJson());
              Navigator.pop(context);
              Send.message(context, "Success", true);
            }catch(e){
              Send.message(context, "$e", false);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child:Container(
                width: MediaQuery.of(context).size.width-10,
                height: 50,
                decoration: BoxDecoration(
                    color:Colors.orange,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text(" Add Now",style:TextStyle(fontWeight:FontWeight.w800)),
                  ],
                )
            ),
          ),
        ),
      ],
    );
  }
  String id=DateTime.now().toString();
  int returnint(){
    try {
      int y = countNonEmptySControllers(_sControllers);
      int yo = int.parse(_controllers['totalmarks']!.text);
      return yo * y;
    }catch(e){
      return 0;
    }
  }
  int countNonEmptySControllers(Map<String, TextEditingController> sControllers) {
    return sControllers.values.where((controller) => controller.text.isNotEmpty).length;
  }

  int countNonEmptyDControllers(Map<String, TextEditingController> dControllers) {
    return dControllers.values.where((controller) => controller.text.isNotEmpty).length;
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextFormField4(String label, String fieldKey,BuildContext context,
      {bool required = false, int maxLines = 1}) {
    return InkWell(
      onTap: () async {
        DateTime? dateTime = await showOmniDateTimePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate:
          DateTime(1600).subtract(const Duration(days: 3652)),
          lastDate: DateTime.now().add(
            const Duration(days: 3652),
          ),
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
        if (dateTime != null) {
          _dControllers[fieldKey]!.text = dateTime.toString();

          try {
            final currentDate = dateTime;
            final startText = _controllers['startdate']!.text;
            final endText = _controllers['enddate']!.text;

            // Initialize with current date if empty
            if (startText.isEmpty && endText.isEmpty) {
              _controllers['startdate']!.text = currentDate.toString();
              _controllers['enddate']!.text = currentDate.toString();
            }
            // Only start date exists
            else if (endText.isEmpty) {
              final startDate = DateTime.tryParse(startText);
              if (startDate != null) {
                if (currentDate.isBefore(startDate)) {
                  // New date is older - move start date to older one
                  _controllers['startdate']!.text = currentDate.toString();
                } else {
                  // New date is newer - set as end date
                  _controllers['enddate']!.text = currentDate.toString();
                }
              }
            }
            // Only end date exists
            else if (startText.isEmpty) {
              final endDate = DateTime.tryParse(endText);
              if (endDate != null) {
                if (currentDate.isAfter(endDate)) {
                  // New date is newer - move end date to newer one
                  _controllers['enddate']!.text = currentDate.toString();
                } else {
                  // New date is older - set as start date
                  _controllers['startdate']!.text = currentDate.toString();
                }
              }
            }
            // Both dates exist
            else {
              final startDate = DateTime.tryParse(startText);
              final endDate = DateTime.tryParse(endText);

              if (startDate != null && endDate != null) {
                if (currentDate.isBefore(startDate)) {
                  // New oldest date found
                  _controllers['startdate']!.text = currentDate.toString();
                }
                else if (currentDate.isAfter(endDate)) {
                  // New latest date found
                  _controllers['enddate']!.text = currentDate.toString();
                }
                // Date is between existing range - no change needed
              }
            }
          } catch (e) {
            // Fallback to setting start date if any error occurs
            _controllers['startdate']!.text = dateTime.toString();
          }
        }

      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextFormField(
          enabled: false,
          controller: _controllers.containsKey(fieldKey)
              ? _controllers[fieldKey]
              : _sControllers.containsKey(fieldKey)
              ? _sControllers[fieldKey]
              : _dControllers[fieldKey],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          readOnly: true,
          maxLines: maxLines,
          validator: required
              ? (value) => value?.isEmpty ?? true ? 'This field is required' : null
              : null,
        ),
      ),
    );
  }
  Widget _buildTextFormField(String label, String fieldKey,
      {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _controllers.containsKey(fieldKey)
            ? _controllers[fieldKey]
            : _sControllers.containsKey(fieldKey)
            ? _sControllers[fieldKey]
            : _dControllers[fieldKey],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: required
            ? (value) => value?.isEmpty ?? true ? 'This field is required' : null
            : null,
      ),
    );
  }
  Widget _buildTextFormField1(String label, String fieldKey,
      {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _controllers.containsKey(fieldKey)
            ? _controllers[fieldKey]
            : _sControllers.containsKey(fieldKey)
            ? _sControllers[fieldKey]
            : _dControllers[fieldKey],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
        maxLines: maxLines,
        validator: required
            ? (value) => value?.isEmpty ?? true ? 'This field is required' : null
            : null,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var controller in _sControllers.values) {
      controller.dispose();
    }
    for (var controller in _dControllers.values) {
      controller.dispose();
    }

  }
}