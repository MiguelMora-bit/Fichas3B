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
  Ficha(
      {required this.nombreEmpleado,
      required this.puesto,
      required this.tienda,
      required this.calle1,
      required this.calle2,
      required this.colonia,
      required this.costo,
      required this.estado,
      required this.competencias,
      required this.delegacion,
      required this.direccion,
      required this.fondo,
      required this.fotoUrl,
      required this.frente,
      required this.generadores,
      required this.latLong,
      required this.nombreSitio,
      required this.numEmpleado,
      required this.propietario,
      required this.telefono,
      required this.ventaRenta,
      required this.tipoInmueble,
      required this.fecha,
      required this.codigoPostal,
      required this.correo,
      required this.folio,
      required this.celular});

  String folio;
  String nombreEmpleado;
  String puesto;
  String tienda;
  String calle1;
  String calle2;
  String colonia;
  String estado;
  String correo;
  List<Map<String, dynamic>> competencias;
  String delegacion;
  String direccion;
  String fondo;
  String fotoUrl;
  String frente;
  String celular;
  List<Map<String, dynamic>> generadores;
  String latLong;
  String nombreSitio;
  String numEmpleado;
  String propietario;
  String telefono;
  String ventaRenta;
  String costo;
  String tipoInmueble;
  String fecha;
  String codigoPostal;

  factory Ficha.fromJson(String str) => Ficha.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ficha.fromMap(Map<String, dynamic> json) => Ficha(
      folio: json["folio"],
      nombreEmpleado: json["nombreEmpleado"],
      puesto: json["puesto"],
      tienda: json["tienda"],
      calle1: json["calle1"],
      calle2: json["calle2"],
      colonia: json["colonia"],
      estado: json["estado"],
      costo: json["costo"],
      tipoInmueble: json["tipoInmueble"],
      competencias:
          List<Map<String, dynamic>>.from(json["competencias"].map((x) => x)),
      delegacion: json["delegacion"],
      direccion: json["direccion"],
      fondo: json["fondo"],
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
      fecha: json["fecha"],
      codigoPostal: json["codgoPostal"],
      correo: json["correo"],
      celular: json["celular"]);

  Map<String, dynamic> toMap() => {
        "folio": folio,
        "nombreEmpleado": nombreEmpleado,
        "puesto": puesto,
        "tienda": tienda,
        "calle1": calle1,
        "calle2": calle2,
        "colonia": colonia,
        "estado": estado,
        "costo": costo,
        "competencias": List<dynamic>.from(competencias.map((x) => x)),
        "delegacion": delegacion,
        "direccion": direccion,
        "fondo": fondo,
        "fotoUrl": fotoUrl,
        "frente": frente,
        "generadores": List<dynamic>.from(generadores.map((x) => x)),
        "latLong": latLong,
        "nombreSitio": nombreSitio,
        "numEmpleado": numEmpleado,
        "propietario": propietario,
        "telefono": telefono,
        "ventaRenta": ventaRenta,
        "tipoInmueble": tipoInmueble,
        "fecha": fecha,
        "codigoPostal": codigoPostal,
        "correo": correo,
        "celular": celular
      };
}
