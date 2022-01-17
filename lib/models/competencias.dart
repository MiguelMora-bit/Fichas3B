class Competencia {
  final String nombre;
  final int distancia;

  const Competencia({
    required this.nombre,
    required this.distancia,
  });

  Competencia copy({
    String? nombre,
    int? distancia,
  }) =>
      Competencia(
        nombre: nombre ?? this.nombre,
        distancia: distancia ?? this.distancia,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Competencia &&
          runtimeType == other.runtimeType &&
          nombre == other.nombre &&
          distancia == other.distancia;

  @override
  int get hashCode => nombre.hashCode ^ distancia.hashCode;
}
