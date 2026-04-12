import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/rut_formatter.dart';

class PanelFormulario extends StatelessWidget {
  final TextEditingController nombreCtrl;
  final TextEditingController rutCtrl;
  final TextEditingController emailCtrl;
  final String? errorNombre;
  final String? errorRut;
  final String? errorEmail;
  final bool modoEdicion;
  final VoidCallback onGuardar;
  final VoidCallback? onCancelar;

  const PanelFormulario({
    super.key,
    required this.nombreCtrl,
    required this.rutCtrl,
    required this.emailCtrl,
    required this.errorNombre,
    required this.errorRut,
    required this.errorEmail,
    required this.modoEdicion,
    required this.onGuardar,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: modoEdicion ? const Color(0xFF185FA5) : Colors.grey.shade200,
            width: modoEdicion ? 1.5 : 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (modoEdicion)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF185FA5)),
                      const SizedBox(width: 6),
                      const Text(
                        'Editando cliente',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF185FA5),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: onCancelar,
                        icon: const Icon(Icons.close, size: 14),
                        label: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              TextField(
                controller: nombreCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: errorNombre,
                  helperText: 'Ej: Juan Pérez Soto',
                ),
                maxLength: 80,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]')),
                ],
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 4),
              TextField(
                controller: rutCtrl,
                enabled: !modoEdicion,
                decoration: InputDecoration(
                  labelText: 'RUT',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  errorText: errorRut,
                  helperText: modoEdicion
                      ? 'El RUT no puede modificarse'
                      : 'Ej: 12.345.678-9',
                ),
                maxLength: 12,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  RutInputFormatter(),
                ],
              ),
              const SizedBox(height: 4),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: errorEmail,
                  helperText: 'Ej: juan.perez@empresa.cl',
                ),
                maxLength: 120,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: onGuardar,
                icon: Icon(modoEdicion ? Icons.save_outlined : Icons.person_add_outlined),
                label: Text(modoEdicion ? 'GUARDAR CAMBIOS' : 'REGISTRAR CLIENTE'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}