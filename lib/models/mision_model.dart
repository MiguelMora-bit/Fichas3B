import 'dart:convert';

class Mision {
  Mision({
    required this.fotoUrl,
    required this.vencimiento,
  });

  String fotoUrl;

  String vencimiento;

  factory Mision.fromJson(String str) => Mision.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mision.fromMap(Map<String, dynamic> json) =>
      Mision(fotoUrl: json["fotoUrl"], vencimiento: json["vencimiento"]);

  Map<String, dynamic> toMap() =>
      {"fotoUrl": fotoUrl, "vencimiento": vencimiento};
}
