import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:student_managment_app/classroom_universal/academis/Test/test_model.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/student_model.dart';

class AddResult extends StatelessWidget {
  TestModel testmodel ;StudentModel student;
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



  AddResult({super.key,required this.clas,required this.school,required this.session,required this.test,required this.student,required this.testmodel}) {
    for (int i = 1; i <= 10; i++) {
      _sControllers['s$i'] = TextEditingController();
      _dControllers['d$i'] = TextEditingController();
    }
    _sControllers['s1']!.text=testmodel.s1;
    _sControllers['s2']!.text=testmodel.s2;
    _sControllers['s3']!.text=testmodel.s3;
    _sControllers['s4']!.text=testmodel.s4;
    _sControllers['s5']!.text=testmodel.s5;
    _sControllers['s6']!.text=testmodel.s6;
    _sControllers['s7']!.text=testmodel.s7;
    _sControllers['s8']!.text=testmodel.s8;
    _sControllers['s9']!.text=testmodel.s9;
    _sControllers['s10']!.text=testmodel.s10;
  }
  void initState(){
    _sControllers['s1']!.text=testmodel.s1;
    _sControllers['s2']!.text=testmodel.s2;
    _sControllers['s3']!.text=testmodel.s3;
    _sControllers['s4']!.text=testmodel.s4;
    _sControllers['s5']!.text=testmodel.s5;
    _sControllers['s6']!.text=testmodel.s6;
    _sControllers['s7']!.text=testmodel.s7;
    _sControllers['s8']!.text=testmodel.s8;
    _sControllers['s9']!.text=testmodel.s9;
    _sControllers['s10']!.text=testmodel.s10;
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
              _buildSectionHeader('Remark'),
              _buildTextFormField('Remarks', 'notes', maxLines: 3),

              _buildSectionHeader('Subjects & Marks'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2-18,
                    child: Column(
                      children: [
                        ...List.generate(10, (index) =>
                            _buildTextFormField4('Subject ${index+1}', 's${index+1}',context)),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2-18,
                    child: Column(
                      children: [
                        ...List.generate(10, (index) =>
                            _buildTextFormField('Marks ${index+1}', 'd${index+1}',)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(countNonEmptySControllers(_sControllers).toString()+" Subjects",style: TextStyle(fontWeight: FontWeight.w700),),
                  Text(countNonEmptyDControllers(_dControllers).toString()+" Marks",style: TextStyle(fontWeight: FontWeight.w700),),
                  SizedBox(),
                ],
              ),
              _buildSectionHeader('Summary'),
              Text("Total Marks : "+calculatefull().toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17),),
              Text("Total Average : "+average().toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17),),
              SizedBox(height: 10,),
              Text("Total Percentage : "+percent(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
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

            try{
              TestModel testModel = TestModel(
                exam: testmodel.exam,
                title: testmodel.title,
                subtitle: testmodel.id,
                notes: _controllers['notes']!.text,
                attachment: "",
                startdate: testmodel.startdate,
                enddate: testmodel.enddate,
                id:testmodel.id,
                totalmarks: percent(),
                totalsubjects: average().toStringAsFixed(1),
                syllabus:calculatefull().toStringAsFixed(1),
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
              final jsonData = testModel.toJson();
              print('TestModel JSON: $jsonData');

              try{
                await FirebaseFirestore.instance
                    .collection('School')
                    .doc(school)
                    .collection('Session')
                    .doc(session)
                    .collection("Class")
                    .doc(clas)
                    .collection("Student").doc(student.Registration_number)
                    .collection("Results").doc(testmodel.id)
                    .set(testModel.toJson());
              }catch(e){
                await FirebaseFirestore.instance
                    .collection('School')
                    .doc(school)
                    .collection('Session')
                    .doc(session)
                    .collection("Class")
                    .doc(clas)
                    .collection("Student").doc(student.Registration_number)
                    .collection("Results").doc(testmodel.id)
                    .update(testModel.toJson());
              }
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
  String percent(){
    double full = calculatefull();
    int divided=0;
    try{
      divided=int.parse(testmodel.totalsubjects)*int.parse(testmodel.totalmarks);
    }catch(e){
      divided=countNonEmptySControllers(_sControllers)*int.parse(testmodel.totalmarks);
    }
    return "${(full/divided)*100} %";
  }
  double average(){
    double full = calculatefull();
    int divided=0;
    try{
      divided=int.parse(testmodel.totalsubjects);
    }catch(e){
      divided=countNonEmptySControllers(_sControllers);
    }
    return full/divided;
  }

  double calculatefull(){
    double full=0;
    for (int i = 1; i <= 10; i++) {
      try {
        String s = _dControllers['d$i']!.text;
        print(s);
        double fulls = double.parse(s);
        print(fulls);
        full=full+fulls;
        print(full);
      }catch(e){
        full=full+0;
      }
    }
    print("=-======--------------------------------->");
    print(full);
    return full;
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
    return Padding(
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