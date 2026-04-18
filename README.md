# Gestión de Clientes UCT

Aplicación empresarial multiplataforma en Flutter desarrollada en pareja para la **Actividad 2** — Sistema de registro y gestión de clientes.

***

## 🤝 Equipo de desarrollo

| Miembro | GitHub |
|---|---|
| Héctor Lep | [@HectorLep](https://github.com/HectorLep) |
| Agustín Vega | [@sonickiller39](https://github.com/sonickiller39) |

***

## 🎯 Descripción

Sistema completo de gestión de clientes con soporte para **Android y Web**, que permite registrar, consultar, editar y exportar clientes con validación de datos chilenos (RUT módulo 11).

***

## ✅ Funcionalidades

### Gestión de clientes
- Registro con nombre, RUT, email, teléfono, dirección y notas
- Clasificación por tipo: Nuevo, Frecuente, VIP, Inactivo
- Edición de datos (RUT no modificable)
- Baja con motivo opcional (soft delete)
- Reactivación de clientes dados de baja

### Búsqueda y filtros
- Búsqueda en tiempo real con debounce (nombre, RUT, email)
- Filtro por tipo de cliente
- Orden por nombre o fecha de registro (más recientes)
- Mostrar/ocultar clientes inactivos

### Exportación
- Exportación a CSV con todos los campos
- Filtro de exportación por tipo (todos / solo VIP / solo frecuentes)
- Protección contra CSV Injection (`=`, `+`, `-`, `@`)
- Compatible con Web (descarga directa) y Android (almacenamiento local)

### Validación y UX
- Validación de RUT chileno (módulo 11)
- Formateo de RUT en tiempo real (`12.345.678-9`)
- Unicidad de RUT y email
- Estadísticas: activos, inactivos, filtrados, crecimiento mensual, distribución por tipo
- Formulario con sección expandible para datos opcionales
- Layout responsivo (móvil y escritorio)

***

## 🏗️ Arquitectura

```text
lib/
├── controllers/         # Lógica de negocio y estado (ClientesController)
├── models/              # Entidades: Cliente, TipoCliente
├── repositories/        # Acceso a persistencia (SharedPreferences)
├── services/            # CsvService + exportación por plataforma
│   ├── csv_exporter_io.dart      # Android / Desktop
│   ├── csv_exporter_web.dart     # Web
│   └── csv_exporter_stub.dart    # Fallback
├── utils/               # Validadores (RUT módulo 11, email, nombre)
├── pages/               # RegistroClientesPage
└── widgets/             # PanelFormulario, ListaClientes, StatsRow,
                         # BuscadorField, EstadoVacio
```

**Persistencia:** `SharedPreferences` (arquitectura lista para migrar a SQLite)  
**Plataformas:** Android · Web · Desktop  
**Estado:** `ChangeNotifier` (sin dependencias externas de estado)

***

## 🔒 Seguridad

- Validación de RUT chileno con algoritmo módulo 11
- Unicidad de RUT y email por base de datos
- Protección contra CSV Injection en exportación
- Sin almacenamiento de datos sensibles en texto plano

***

## 🧪 Testing

```bash
flutter test
```

Los tests cubren validadores (RUT, email, nombre) y lógica del repositorio.

***

## 🚀 Instalación

```bash
git clone https://github.com/HectorLep/gestion_clientes.git
cd gestion_clientes
flutter pub get

# Ejecutar en Android
flutter run -d android

# Ejecutar en Web
flutter run -d chrome

# Compilar APK
flutter build apk
```

### Dependencias principales

```yaml
shared_preferences: ^2.5.3
path_provider: ^2.1.5
```

***

## 📸 Demo

*(Agregar capturas de pantalla o enlace a video cuando estén disponibles)*

***

## 🎓 Contexto académico

Proyecto desarrollado para la asignatura de **Desarrollo de Aplicaciones Empresariales**  
Ingeniería Civil en Informática — Universidad Católica de Temuco