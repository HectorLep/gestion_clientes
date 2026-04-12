import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_clientes/utils/validadores.dart';

void main() {
  group('Pruebas de Validadores', () {
    group('Validación de RUT', () {
      test('RUT válido debe retornar null', () {
        expect(Validadores.validarRut('19.234.567-2'), null);
      });

      test('RUT inválido debe retornar error', () {
        expect(Validadores.validarRut('19.234.567-9'), isNotNull);
      });

      test('RUT vacío debe retornar error', () {
        expect(Validadores.validarRut(''), isNotNull);
      });
    });

    group('Validación de Email', () {
      test('Email válido debe retornar null', () {
        expect(Validadores.validarEmail('juan@empresa.cl'), null);
      });

      test('Email inválido debe retornar error', () {
        expect(Validadores.validarEmail('juanempresa.cl'), isNotNull);
      });
    });

    group('Validación de Nombre', () {
      test('Nombre válido debe retornar null', () {
        expect(Validadores.validarNombre('Juan Pérez'), null);
      });

      test('Nombre con un solo término debe retornar error', () {
        expect(Validadores.validarNombre('Juan'), isNotNull);
      });
    });
  });
}