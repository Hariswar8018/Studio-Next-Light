
class StudentModel2 {
  StudentModel2({
    required this.Name,
    required this.id,
    required this.Mobile ,
    required this.pic,
    required this.newdob,
    required this.School_id_one,
    required this.dne ,
    required this.par
  });

  late final String Name;
  late final String Mobile ;
  late final String id ;
  late final String pic ;
  late final String School_id_one ;
  late final String newdob ;
  late final bool dne ;
  late final bool par ;

  StudentModel2.fromJson(Map<String, dynamic> json) {
    Name= json['Name'] ?? "Ayus";
    Mobile= json['Mobile'] ?? "7978097489";
    id= json['id'] ?? "jjffj";
    pic= json['pic'] ?? "vhvj";
    School_id_one = json['SCHOOLID'] ?? "";
    newdob = json['newdob'] ?? "2003-12-10 00:00:00.000";
    dne = json['dne'] ?? false ;
    par = json['par'] ?? false ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['dne'] = dne ;
    data['newdob'] = newdob ;
    data['SCHOOLID'] = School_id_one ;
    data['Mobile'] = Mobile;
    data['id'] = id;
    data['pic'] = pic;
    data['par'] = par ;
    return data;
  }
}