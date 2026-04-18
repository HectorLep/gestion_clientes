import 'tipo_cliente.dart';

class Cliente {
  final String nombre;
  final String rut;
  final String email;
  final String telefono;
  final String direccion;
  final String notas;
  final TipoCliente tipo;
  final DateTime fechaRegistro;
  final DateTime ultimaModificacion;
  final bool activo;

  const Cliente({
    required this.nombre,
    required this.rut,
    required this.email,
    this.telefono = '',
    this.direccion = '',
    this.notas = '',
    this.tipo = TipoCliente.nuevo,
    required this.fechaRegistro,
    required this.ultimaModificacion,
    this.activo = true,
  });

  Cliente copyWith({
    String? nombre,
    String? email,
    String? telefono,
    String? direccion,
    String? notas,
    TipoCliente? tipo,
    DateTime? ultimaModificacion,
    bool? activo,
  }) {
    return Cliente(
      nombre: nombre ?? this.nombre,
      rut: rut,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      notas: notas ?? this.notas,
      tipo: tipo ?? this.tipo,
      fechaRegistro: fechaRegistro,
      ultimaModificacion: ultimaModificacion ?? this.ultimaModificacion,
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

  String get fechaFormateada =>
      '${fechaRegistro.day.toString().padLeft(2, '0')}/'
      '${fechaRegistro.month.toString().padLeft(2, '0')}/'
      '${fechaRegistro.year}';

  String get ultimaModificacionFormateada =>
      '${ultimaModificacion.day.toString().padLeft(2, '0')}/'
      '${ultimaModificacion.month.toString().padLeft(2, '0')}/'
      '${ultimaModificacion.year} '
      '${ultimaModificacion.hour.toString().padLeft(2, '0')}:'
      '${ultimaModificacion.minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'rut': rut,
        'email': email,
        'telefono': telefono,
        'direccion': direccion,
        'notas': notas,
        'tipo': tipo.name,
        'fechaRegistro': fechaRegistro.toIso8601String(),
        'ultimaModificacion': ultimaModificacion.toIso8601String(),
        'activo': activo,
      };

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        nombre: json['nombre'] as String? ?? '',
        rut: json['rut'] as String? ?? '',
        email: json['email'] as String? ?? '',
        telefono: json['telefono'] as String? ?? '',
        direccion: json['direccion'] as String? ?? '',
        notas: json['notas'] as String? ?? '',
        tipo: TipoCliente.values.firstWhere(
          (t) => t.name == (json['tipo'] as String? ?? ''),
          orElse: () => TipoCliente.nuevo,
        ),
        fechaRegistro: json['fechaRegistro'] != null
            ? DateTime.tryParse(json['fechaRegistro'] as String) ?? DateTime.now()
            : DateTime.now(),
        ultimaModificacion: json['ultimaModificacion'] != null
            ? DateTime.tryParse(json['ultimaModificacion'] as String) ?? DateTime.now()
            : DateTime.now(),
        activo: json['activo'] as bool? ?? true,
      );
}