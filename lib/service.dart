import 'package:flutter/material.dart';

class Servie extends StatefulWidget {
  const Servie({super.key});

  @override
  State<Servie> createState() => _ServieState();
}

class _ServieState extends State<Servie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Services"),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/WhatsApp Image 2023-12-15 at 11.02.48_210f5e8f.jpg"),
          Text("  1. Photography", style : TextStyle(fontSize : 19, fontWeight : FontWeight.w700)),
          Text("  2. Videography", style : TextStyle(fontSize : 19, fontWeight : FontWeight.w700)),
          Text("  3. Album Designing & Printing", style : TextStyle(fontSize : 19, fontWeight : FontWeight.w700)),
          Text("  4. Students ID Card Solution", style : TextStyle(fontSize : 19, fontWeight : FontWeight.w700)),
          Text("  5. Photo & Video Mixing", style : TextStyle(fontSize : 19, fontWeight : FontWeight.w700)),
        ],
      )
    );
  }
}
