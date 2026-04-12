import 'package:flutter/material.dart';

class BuscadorField extends StatelessWidget {
  final TextEditingController controller;

  const BuscadorField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, RUT o email…',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}