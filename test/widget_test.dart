import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_clientes/main.dart';

void main() {
  testWidgets('La app muestra la pantalla principal', (WidgetTester tester) async {
    await tester.pumpWidget(const GestionClientesApp());
    await tester.pumpAndSettle();

    expect(find.text('Gestión de Clientes UCT'), findsWidgets);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}