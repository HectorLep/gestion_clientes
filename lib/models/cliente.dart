class Cliente {
  final String nombre;
  final String rut;
  final String email;
  final DateTime fechaRegistro;
  final bool activo;

  const Cliente({
    required this.nombre,
    required this.rut,
    required this.email,
    required this.fechaRegistro,
    this.activo = true,
  });

  Cliente copyWith({
    String? nombre,
    String? email,
    DateTime? fechaRegistro,
    bool? activo,
  }) {
    return Cliente(
      nombre: nombre ?? this.nombre,
      rut: rut,
      email: email ?? this.email,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      activo: activo ?? this.activo,
    );
  }

  String get rutFormateado {
    final cuerpo = rut.substring(0, rut.length - 1);
    final dv = rut.substring(rut.length - 1);
    final buffer = StringBuffer();
    for (int i = 0; i < cuerpo.length; i++) {
      if (i > 0 && (cuerpo.length - i) % 3 == 0) buffer.write('.');
      buffer.write(cuerpo[i]);
    }
    return '${buffer.toString()}-$dv';
  }

  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    return partes.take(2).map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
  }

  String get fechaFormateada {
    return '${fechaRegistro.day.toString().padLeft(2, '0')}/'
        '${fechaRegistro.month.toString().padLeft(2, '0')}/'
        '${fechaRegistro.year}';
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'rut': rut,
        'email': email,
        'fechaRegistro': fechaRegistro.toIso8601String(),
        'activo': activo,
      };

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        nombre: json['nombre'] as String? ?? '',
        rut: json['rut'] as String? ?? '',
        email: json['email'] as String? ?? '',
        fechaRegistro: json['fechaRegistro'] != null
            ? DateTime.tryParse(json['fechaRegistro'] as String) ?? DateTime.now()
            : DateTime.now(),
        activo: json['activo'] as bool? ?? true,
      );
}