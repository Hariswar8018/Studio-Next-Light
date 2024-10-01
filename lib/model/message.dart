class Messages {
  Messages({
    required this.read,
    required this.told,
    required this.from,
    required this.mes,
    required this.type,
    required this.sent,
    required this.teach,
    required this.uidd,
    required this.pic,
    required this.name,
  });
  late final String read;
  late final String told;
  late final String from;
  late final String mes;
  late final Type type;
  late final String sent;
  late final bool teach ;
  late final String name ;
  late final String pic ;
  late final String uidd ;
  Messages.fromJson(Map<String, dynamic> json){
    name = json['name'] ?? "Ayus";
    pic = json['pic'] ?? "https://pbs.twimg.com/media/B0su0LSCEAAngqQ.jpg";
    uidd = json['uidd'] ?? "u";
    read = json['read'];
    teach = json['teach'] ?? false ;
    told = json['told'];
    from = json['from'];
    mes = json['mes'];
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'];
  }

  Map<String, dynamic> toJson(Messages messages) {
    final _data = <String, dynamic>{};
    _data['read'] = read;
    _data['pic'] = pic ;
    _data['name'] = name ;
    _data['uidd'] = uidd ;
    _data['teach'] = teach ;
    _data['told'] = told;
    _data['from'] = from;
    _data['mes'] = mes;
    _data['type'] = type.name;
    _data['sent'] = sent;
    return _data;
  }
}

enum Type {text, image}
