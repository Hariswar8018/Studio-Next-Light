
class OrderModel {
  OrderModel({
    required this.School_id,
    required this.session_id,
    required this.class_id,
  required this.class_name,
  required this.session_name,
    required this.status,
    required this.School_Name,
    required this.Time,
  });
  late final String School_id;
  late final String class_id;
  late final String class_name;
  late final String session_name;
  late final String session_id ;
  late final String status ;
  late final String School_Name;
  late final String Time;

  OrderModel.fromJson(Map<String, dynamic> json) {
    School_id = json["School"] ?? "ANY";
    session_id = json["SessionId"] ?? "76";
    class_id = json['Class_Id'] ?? 'YY';
    School_Name = json["School_Name"] ?? 'Any';
    status = json['status'] ?? "Processing";
    class_name = json['Class_Name'] ?? "Done" ;
    session_name = json['Session_Name'] ?? "Yes";
    Time = json['Time'] ?? '66';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
      data["School"] = School_id ;
     data["SessionId"] = session_id ;
     data['Class_Id'] = class_id ;
     data["School_Name"] = School_Name ;
     data['status'] = status ;
    data['Class_Name'] = class_name  ;
     data['Session_Name']  = session_name  ;
     data['Time'] = Time;
    return data;
  }
}
