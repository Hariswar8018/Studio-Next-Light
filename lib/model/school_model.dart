import 'package:cloud_firestore/cloud_firestore.dart';

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
    required this.SpName,
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
    required this.RegisB,
    required this.premium,
    required this.csession,
    required this.stampp,
    required this.paidp,
    required this.smsend,
    required this.complete,
    required this.pending,
    required this.receive,
    required this.TMonth,
    required this.total,
    required this.totse,
    required this.TPaid,
    required this.TReceice,
    required this.TYear,
    // New fields
    required this.weatherlastupdate,
    required this.lat,
    required this.lon,
    required this.wind,
    required this.weather,
    required this.temp,
    required this.humidity,
    required this.pressure,
    required this.j,
    required this.token1,
    required this.token2,
  });

  late final String Address;
  late final String csession;
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
  late final bool b;
  late final bool EmailB;
  late final bool BloodB;
  late final bool DepB;
  late final bool MotherB;
  late final bool RegisB;
  late final bool Other1B;
  late final bool Other2B;
  late final bool Other3B;
  late final bool Other4B;
  late final List<Map<String, dynamic>> TReceice;
  late final List<Map<String, dynamic>> TPaid;
  late final List<Map<String, dynamic>> TMonth;
  late final List<Map<String, dynamic>> TYear;
  late final int total;
  late final int complete;
  late final int pending;
  late final int receive;
  late final bool premium;
  late final String SpName;
  late final int totse;
  final String stampp;
  final String paidp;
  late final bool smsend;
  late final String token1;
  late final String token2;

  // New fields
  late final String weatherlastupdate;
  late final double lat;
  late final double lon;
  late final double wind;
  late final String weather;
  late final double temp;
  late final double humidity;
  late final double pressure;
  late final int j;

  SchoolModel.fromJson(Map<String, dynamic> json)
      : Address = json['Address'] ?? '1st 2018',
        smsend = json['smsend'] ?? false,
        stampp = json['stampp'] ?? "https://freerangestock.com/sample/75419/technical-school-shows-stamp-print-and-stamped.jpg",
        paidp = json['paidp'] ?? "https://www.pngall.com/wp-content/uploads/14/Signature-PNG-Picture.png",
        totse = json['totse'] ?? 0,
        csession = json['cse'] ?? "",
        premium = json['premium'] ?? false,
        SpName = json['SpName'] ?? "Admin",
        total = json['Total'] ?? 0,
        pending = json['Pending'] ?? 0,
        complete = json['Complete'] ?? 0,
        receive = json['Receive'] ?? 0,
        Email = json['Email'] ?? 'demo@demo.com',
        Pic = json['Pic'] ?? 'http.jpg',
        Name = json['Name'] ?? 'samai',
        Pic_link = json['Pic_link'] ?? 'https://i.pinimg.com/736x/98/fc/63/98fc635fae7bb3e63219dd270f88e39d.jpg',
        Students = json['Students'] ?? 0,
        id = json['id'] ?? 'Xhqo6S2946pNlw8sRSKd',
        token1 = json['principaltoken'] ?? 'Xhqo6S2946pNlw8sRSKd',
        token2 = json['schooltoken'] ?? 'Xhqo6S2946pNlw8sRSKd',
        Adminemail = json['Admin_Email'] ?? "ad@gmail.com",
        Phone = json['Phone'] ?? "7978097489",
        Clientemail = json['Clientemail'] ?? "hariswarsamasi@gmail.com",
        AuthorizeSignature = json['AS'] ?? "https://pro-bee-user-content-eu-west-1.s3.amazonaws.com/public/users/Integrators/5eb55a21-9496-46ce-8161-f092fc9def23/bosco/Employee%20Headshots%20and%20Signatures/Christian-De-Larkin-signature.png",
        Chief = json["Chief"] ?? "AYUSMAN SAMASI",
        uidise = json['UIDSE'] ?? "662",
        b = json['On'] ?? true,
        EmailB = json['EmailB'] ?? true,
        BloodB = json['BloodB'] ?? true,
        DepB = json['DepB'] ?? true,
        MotherB = json['MotherB'] ?? true,
        RegisB = json['RegisB'] ?? true,
        Other1B = json['Other1B'] ?? true,
        Other2B = json['Other2B'] ?? true,
        Other3B = json['Other3B'] ?? true,
        Other4B = json['Other4B'] ?? true,
        TPaid = List<Map<String, dynamic>>.from(json['dictList'] ?? []),
        TReceice = List<Map<String, dynamic>>.from(json['dictList'] ?? []),
        TYear = List<Map<String, dynamic>>.from(json['dictList'] ?? []),
        TMonth = List<Map<String, dynamic>>.from(json['dictList'] ?? []),
  // New fields
        weatherlastupdate = json['weatherlastupdate'] ?? '',
        lat = json['lat'] ?? 16.492910,
        lon = json['lon'] ?? 80.655450,
        wind = json['wind'] ?? 0.0,
        weather = json['weather'] ?? '',
        temp = json['temp'] ?? 0.0,
        humidity = json['humidity'] ?? 0.0,
        pressure = json['pressure'] ?? 0.0,
        j = json['j'] ?? 0;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Address'] = Address;
    data['Pic'] = Pic;
    data['id'] = id;
    data['Admin_Email'] = Adminemail;
    data['Phone'] = Phone;
    data['Clientemail'] = Clientemail;
    data['Email'] = Email;
    data['Name'] = Name;
    data['Pic_link'] = Pic_link;
    data['Students'] = Students;
    data['AS'] = AuthorizeSignature;
    data['UIDSE'] = uidise;
    data['On'] = b;
    data['principaltoken']=token1;
    data['schooltoken']=token2;
    data['smsend'] = smsend;
    data['Chief'] = Chief;
    data['EmailB'] = EmailB;
    data['BloodB'] = BloodB;
    data['DepB'] = DepB;
    data['premium'] = premium;
    data['MotherB'] = MotherB;
    data['RegisB'] = RegisB;
    data['cse'] = csession;
    data['Other1B'] = Other1B;
    data['Other2B'] = Other2B;
    data['Other3B'] = Other3B;
    data['Other4B'] = Other4B;
    data['SpName'] = SpName;
    data['stampp'] = stampp;
    data['paidp'] = paidp;
    // New fields
    data['weatherlastupdate'] = weatherlastupdate;
    data['lat'] = lat;
    data['lon'] = lon;
    data['wind'] = wind;
    data['weather'] = weather;
    data['temp'] = temp;
    data['humidity'] = humidity;
    data['pressure'] = pressure;
    data['j'] = j;
    return data;
  }

  static SchoolModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SchoolModel.fromJson(snapshot);
  }
}
