import 'package:flutter/material.dart';
import 'package:student_managment_app/model/bus.dart';

class BusCard extends StatelessWidget {
  BusModel bus;bool edit;
  BusCard({super.key,required this.bus,required this.edit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BusModel.color,
        title: Text("Bus Name : "+bus.name),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
