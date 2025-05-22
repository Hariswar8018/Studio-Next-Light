import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_managment_app/function/send.dart';
import 'package:student_managment_app/model/logmodel.dart';
import 'package:student_managment_app/model/student_model.dart';

class LogForm extends StatelessWidget {
  LogForm({super.key,required this.h , required this.r,
    required this.user,required this.showonly,
    required this.sname,
    required this.length, required this.st, required this.b,
    required this.id,
    required this.session_id,
    required this.class_id,required this.type});
  StudentModel user;bool showonly;
  int length; bool h ; //attendance edit
  String st ; bool b ; // not yet
  String id;
  bool r ; //message
  String type;
  String session_id;
  String sname ;
  String class_id;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New $type')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title of LOG/WARNING',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date of Commitment',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            if(_titleController.text.isEmpty){
              Send.message(context, "Title of $type is Required", false);
              return ;
            }
            LogModel log = LogModel(
              id: ids,
              title: _titleController.text,
              description: _descriptionController.text,
              date: _dateController.text,
            );
            try {
              await FirebaseFirestore.instance
                  .collection('School')
                  .doc(id)
                  .collection('Session')
                  .doc(session_id)
                  .collection("Class")
                  .doc(class_id)
                  .collection("Student").doc(user.Registration_number)
                  .collection(type).doc(ids)
                  .set(log.toJson());
              Navigator.pop(context);
              Send.message(context, "Success", false);
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
                    Text(" Add $type",style:TextStyle(fontWeight:FontWeight.w800)),
                  ],
                )
            ),
          ),
        ),
      ],
    );
  }
  final String ids=DateTime.now().toString();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = picked.toString();
    }
  }

  void _saveLog(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final log = LogModel(
        id: _idController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _dateController.text,
      );

      final jsonData = log.toJson();
      print('Saved Log: $jsonData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log saved successfully!')),
      );

      // Clear form after saving
      _formKey.currentState!.reset();
      _idController.clear();
      _titleController.clear();
      _descriptionController.clear();
      _dateController.clear();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
  }
}