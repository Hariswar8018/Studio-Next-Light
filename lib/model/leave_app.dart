import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveApp {
  LeaveApp({
    required this.stName,
    required this.stClass,
    required this.stSession,
    required this.stId,
    required this.stPic,
    required this.startDate,
    required this.endDate,
    required this.month,
    required this.year,
    required this.appPhoto,
    required this.stClassName,
    required this.stPhone,
  });

  late final String stName;
  late final String stClass;
  late final String stSession;
  late final String stId;
  late final String stPic;
  late final String startDate; // DateTime could be used if required
  late final String endDate; // DateTime could be used if required
  late final String month;
  late final String year;
  late final String appPhoto;
  late final String stClassName;
  late final String stPhone;

  LeaveApp.fromJson(Map<String, dynamic> json) {
    stName = json['stName'] ?? '';
    stClass = json['stClass'] ?? '';
    stSession = json['stSession'] ?? '';
    stId = json['stId'] ?? '';
    stPic = json['stPic'] ?? '';
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    month = json['month'] ?? '';
    year = json['year'] ?? '';
    appPhoto = json['appPhoto'] ?? '';
    stClassName = json['stClassName'] ?? '';
    stPhone = json['stPhone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stName'] = stName;
    data['stClass'] = stClass;
    data['stSession'] = stSession;
    data['stId'] = stId;
    data['stPic'] = stPic;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['month'] = month;
    data['year'] = year;
    data['appPhoto'] = appPhoto;
    data['stClassName'] = stClassName;
    data['stPhone'] = stPhone;
    return data;
  }

  static LeaveApp fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return LeaveApp.fromJson(snapshot);
  }
}
