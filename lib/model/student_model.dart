
class StudentModel {
  StudentModel({
    required this.Name,
    required this.id,
    required this.Address,
    required this.Email,
    required this.Admission_number,
    required this.Batch,
    required this.BloodGroup,
    required this.Class,
    required this.Con,
    required this.Department ,
    required this.Driver,
    required this.Father_Name,
    required this.Mobile ,
    required this.Mother_Name ,
    required this.pic,
    required this.Registration_number,
    required this.Roll_number,
    required this.Section,
    required this.Session ,
    required this.Other1,
    required this.Other2,
    required this.Other3,
    required this.Other4,
    required this.state,
    required this.dob,
  });

  late final String Name;
  late final String Admission_number ;
  late final int Roll_number ;
  late final String Father_Name ;
  late final int Mobile ;
  late final String Address ;
  late final String Email ;
  late final String Department;
  late final String Class ;
  late final String Section ;
  late final String Con ;
  late final String Driver ;
  late final String Session ;
  late final String Batch ;
  late final String id ;
  late final String pic ;
  late final String Registration_number ;
  late final String BloodGroup ;
  late final String Mother_Name ;
  late final String Other1 ;
  late final String Other2 ;
  late final String Other3 ;
  late final String Other4 ;
  late final String state;
  late final String dob;

  StudentModel.fromJson(Map<String, dynamic> json) {
    Name= json['Name'] ?? "Ayus";
    Admission_number= json['Admission_number'] ?? "NA";
    Roll_number= json['Roll_number'] ?? 0;
    Father_Name= json['Father_Name'] ?? "Afhh";
    Mobile= json['Mobile'] ?? 7978097489;
    Address= json['Address'] ?? "JAGDA, ROURELA";
    Email= json['Email'] ?? "gkgkg";
    Department= json['Department'] ?? "htfdfhf";
    Class= json['Class'] ?? "ggg";
    state = json['State'] ?? "Editing" ;
    Section= json['Section'] ?? "chhh";
    Con= json['Con'] ?? "hjvvjj";
    Driver= json['Driver'] ?? "hdh";
    Session= json['Session'] ?? "vhjv";
    dob = json['dob'] ?? "14 Oct 2023";
    Batch= json['Batch'] ?? "jj";
    id= json['id'] ?? "jjffj";
    pic= json['pic'] ?? "vhvj";
    Registration_number= json['Registration_number'] ?? "vhf";
    BloodGroup= json['BloodGroup'] ?? "NA";
    Mother_Name= json['Mother_Name'] ?? "NA";
    Other1 = json['Other1'] ?? "NA";
    Other2 = json['Other2'] ?? "NA";
    Other3 = json['Other3'] ?? "NA";
    Other4 = json['Other4'] ?? "NA";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Name'] = Name;
    data['Admission_number'] = Admission_number;
    data['Roll_number'] = Roll_number;
    data['Father_Name'] = Father_Name;
    data['Mobile'] = Mobile;
    data['Address'] = Address;
    data['Email'] = Email;
    data['Department'] = Department;
    data['Class'] = Class;
    data['Section'] = Section;
    data['Con'] = Con;
    data['Driver'] = Driver;
    data['Session'] = Session;
    data['Batch'] = Batch;
    data['id'] = id;
    data['pic'] = pic;
    data['dob'] = dob ;
    data['Registration_number'] = Registration_number;
    data['BloodGroup'] = BloodGroup;
    data['Mother_Name'] = Mother_Name;
    data['Other1'] = Other1;
    data['Other2'] = Other2;
    data['Other3'] = Other3;
    data['Other4'] = Other4;
    data['State'] = state ;
    return data;
  }
}