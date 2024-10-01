class EmployeeModel {
  late final String Name;
  late final String Pic;
  late final String DOB;
  late final String Profession;
  late final String Address;
  late final String Phone;
  late final String Email;
  late final String BloodG;
  late final String Emergency_Contact;
  late final String Father_Name;
  late final String Id_number;
  late final String Registration_Number;
  late final List present;

  EmployeeModel({
    required this.Name,
    required this.present,
    required this.Pic,
    required this.DOB,
    required this.Profession,
    required this.Address,
    required this.Phone,
    required this.Email,
    required this.BloodG,
    required this.Emergency_Contact,
    required this.Father_Name,
    required this.Id_number,
    required this.Registration_Number,

  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? '';
    Pic = json['Pic'] ?? '';
    DOB = json['DOB'] ?? '';
    Profession = json['Profession'] ?? '';
    Address = json['Address'] ?? '';
    Phone = json['Phone'] ?? '';
    Email = json['Email'] ?? '';
    BloodG = json['BloodG'] ?? '';
    Emergency_Contact = json['Emergency_Contact'] ?? '';
    Father_Name = json['Father_Name'] ?? '';
    Id_number = json['Id_number'] ?? '';
    present=json['Present']??[];
    Registration_Number = json['Registration_Number'] ?? '';
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Name'] = Name;
    data['Present']=present;
    data['Pic'] = Pic;
    data['DOB'] = DOB;
    data['Profession'] = Profession;
    data['Address'] = Address;
    data['Phone'] = Phone;
    data['Email'] = Email;
    data['BloodG'] = BloodG;
    data['Emergency_Contact'] = Emergency_Contact;
    data['Father_Name'] = Father_Name;
    data['Id_number'] = Id_number;
    data['Registration_Number'] = Registration_Number;
    return data;
  }
}
