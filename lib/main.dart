import 'package:flutter/material.dart';
import 'pages/registro_clientes_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GestionClientesApp());
}

class GestionClientesApp extends StatelessWidget {
  const GestionClientesApp({super.key});

  static const _azulUCT = Color(0xFF1A5C9A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Clientes UCT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _azulUCT,
          primary: _azulUCT,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          isDense: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _azulUCT,
            foregroundColor: Colors.white,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _azulUCT,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const RegistroClientesPage(),
    );
  }
}