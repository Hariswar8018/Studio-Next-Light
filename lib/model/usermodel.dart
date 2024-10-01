import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.pic,
    required this.position,
    required this.last,
    required this.verified,
    required this.probation,
    required this.school,
    required this.schoolid,
    required this.schoolpic, // Added field
    required this.sessionid,
    required this.classid,
    required this.smsend,
    required this.whatsend,
    required this.apisend,
    required this.scan,
    required this.update,
    required this.notify,
    required this.admin,
    required this.admin2,
    required this.token, // Added field
  });

  late final String name;
  late final String email;
  late final String uid;
  late final String pic;
  late final String position;
  late final String last;
  late final bool verified;
  late final bool probation;
  late final String school;
  late final String schoolid;
  late final String schoolpic; // Added field
  late final String sessionid;
  late final String classid;
  late final bool smsend;
  late final bool whatsend;
  late final bool apisend;
  late final bool scan;
  late final bool update;
  late final bool notify;
  late final bool admin;
  late final bool admin2;
  late final String token; // Added field

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    uid = json['uid'] ?? '';
    pic = json['pic'] ?? '';
    position = json['position'] ?? '';
    last = json['last'] ?? '';
    verified = json['verified'] ?? false;
    probation = json['probation'] ?? false;
    school = json['school'] ?? '';
    schoolid = json['schoolid'] ?? '';
    schoolpic = json['schoolpic'] ?? ''; // Added field
    sessionid = json['sessionid'] ?? '';
    classid = json['classid'] ?? '';
    smsend = json['smsend'] ?? false;
    whatsend = json['whatsend'] ?? false;
    apisend = json['apisend'] ?? false;
    scan = json['scan'] ?? false;
    update = json['update'] ?? false;
    notify = json['notify'] ?? false;
    admin = json['admin'] ?? false;
    admin2 = json['admin2'] ?? false;
    token = json['token'] ?? ''; // Added field
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['uid'] = uid;
    data['pic'] = pic;
    data['position'] = position;
    data['last'] = last;
    data['verified'] = verified;
    data['probation'] = probation;
    data['school'] = school;
    data['schoolid'] = schoolid;
    data['schoolpic'] = schoolpic; // Added field
    data['sessionid'] = sessionid;
    data['classid'] = classid;
    data['smsend'] = smsend;
    data['whatsend'] = whatsend;
    data['apisend'] = apisend;
    data['scan'] = scan;
    data['update'] = update;
    data['notify'] = notify;
    data['admin'] = admin;
    data['admin2'] = admin2;
    data['token'] = token; // Added field
    return data;
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}
