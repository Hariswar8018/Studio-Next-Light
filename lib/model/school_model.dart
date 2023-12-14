
class SchoolModel {
  SchoolModel({
    required this.Address,
    required this.Email,
    required this.Name,
    required this.Pic_link,
    required this.Students,
    required this.Pic,
    required this.id,
    required this.Adminemail,
    required this.Phone,
    required this.Clientemail,
    required this.AuthorizeSignature,
    required this.b,
    required this.Chief,
    required this.uidise,
    required this.BloodB,
  required this.DepB,
  required this.EmailB,
  required this.MotherB,
  required this.Other1B,
  required this.Other2B,
  required this.Other3B,
  required this.Other4B,
  required this.RegisB
  });

  late final String Address;
  late final String Email;
  late final String Name;
  late final String Pic_link;
  late final int Students;
  late final String Pic;
  late final String id;
  late final String Adminemail;
  late final String Clientemail;
  late final String Phone;
  late final String AuthorizeSignature;
  late final String uidise;
  late final String Chief;
  late final bool b ;
  late final bool EmailB;
  late final bool BloodB;
  late final bool DepB;
  late final bool MotherB;
  late final bool RegisB;
  late final bool Other1B;
  late final bool Other2B;
  late final bool Other3B;
  late final bool Other4B;

  SchoolModel.fromJson(Map<String, dynamic> json) {
    Address = json['Address'] ?? '1st 2018';
    Email = json['Email'] ?? 'demo@demo.com';
    Pic = json['Pic'] ?? 'http.jpg';
    Name = json['Name'] ?? 'samai';
    Pic_link = json['Pic_link'] ??
        'https://i.pinimg.com/736x/98/fc/63/98fc635fae7bb3e63219dd270f88e39d.jpg';
    Students = json['Students'] ?? 0;
    id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd';
    Adminemail = json['Admin_Email'] ?? "ad@gmail.com";
    Phone = json['Phone'] ?? "7978097489";
    Clientemail = json['Clientemail'] ?? "hariswarsamasi@gmail.com";
    AuthorizeSignature = json['AS'] ?? "https://pro-bee-user-content-eu-west-1.s3.amazonaws.com/public/users/Integrators/5eb55a21-9496-46ce-8161-f092fc9def23/bosco/Employee%20Headshots%20and%20Signatures/Christian-De-Larkin-signature.png";
    Chief = json["Chief"] ?? "AYUSMAN SAMASI";
    uidise = json['UIDSE'] ?? "662";
    b = json['On'] ?? true ;
     EmailB= json['EmailB'] ?? true ;
     BloodB= json['BloodB'] ?? true ;
     DepB= json['DepB'] ?? true ;
     MotherB= json['MotherB'] ?? true ;
     RegisB= json['RegisB'] ?? true ;
     Other1B= json['Other1B'] ?? true ;
     Other2B= json['Other2B'] ?? true ;
     Other3B= json['Other3B'] ?? true ;
     Other4B= json['Other4B'] ?? true ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Address'] = Address;
    data['Pic'] = Pic ;
    data['id'] = id ;
    data['Admin_Email'] = Adminemail ;
    data['Phone'] = Phone ;
    data['Clientemail'] = Clientemail ;
    data['Email'] = Email;
    data['Name'] = Name;
    data['Pic_link'] = Pic_link;
    data['Students'] = Students;
    data['AS'] = AuthorizeSignature;
    data['UIDSE'] = uidise;
    data['On'] = b ;
    data['Chief'] = Chief ;
    data['EmailB'] = EmailB ;
     data['BloodB'] = BloodB;
     data['DepB'] = DepB ;
     data['MotherB'] = MotherB ;
     data['RegisB'] = RegisB ;
     data['Other1B'] = Other1B ;
     data['Other2B'] = Other2B ;
     data['Other3B'] = Other3B ;
    data['Other4B'] = Other4B ;
    return data;
  }
}