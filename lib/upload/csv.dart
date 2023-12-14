import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportFirestoreCollectionToCsv(String id , String session_id, String class_id, context) async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
  await FirebaseFirestore.instance.collection('School').doc(id).collection('Session').doc(session_id).collection("Class").doc(class_id).collection("Student").get();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Started'),
    ),
  );
  List<List<dynamic>> csvData = [];

  // Add CSV headers
  csvData.add(querySnapshot.docs.first.data()!.keys.toList());
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Still Doing'),
    ),
  );
  // Add data rows
  for (var doc in querySnapshot.docs) {
    csvData.add(doc.data()!.values.toList());
  }

  // Convert to CSV format
  String csv = ListToCsvConverter().convert(csvData);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Almost'),
    ),
  );
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String filePath = '$appDocPath/exported_data.csv';
  // Save to a file
  File file = File(filePath); // Replace with your desired file path
  await file.writeAsString(csv);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Done : $filePath'),
    ),
  );
  print('CSV exported successfully to: ${file.path}');
}