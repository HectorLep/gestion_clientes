import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_clientes/utils/validadores.dart';

void main() {
  group('Validador RUT — módulo 11', () {
    test('RUT válido normal', () {
      expect(Validadores.validarRut('12.345.678-9'), isNull);
    });

    test('RUT válido con dígito K', () {
      expect(Validadores.validarRut('5.126.663-K'), isNull);
    });

    test('RUT inválido — dígito verificador incorrecto', () {
      expect(Validadores.validarRut('12.345.678-0'), isNotNull);
    });

    test('RUT vacío', () {
      expect(Validadores.validarRut(''), isNotNull);
    });

    test('RUT demasiado corto', () {
      expect(Validadores.validarRut('123-4'), isNotNull);
    });

    test('Normalización de RUT', () {
      expect(Validadores.normalizarRut('12.345.678-9'), '123456789');
      expect(Validadores.normalizarRut('5.126.663-k'), '5126663K');
    });
  });

  group('Validador Nombre', () {
    test('Nombre válido', () {
      expect(Validadores.validarNombre('Juan Pérez'), isNull);
    });

    test('Solo un nombre sin apellido', () {
      expect(Validadores.validarNombre('Juan'), isNotNull);
    });

    test('Con números', () {
      expect(Validadores.validarNombre('Juan123 Pérez'), isNotNull);
    });

    test('Vacío', () {
      expect(Validadores.validarNombre(''), isNotNull);
    });
  });

  group('Validador Email', () {
    test('Email válido', () {
      expect(Validadores.validarEmail('test@empresa.cl'), isNull);
    });

    test('Sin arroba', () {
      expect(Validadores.validarEmail('testempresa.cl'), isNotNull);
    });

    test('Vacío', () {
      expect(Validadores.validarEmail(''), isNotNull);
    });
  });

  group('Validador Teléfono', () {
    test('Teléfono válido', () {
      expect(Validadores.validarTelefono('+56912345678'), isNull);
    });

    test('Vacío es válido (opcional)', () {
      expect(Validadores.validarTelefono(''), isNull);
    });

    test('Demasiado corto', () {
      expect(Validadores.validarTelefono('123'), isNotNull);
    });
  });
}