# Gestión de Clientes UCT

Aplicación empresarial multiplataforma en Flutter desarrollada en pareja para la
**Actividad 2** — Sistema de registro y gestión de clientes.

---

## 📦 Descargas

> Binarios listos para usar — no requieren compilar el proyecto.

| Plataforma | Archivo | Instrucciones |
|------------|---------|---------------|
| 🪟 Windows | [gestion_clientes_windows.zip](https://github.com/HectorLep/gestion_clientes/raw/main/releases/gestion_clientes_windows.zip) | Extraer el ZIP completo y ejecutar `gestion_clientes.exe` |
| 🤖 Android | [app-release.apk](https://github.com/HectorLep/gestion_clientes/releases/latest/download/app-release.apk) | Habilitar *Fuentes desconocidas* e instalar el APK |

> ⚠️ **Windows:** el `.exe` solo no funciona. Debe ejecutarse desde la carpeta extraída junto a todos los `.dll`.

---

## 🖼️ Capturas de pantalla

### 🪟 Windows
![App Windows](https://github.com/HectorLep/gestion_clientes/blob/main/assets/images/windows_app.png?raw=true)

### 🤖 Android
<img src="https://github.com/HectorLep/gestion_clientes/blob/main/assets/images/android_app.jpeg?raw=true" width="300" alt="App Android"/>
---

## 🤝 Equipo de desarrollo

| Miembro       | GitHub                                            |
|---------------|---------------------------------------------------|
| Héctor Lepio  | [@HectorLep](https://github.com/HectorLep)        |
| Agustín Vega  | [@sonickiller39](https://github.com/sonickiller39) |

---

## 🎯 Descripción

Sistema completo de gestión de clientes con soporte para **Windows, Android y Web**
(incluyendo el servidor Pillán UCT), que permite registrar, consultar, editar y exportar
clientes con validación de datos chilenos (RUT módulo 11) y arquitectura desacoplada
por capas.

---

## ✅ Funcionalidades

### Gestión de clientes
- Registro con nombre, RUT, email, teléfono, dirección y notas
- Clasificación por tipo: Nuevo, Frecuente, VIP, Moroso
- Edición de datos (RUT no modificable tras el registro)
- Baja lógica con confirmación (**soft delete** — no se elimina el registro)
- Reactivación de clientes dados de baja

### Búsqueda y filtros
- Búsqueda en tiempo real con debounce de 300 ms (nombre, RUT, email)
- Filtro por tipo de cliente
- Ordenamiento por nombre o fecha de registro (más recientes primero)
- Mostrar/ocultar clientes inactivos

### Exportación
- Exportación a CSV con todos los campos
- Protección contra **CSV Injection** (neutraliza prefijos `=`, `+`, `-`, `@`)
- Detección automática de plataforma:
  - **Web:** descarga directa en el navegador (`dart:html`)
  - **Nativo:** guarda en carpeta de documentos del sistema (`dart:io`)

### Validación y UX
- Validación de RUT chileno con algoritmo **módulo 11** en tiempo real
- Formateo automático de RUT (`12.345.678-9`) mientras se escribe
- Unicidad de RUT y email con mensajes de error por campo
- Estadísticas en tiempo real: activos, inactivos, filtrados
- Estado vacío animado con acción sugerida
- Layout responsivo (móvil y escritorio), ancho máximo de 800 px

---

## 🏗️ Arquitectura

```text
lib/
├── main.dart                      # Punto de entrada; configura tema global
├── models/
│   └── cliente.dart               # Entidad Cliente + serialización JSON
├── repositories/
│   ├── cliente_repositorio.dart   # Interfaz abstracta de persistencia
│   ├── cliente_repo_sqlite.dart   # Implementación SQLite (nativo)
│   └── cliente_repo_prefs.dart    # Implementación SharedPreferences (web)
├── controllers/
│   └── clientes_controller.dart   # Lógica: filtrado, debounce, orden
├── services/
│   ├── csv_service.dart           # Generación y descarga de CSV
│   ├── csv_exporter_stub.dart     # Interfaz stub multi-plataforma
│   ├── csv_exporter_io.dart       # Exportación nativa (dart:io)
│   └── csv_exporter_web.dart      # Exportación web (dart:html)
├── utils/
│   └── validadores.dart           # Módulo 11, nombre, email
├── widgets/
│   ├── panel_formulario.dart      # Formulario de registro/edición
│   ├── stats_row.dart             # Fila de indicadores estadísticos
│   ├── buscador_field.dart        # Campo de búsqueda con debounce
│   ├── lista_clientes.dart        # Lista con tarjetas por cliente
│   └── estado_vacio.dart          # Estado vacío animado
└── pages/
    └── registro_clientes_page.dart  # Pantalla principal
```

**Patrón:** MVC modificado con Patrón Repositorio  
**Persistencia nativa:** SQLite vía `sqflite_common_ffi`  
**Persistencia web:** `SharedPreferences` (`local_storage`)  
**Plataformas:** Windows · Android · Web (Chrome / Pillán UCT)  
**Estado:** `StatefulWidget` nativo — sin dependencias externas de gestión de estado

---

## 🔒 Seguridad

- Validación de RUT chileno con algoritmo módulo 11
- Unicidad de RUT y email por repositorio
- Protección contra CSV Injection en exportación
- Sin almacenamiento de contraseñas ni datos sensibles en texto plano

---

## 🧪 Testing

```bash
flutter test
```

Los tests cubren los validadores (RUT, email, nombre) con 24 pruebas unitarias aprobadas.

---

## 🚀 Instalación y Ejecución

### Requisitos previos

- Flutter SDK 3.0.0 o superior
- Dart 3.x (incluido con Flutter)
- Para Android: Android SDK con Command-line Tools

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/HectorLep/gestion_clientes.git
cd gestion_clientes

# 2. Instalar dependencias
flutter pub get

# 3. Verificar el entorno
flutter doctor -v

# 4. Ejecutar según plataforma
flutter run -d windows   # Escritorio Windows (SQLite)
flutter run -d chrome    # Navegador web (SharedPreferences)
flutter run -d android   # Dispositivo Android (SQLite)

# 5. Compilar APK de producción
flutter build apk
# Salida: build/app/outputs/flutter-apk/app-release.apk
```

> **Tip:** Para ver los dispositivos disponibles ejecuta `flutter devices`.

### Dependencias principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.5.3
  path_provider: ^2.1.5
  sqflite_common_ffi: ^2.3.4
  path: ^1.9.0
```

---

## 🎓 Contexto académico

Proyecto desarrollado para la asignatura de **Desarrollo de Aplicaciones Empresariales**  
Ingeniería Civil en Informática — Universidad Católica de Temuco  
Grupo 23 · Actividad 2 · 2026