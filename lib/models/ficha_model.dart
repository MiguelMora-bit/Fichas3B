import 'dart:convert';

class Fichas {
  Fichas({
    required this.fichas,
  });

  Map<String, Ficha> fichas;

  factory Fichas.fromJson(String str) => Fichas.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Fichas.fromMap(Map<String, dynamic> json) => Fichas(
        fichas: Map.from(json["Fichas"])
            .map((k, v) => MapEntry<String, Ficha>(k, Ficha.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "Fichas": Map.from(fichas)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

class Ficha {
  Ficha({
    required this.calle1,
    required this.calle2,
    required this.colonia,
    required this.competencias,
    required this.conteos,
    required this.debilidades,
    required this.delegacion,
    required this.direccion,
    required this.fondo,
    required this.fortalezas,
    required this.fotoUrl,
    required this.frente,
    required this.generadores,
    required this.latLong,
    required this.nombreSitio,
    required this.numEmpleado,
    required this.propietario,
    required this.telefono,
    required this.ventaRenta,
  });

  String calle1;
  String calle2;
  String colonia;
  List<Map<String, dynamic>> competencias;
  List<Map<String, dynamic>> conteos;
  String debilidades;
  String delegacion;
  String direccion;
  String fondo;
  String fortalezas;
  String fotoUrl;
  String frente;
  List<Map<String, dynamic>> generadores;
  String latLong;
  String nombreSitio;
  String numEmpleado;
  String propietario;
  String telefono;
  String ventaRenta;

  factory Ficha.fromJson(String str) => Ficha.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ficha.fromMap(Map<String, dynamic> json) => Ficha(
        calle1: json["calle1"],
        calle2: json["calle2"],
        colonia: json["colonia"],
        competencias:
            List<Map<String, dynamic>>.from(json["competencias"].map((x) => x)),
        conteos: List<Map<String, dynamic>>.from(json["conteos"].map((x) => x)),
        debilidades: json["debilidades"],
        delegacion: json["delegacion"],
        direccion: json["direccion"],
        fondo: json["fondo"],
        fortalezas: json["fortalezas"],
        fotoUrl: json["fotoUrl"],
        frente: json["frente"],
        generadores:
            List<Map<String, dynamic>>.from(json["generadores"].map((x) => x)),
        latLong: json["latLong"],
        nombreSitio: json["nombreSitio"],
        numEmpleado: json["numEmpleado"],
        propietario: json["propietario"],
        telefono: json["telefono"],
        ventaRenta: json["ventaRenta"],
      );

  Map<String, dynamic> toMap() => {
        "calle1": calle1,
        "calle2": calle2,
        "colonia": colonia,
        "competencias": List<dynamic>.from(competencias.map((x) => x)),
        "conteos": List<dynamic>.from(conteos.map((x) => x)),
        "debilidades": debilidades,
        "delegacion": delegacion,
        "direccion": direccion,
        "fondo": fondo,
        "fortalezas": fortalezas,
        "fotoUrl": fotoUrl,
        "frente": frente,
        "generadores": List<dynamic>.from(generadores.map((x) => x)),
        "latLong": latLong,
        "nombreSitio": nombreSitio,
        "numEmpleado": numEmpleado,
        "propietario": propietario,
        "telefono": telefono,
        "ventaRenta": ventaRenta,
      };
}
