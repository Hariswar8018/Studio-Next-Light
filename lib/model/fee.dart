class FeeModel {
  late final String School_Name;
  late final String Address;
  late final String Email;
  late final String Phone;
  late final String Pic_logo;
  late final String Pic_thumbnail;
  late final String Student_Name;
  late final String S_class;
  late final String S_Section;
  late final String Registration_N;
  late final String Enrollment_N;
  late final String Parent_Phone;
  late final String Parent_Email;
  late final String Total_Fee;
  late final String MTF;
  late final String Ad_Fee;
  late final String DevF;
  late final String ExamF;
  late final String TutionF;
  late final String MonthlyF;
  late final String LetF;
  late final String TransportF;
  late final String ID_Card_Fee;
  late final bool on;
  late final String Gst;
  late final String Session;
  late final String id ;
  late final String date;
  late final String time ;
  late final String Year ;
  late final String Month ;

  FeeModel({
    required this.Year, required this.Month,
    required this.id,
    required this.date,
    required this.time,
    required this.School_Name,
    required this.Address,
    required this.Email,
    required this.Phone,
    required this.Pic_logo,
    required this.Pic_thumbnail,
    required this.Student_Name,
    required this.S_class,
    required this.S_Section,
    required this.Registration_N,
    required this.Enrollment_N,
    required this.Parent_Phone,
    required this.Parent_Email,
    required this.Total_Fee,
    required this.MTF,
    required this.Ad_Fee,
    required this.DevF,
    required this.ExamF,
    required this.TutionF,
    required this.MonthlyF,
    required this.LetF,
    required this.TransportF,
    required this.ID_Card_Fee,
    required this.on,
    required this.Gst,
    required this.Session,
  });

  FeeModel.fromJson(Map<String, dynamic> json) {
    Month = json['Month'] ?? "Jan";
    Year = json['Year'] ?? "2019";
    School_Name = json['School_Name'] ?? '';
    Address = json['Address'] ?? '';
    Email = json['Email'] ?? '';
    Phone = json['Phone'] ?? '';
    Pic_logo = json['Pic_logo'] ?? '';
    Pic_thumbnail = json['Pic_thumbnail'] ?? '';
    Student_Name = json['Student_Name'] ?? '';
    S_class = json['S_class'] ?? '';
    S_Section = json['S_Section'] ?? '';
    Registration_N = json['Registration_N'] ?? '';
    Enrollment_N = json['Enrollment_N'] ?? '';
    Parent_Phone = json['Parent_Phone'] ?? '';
    Parent_Email = json['Parent_Email'] ?? '';
    Total_Fee = json['Total_Fee'] ?? 0;
    MTF = json['MTF'] ?? 0;
    Ad_Fee = json['Ad_Fee'] ?? 0;
    DevF = json['DevF'] ?? 0;
    ExamF = json['ExamF'] ?? 0;
    TutionF = json['TutionF'] ?? 0;
    MonthlyF = json['MonthlyF'] ?? 0;
    LetF = json['LetF'] ?? 0;
    TransportF = json['TransportF'] ?? 0;
    ID_Card_Fee = json['ID_Card_Fee'] ?? 0;
    on = json['on'] ?? false;
    Gst = json['Gst'] ?? '';
    Session = json['Session'] ?? '';
    date = json['date'] ?? "j" ;
    time = json['time'] ?? "j";
    id = json['id'] ?? "h";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date ;
    data['time'] = time ;
    data['id'] = id ;
    data['School_Name'] = School_Name;
    data['Address'] = Address;
    data['Email'] = Email;
    data['Phone'] = Phone;
    data['Pic_logo'] = Pic_logo;
    data['Pic_thumbnail'] = Pic_thumbnail;
    data['Student_Name'] = Student_Name;
    data['S_class'] = S_class;
    data['S_Section'] = S_Section;
    data['Registration_N'] = Registration_N;
    data['Enrollment_N'] = Enrollment_N;
    data['Parent_Phone'] = Parent_Phone;
    data['Parent_Email'] = Parent_Email;
    data['Total_Fee'] = Total_Fee;
    data['MTF'] = MTF;
    data['Ad_Fee'] = Ad_Fee;
    data['DevF'] = DevF;
    data['ExamF'] = ExamF;
    data['TutionF'] = TutionF;
    data['MonthlyF'] = MonthlyF;
    data['LetF'] = LetF;
    data['TransportF'] = TransportF;
    data['ID_Card_Fee'] = ID_Card_Fee;
    data['on'] = on;
    data['Gst'] = Gst;
    data['Session'] = Session;
    return data;
  }
}
