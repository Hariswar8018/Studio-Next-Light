class TestModel {
  TestModel({
    required this.exam,
    required this.title,
    required this.subtitle,
    required this.notes,
    required this.attachment,
    required this.startdate,
    required this.enddate,
    required this.id,
    required this.totalmarks,
    required this.totalsubjects,
    required this.s1,
    required this.s2,
    required this.s3,
    required this.s4,
    required this.s5,
    required this.s6,
    required this.s7,
    required this.s8,
    required this.s9,
    required this.s10,
    required this.d1,
    required this.d2,
    required this.d3,
    required this.d4,
    required this.d5,
    required this.d6,
    required this.d7,
    required this.d8,
    required this.d9,
    required this.d10,
    required this.syllabus,
  });

  late final bool exam;
  late final String title;
  late final String subtitle;
  late final String notes;
  late final String attachment;
  late final String startdate;
  late final String enddate;
  late final String id;
  late final String totalmarks;
  late final String totalsubjects;
  late final String s1;
  late final String s2;
  late final String s3;
  late final String s4;
  late final String s5;
  late final String s6;
  late final String s7;
  late final String s8;
  late final String s9;
  late final String s10;
  late final String d1;
  late final String d2;
  late final String d3;
  late final String d4;
  late final String d5;
  late final String d6;
  late final String d7;
  late final String d8;
  late final String d9;
  late final String d10;
  late final String syllabus;

  TestModel.fromJson(Map<String, dynamic> json) {
    exam = json['exam'] ?? false;
    title = json['title'] ?? "";
    subtitle = json['subtitle'] ?? "";
    notes = json['notes'] ?? "";
    attachment = json['attachment'] ?? "";
    startdate = json['startdate'] ?? "";
    enddate = json['enddate'] ?? "";
    id = json['id'] ?? "";
    totalmarks = json['totalmarks'] ?? "";
    totalsubjects = json['totalsubjects'] ?? "";
    s1 = json['s1'] ?? "";
    s2 = json['s2'] ?? "";
    s3 = json['s3'] ?? "";
    s4 = json['s4'] ?? "";
    s5 = json['s5'] ?? "";
    s6 = json['s6'] ?? "";
    s7 = json['s7'] ?? "";
    s8 = json['s8'] ?? "";
    s9 = json['s9'] ?? "";
    s10 = json['s10'] ?? "";
    d1 = json['d1'] ?? "";
    d2 = json['d2'] ?? "";
    d3 = json['d3'] ?? "";
    d4 = json['d4'] ?? "";
    d5 = json['d5'] ?? "";
    d6 = json['d6'] ?? "";
    d7 = json['d7'] ?? "";
    d8 = json['d8'] ?? "";
    d9 = json['d9'] ?? "";
    d10 = json['d10'] ?? "";
    syllabus = json['syllabus'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['exam'] = exam;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['notes'] = notes;
    data['attachment'] = attachment;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['id'] = id;
    data['totalmarks'] = totalmarks;
    data['totalsubjects'] = totalsubjects;
    data['s1'] = s1;
    data['s2'] = s2;
    data['s3'] = s3;
    data['s4'] = s4;
    data['s5'] = s5;
    data['s6'] = s6;
    data['s7'] = s7;
    data['s8'] = s8;
    data['s9'] = s9;
    data['s10'] = s10;
    data['d1'] = d1;
    data['d2'] = d2;
    data['d3'] = d3;
    data['d4'] = d4;
    data['d5'] = d5;
    data['d6'] = d6;
    data['d7'] = d7;
    data['d8'] = d8;
    data['d9'] = d9;
    data['d10'] = d10;
    data['syllabus'] = syllabus;
    return data;
  }
}