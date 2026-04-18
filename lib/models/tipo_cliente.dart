import 'package:flutter/material.dart';

enum TipoCliente { nuevo, frecuente, vip, moroso }

extension TipoClienteExt on TipoCliente {
  String get etiqueta => TipoClienteHelper.etiqueta(this);
  Color get color => TipoClienteHelper.color(this);
  Color get colorFondo => TipoClienteHelper.colorFondo(this);
  IconData get icono => TipoClienteHelper.icono(this);
}

class TipoClienteHelper {
  TipoClienteHelper._();

  static String etiqueta(TipoCliente t) {
    switch (t) {
      case TipoCliente.nuevo:
        return 'Nuevo';
      case TipoCliente.frecuente:
        return 'Frecuente';
      case TipoCliente.vip:
        return 'VIP';
      case TipoCliente.moroso:
        return 'Moroso';
    }
  }

  static Color color(TipoCliente t) {
    switch (t) {
      case TipoCliente.nuevo:
        return const Color(0xFF006B75);
      case TipoCliente.frecuente:
        return const Color(0xFF1A5C9A);
      case TipoCliente.vip:
        return const Color(0xFFB8860B);
      case TipoCliente.moroso:
        return const Color(0xFFB22222);
    }
  }

  static Color colorFondo(TipoCliente t) {
    switch (t) {
      case TipoCliente.nuevo:
        return const Color(0xFFE0F4F4);
      case TipoCliente.frecuente:
        return const Color(0xFFDCEEFB);
      case TipoCliente.vip:
        return const Color(0xFFFFF8DC);
      case TipoCliente.moroso:
        return const Color(0xFFFFE4E1);
    }
  }

  static IconData icono(TipoCliente t) {
    switch (t) {
      case TipoCliente.nuevo:
        return Icons.fiber_new_outlined;
      case TipoCliente.frecuente:
        return Icons.repeat_outlined;
      case TipoCliente.vip:
        return Icons.star_outlined;
      case TipoCliente.moroso:
        return Icons.warning_amber_outlined;
    }
  }
}