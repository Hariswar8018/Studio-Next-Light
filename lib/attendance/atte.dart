import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Map<String, List<String>> attendanceData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('School').doc("h").collection('Session').doc("1700832878528").collection("Class").doc("1701347845635").collection("Student").get();
    final data = snapshot.docs.asMap().map((key, doc) => MapEntry(doc.id, List<String>.from(doc.data()['dates'] ?? [])));

    setState(() {
      attendanceData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      body: attendanceData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : AttendanceWidget(attendanceData: attendanceData),
    );
  }
}

class AttendanceWidget extends StatelessWidget {
  final Map<String, List<String>> attendanceData;

  AttendanceWidget({required this.attendanceData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row with dates
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(30, (index) => Text((index + 1).toString())),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: attendanceData.length > 40 ? attendanceData.length : 40,
            itemBuilder: (context, index) {
              if (index >= attendanceData.length) {
                // If index exceeds the number of students, create an empty row
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(30, (day) => Text('A')),
                );
              }

              String key = attendanceData.keys.elementAt(index);
              List<String> dates = attendanceData[key]!;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(30, (day) {
                  return Text(dates.contains((day + 1).toString()) ? 'P' : 'A');
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
