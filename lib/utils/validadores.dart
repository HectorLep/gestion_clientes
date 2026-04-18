class Validadores {
  Validadores._();

  static String? validarNombre(String raw) {
    final nombre = raw.trim();
    if (nombre.isEmpty) return 'El nombre es obligatorio.';
    if (nombre.length < 2) return 'Mínimo 2 caracteres.';
    if (nombre.length > 80) return 'Máximo 80 caracteres.';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(nombre)) {
      return 'Solo se permiten letras y espacios.';
    }
    if (RegExp(r'\s{2,}').hasMatch(nombre)) return 'Sin espacios dobles.';
    final partes = nombre.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.length < 2) return 'Ingresa nombre y apellido.';
    return null;
  }

  static String? validarRut(String raw) {
    if (raw.trim().isEmpty) return 'El RUT es obligatorio.';
    final rut = normalizarRut(raw);
    if (rut.length < 2) return 'RUT inválido.';
    if (!RegExp(r'^\d+[0-9Kk]$').hasMatch(rut)) return 'Caracteres no permitidos en el RUT.';
    if (rut.length < 7) return 'RUT demasiado corto.';
    if (rut.length > 9) return 'RUT demasiado largo.';
    if (!_modulo11(rut)) return 'Dígito verificador inválido (módulo 11).';
    return null;
  }

  static String? validarEmail(String raw) {
    final email = raw.trim();
    if (email.isEmpty) return 'El email es obligatorio.';
    if (email.length > 120) return 'Email demasiado largo.';
    if (!RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(email)) {
      return 'Formato de email no válido.';
    }
    return null;
  }

  static String? validarTelefono(String raw) {
    final tel = raw.trim();
    if (tel.isEmpty) return null;
    final limpio = tel.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    if (!RegExp(r'^\d{7,15}$').hasMatch(limpio)) {
      return 'Teléfono inválido (7–15 dígitos).';
    }
    return null;
  }

  static String? validarDireccion(String raw) {
    final dir = raw.trim();
    if (dir.isEmpty) return null;
    if (dir.length < 5) return 'Dirección demasiado corta.';
    if (dir.length > 150) return 'Máximo 150 caracteres.';
    return null;
  }

  static String? validarNotas(String raw) {
    if (raw.trim().length > 300) return 'Máximo 300 caracteres.';
    return null;
  }

  /// Elimina puntos, guiones y espacios; dígito verificador en MAYÚSCULA.
  static String normalizarRut(String raw) =>
      raw.trim().toUpperCase().replaceAll('.', '').replaceAll('-', '').replaceAll(' ', '');

  static bool _modulo11(String rut) {
    if (rut.length < 2) return false;
    final dvIngresado = rut[rut.length - 1]; // ya viene en MAYÚSCULA por normalizarRut
    final cuerpo = rut.substring(0, rut.length - 1);

    int suma = 0;
    int mul = 2;
    for (int i = cuerpo.length - 1; i >= 0; i--) {
      final d = int.tryParse(cuerpo[i]);
      if (d == null) return false;
      suma += d * mul;
      mul = (mul == 7) ? 2 : mul + 1;
    }

    final resultado = 11 - (suma % 11);
    final String dvEsperado;
    if (resultado == 11) {
      dvEsperado = '0';
    } else if (resultado == 10) {
      dvEsperado = 'K'; // K siempre en mayúscula
    } else {
      dvEsperado = resultado.toString();
    }

    return dvIngresado == dvEsperado;
  }
}