# Gestión de Clientes UCT - AVANCE 60%

Aplicación empresarial en Flutter desarrollada en pareja para la ACTIVIDAD 2 - Sistema de registro de clientes.

## 🤝 Equipo de desarrollo

| Miembro | GitHub |
|---------|--------|
| Héctor Lep | https://github.com/HectorLep |
| Compañero | https://github.com/sonickiller39 |

## 🎯 Problema resuelto

Sistema completo de registro de clientes que permite:
- Ingresar datos de clientes
- Almacenarlos localmente
- Consultarlos, buscarlos y ordenarlos

## ✅ Funcionalidades implementadas (60%+)

| Feature | Estado |
|---------|--------|
| Registro de clientes | OK |
| Listado completo | OK |
| Búsqueda (debounce) | OK |
| Orden por nombre/fecha | OK |
| Editar clientes | OK |
| Soft delete (baja/reactivar) | OK |
| Export CSV (Web/Desktop) | OK |
| Validación RUT módulo 11 | OK |
| Formateo RUT en tiempo real | OK |
| Pruebas unitarias | OK |

## 🏗️ Arquitectura modular

lib/
├── models/cliente.dart
├── repositories/cliente_repositorio.dart
├── services/csv_service.dart
├── utils/validadores.dart
├── utils/rut_formatter.dart
├── pages/registro_clientes_page.dart
└── widgets/

Persistencia: SharedPreferences (listo para SQLite)  
Multiplataforma: Web + Escritorio

## 🔒 Seguridad crítica

- Protección contra CSV Injection (=, +, -, @)
- Validación de RUT módulo 11
- Unicidad de RUT y email

## 🧪 Pruebas incluidas

flutter test

## 🚀 Instalación rápida

git clone https://github.com/HectorLep/gestion_clientes.git
cd gestion_clientes
flutter pub get
flutter run

## 📱 Demo funcionalidades

Video demo: [Enlace al video] (máximo 3 min)

Flujo:
1. Registrar cliente
2. Buscar cliente
3. Dar de baja
4. Exportar CSV

## 📋 Próximas entregas (domingo 19)

- Informe PDF completo
- Video explicativo (5 min)
- Capturas de pantalla
- Mejoras UX

## 🎓 Contexto académico

ACTIVIDAD 2 - Ingeniería Civil en Informática UCT  
Propuesta: Sistema de registro de clientes  
Estado: AVANCE 60% - FUNCIONAL

---

Héctor Lep + sonickiller39  
Universidad Católica de Temuco

Instrucciones rápidas:
1. Copia este texto en README.md
2. Cambia el link del video cuando lo subas
3. Ejecuta:

git add README.md
git commit -m "docs: README avance 60% con colaborador"
git push