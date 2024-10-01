import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusModel {
  late final String uid;
  late final String id;
  late final String name;
  late final String number;
  late final String timing;
  late final String timing2;
  late final String pic;
  late final String routeId;
  late final List people;
  late final List tokens;
  late final bool iseditable;
  late final bool couldadd;
  late final String sessionid;
  late final String schoolname;
  static Color color = Color(0xffF6BA24);
  late final DateTime date;
  BusModel({
    required this.uid,
    required this.id,
    required this.name,
    required this.number,
    required this.timing,
    required this.timing2,
    required this.pic,
    required this.routeId,
    required this.iseditable,
    required this.couldadd,
    required this.sessionid,
    required this.schoolname,
  required this.people,
  required this.tokens,
    required this.date,
  });

  // Convert Firestore Document to BusModel
  BusModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    date= (json['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    number = json['number'] ?? '';
    timing = json['timing'] ?? '';
    timing2 = json['timing2'] ?? '';
    pic = json['pic'] ?? '';
    routeId = json['routeId'] ?? '';
    people = List.from(json['people'] ?? []);
    tokens = List.from(json['tokens'] ?? []);
    iseditable = json['iseditable'] ?? true;
    couldadd = json['couldadd'] ?? true;
    sessionid = json['sessionid'] ?? '';
    schoolname = json['schoolname'] ?? '';
  }

  // Convert BusModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'number': number,
      'date':date,
      'timing': timing,
      'timing2': timing2,
      'pic': pic,
      'routeId': routeId,
      'people': people,
      'tokens': tokens,
      'iseditable': iseditable,
      'couldadd': couldadd,
      'sessionid': sessionid,
      'schoolname': schoolname,
    };
  }

  static BusModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return BusModel.fromJson(snapshot);
  }
}
