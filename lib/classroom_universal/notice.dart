class Notice1 {
  Notice1({
    required this.id,
    required this.date,
    required this.date2,
    required this.name,
    required this.description,
    required this.link,
    required this.pic,
    required this.namet,
    required this.coTeach,
    required this.classteacher,
    required this.follo,
    required this.type,
    required this.attachment,
  });

  late final List follo;
  late final String type;
  late final String id;
  late final String date;
  late final String date2;
  late final String name;
  late final String description;
  late final String link;
  late final String pic;
  late final String namet;
  late final String attachment;
  late final bool coTeach;
  late final bool classteacher;

  Notice1.fromJson(Map<String, dynamic> json) {
    follo = json['follo'] ?? [];
    type = json['type'] ?? "";
    id = json['id'] ?? '';
    date = json['date'] ?? '';
    date2 = json['date2'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    link = json['link'] ?? '';
    pic = json['pic'] ?? '';
    namet = json['namet'] ?? '';
    attachment = json['attachment'] ?? '';
    coTeach = json['coTeach'] ?? false;
    classteacher = json['classteacher'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['follo'] = follo;
    data['id'] = id;
    data['date'] = date;
    data['date2'] = date2;
    data['name'] = name;
    data['type'] = type;
    data['description'] = description;
    data['link'] = link;
    data['pic'] = pic;
    data['namet'] = namet;
    data['attachment'] = attachment;
    data['coTeach'] = coTeach;
    data['classteacher'] = classteacher;
    return data;
  }
}

enum type_class { meeting, homework, proposal, notice,assignment }