class GateKeeper {
  late final String id;
  late final String parentname;
  late final String studentname;
  late final String classs;
  late final bool verified;
  late final bool accept;
  late final String timenow;
  late final String timeleave;
  late final String phone;
  late final String email;
  late final String pic;
  late final String pic2sign;
  late final String reason;

  GateKeeper({
    required this.id,
    required this.parentname,
    required this.studentname,
    required this.classs,
    required this.verified,
    required this.accept,
    required this.timenow,
    required this.timeleave,
    required this.phone,
    required this.email,
    required this.pic,
    required this.pic2sign,
    required this.reason,
  });

  GateKeeper.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    parentname = json['parentname'] ?? '';
    studentname = json['studentname'] ?? '';
    classs = json['classs'] ?? 'X(A)';
    verified = json['verified'] ?? false;
    accept = json['accept'] ?? false;
    timenow = json['timenow'] ?? '';
    timeleave = json['timeleave'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    pic = json['pic'] ?? '';
    pic2sign = json['pic2sign'] ?? '';
    reason = json['reason'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['parentname'] = parentname;
    data['studentname'] = studentname;
    data['classs'] = classs;
    data['verified'] = verified;
    data['accept'] = accept;
    data['timenow'] = timenow;
    data['timeleave'] = timeleave;
    data['phone'] = phone;
    data['email'] = email;
    data['pic'] = pic;
    data['pic2sign'] = pic2sign;
    data['reason'] = reason;
    return data;
  }
}
