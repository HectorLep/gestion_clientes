import 'package:flutter/material.dart';
import 'pages/registro_clientes_page.dart';

void main() {
  runApp(const GestionClientesApp());
}

class GestionClientesApp extends StatelessWidget {
  const GestionClientesApp({super.key});

  static const _seed = Color(0xFF185FA5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Clientes UCT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        ),
      ),
      home: const RegistroClientesPage(),
    );
  }
}