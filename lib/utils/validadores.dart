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
    if (!RegExp(r'^[0-9Kk]+$').hasMatch(rut)) return 'Caracteres no permitidos.';
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

  static String normalizarRut(String raw) =>
      raw.trim().toUpperCase().replaceAll('.', '').replaceAll('-', '').replaceAll(' ', '');

  static bool _modulo11(String rut) {
    if (rut.length < 2) return false;
    final dv = rut[rut.length - 1];
    final cuerpo = rut.substring(0, rut.length - 1);
    int suma = 0, mul = 2;
    for (int i = cuerpo.length - 1; i >= 0; i--) {
      final d = int.tryParse(cuerpo[i]);
      if (d == null) return false;
      suma += d * mul;
      mul = (mul == 7) ? 2 : mul + 1;
    }
    final res = 11 - (suma % 11);
    final dvE = res == 11 ? '0' : (res == 10 ? 'K' : res.toString());
    return dv == dvE;
  }
}