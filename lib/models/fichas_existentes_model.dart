import 'dart:convert';

class FichaExistente {
  FichaExistente({
    required this.folio,
    required this.delegacion,
    this.comentario,
    required this.fotoUrl,
    this.status,
  });

  String folio;

  String delegacion;

  String? comentario;

  String fotoUrl;

  String? status;

  factory FichaExistente.fromJson(String str) =>
      FichaExistente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FichaExistente.fromMap(Map<String, dynamic> json) => FichaExistente(
      delegacion: json["delegacion"],
      fotoUrl: json["fotoUrl"],
      status: json["status"] ?? "Sin revisar",
      folio: json["folio"],
      comentario: json["comentario"] ?? "");

  Map<String, dynamic> toMap() => {
        "folio": folio,
        "delegacion": delegacion,
        "fotoUrl": fotoUrl,
        "status": status ?? "Sin revisar",
        "comentaro": comentario ?? ""
      };
}
