# Gestión de Clientes UCT

Aplicación desarrollada en **Flutter** para la gestión de clientes, orientada a un contexto académico de Ingeniería Civil en Informática.  
El sistema permite registrar, editar, buscar, ordenar, dar de baja, reactivar y exportar clientes, aplicando criterios de validación, modularización y persistencia local.

## Objetivo del proyecto

El objetivo de este proyecto es construir una aplicación multiplataforma para la administración de clientes, aplicando buenas prácticas de desarrollo de software, separación por capas y validación de datos.

Además de cumplir con los requerimientos funcionales, el proyecto busca demostrar criterios de ingeniería como:

- Separación de responsabilidades.
- Persistencia local de datos.
- Exportación de información a CSV.
- Validaciones de negocio.
- Mejora de experiencia de usuario.
- Base preparada para futura escalabilidad.

## Funcionalidades principales

- Registro de clientes con:
  - Nombre completo
  - RUT chileno
  - Email
  - Fecha de registro automática

- Validaciones de formulario:
  - Nombre obligatorio y bien formado
  - Validación de RUT por módulo 11
  - Validación de email
  - Prevención de RUT duplicado
  - Prevención de email duplicado

- Gestión de clientes:
  - Crear clientes
  - Editar clientes existentes
  - Dar de baja clientes sin eliminarlos físicamente
  - Reactivar clientes inactivos

- Búsqueda y visualización:
  - Búsqueda por nombre, RUT o email
  - Búsqueda con debounce
  - Opción de mostrar/ocultar inactivos
  - Orden por nombre
  - Orden por fecha de registro

- Exportación:
  - Exportación de clientes a archivo CSV
  - Compatibilidad con Web y Escritorio mediante importaciones condicionales

## Arquitectura del proyecto

El proyecto fue refactorizado para evitar un archivo `main.dart` monolítico y adoptar una estructura modular por capas.

```text
lib/
├── main.dart
├── models/
│   └── cliente.dart
├── repositories/
│   └── cliente_repositorio.dart
├── services/
│   ├── csv_service.dart
│   ├── csv_exporter_stub.dart
│   ├── csv_exporter_io.dart
│   └── csv_exporter_web.dart
├── utils/
│   ├── validadores.dart
│   └── rut_formatter.dart
├── pages/
│   └── registro_clientes_page.dart
└── widgets/
    ├── panel_formulario.dart
    ├── stats_row.dart
    ├── buscador_field.dart
    ├── lista_clientes.dart
    └── estado_vacio.dart
```

### Descripción de capas

- **models/**: define las entidades del sistema.
- **repositories/**: maneja la persistencia local de datos.
- **services/**: encapsula lógica de exportación y servicios auxiliares.
- **utils/**: contiene validadores y formateadores reutilizables.
- **pages/**: contiene la pantalla principal y la lógica de interacción.
- **widgets/**: contiene componentes visuales reutilizables.

## Persistencia de datos

Actualmente el sistema utiliza **SharedPreferences** para almacenar la lista de clientes de manera local en formato JSON.

Esta decisión permite una implementación simple y funcional para el alcance del proyecto.  
Sin embargo, como mejora futura, se reconoce que una solución más robusta y escalable sería migrar a **SQLite** mediante `sqflite`, dejando la UI desacoplada gracias al uso del patrón repositorio.

## Seguridad y validaciones

El proyecto incorpora validaciones tanto a nivel de entrada como en exportación de datos:

- Validación de RUT chileno mediante **módulo 11**.
- Validación de formato de email.
- Normalización de RUT.
- Prevención de registros duplicados.
- Exportación CSV con sanitización para reducir riesgo de **CSV Injection / Formula Injection**.

Esto es importante porque aplicaciones de planilla como Excel o LibreOffice pueden interpretar como fórmula valores que comienzan con `=`, `+`, `-` o `@`.

## Experiencia de usuario

Se incluyeron mejoras enfocadas en usabilidad:

- Formateo automático del RUT mientras el usuario escribe.
- Mensajes visuales mediante `SnackBar`.
- Soft delete mediante estado `activo/inactivo`.
- Interfaz responsive compatible con escritorio y web.
- Búsqueda con debounce para reducir procesamiento innecesario.

## Pruebas

El proyecto incluye carpeta `test/` con pruebas unitarias y pruebas básicas de widget.

Tipos de pruebas consideradas:

- **Unit tests** para funciones de validación.
- **Widget tests** para verificar carga de interfaz principal.

Esto permite aumentar la confiabilidad del sistema y demostrar un enfoque más cercano a ingeniería de software.

## Tecnologías utilizadas

- **Flutter**
- **Dart**
- **SharedPreferences**
- **path_provider**
- **Material 3**

## Cómo ejecutar el proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/HectorLep/gestion_clientes.git
cd gestion_clientes
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la aplicación

```bash
flutter run
```

### 4. Ejecutar pruebas

```bash
flutter test
```

## Requisitos funcionales cubiertos

- Registro de clientes
- Edición de clientes
- Búsqueda de clientes
- Persistencia local
- Exportación CSV
- Validación de datos
- Manejo de clientes inactivos
- Ordenamiento de resultados

## Posibles mejoras futuras

- Migración de persistencia a SQLite
- Uso de Provider o Riverpod para gestión de estado
- Apertura automática de carpeta de descarga en escritorio
- Filtros avanzados por estado o fecha
- Mejoras visuales en indicadores de clientes inactivos
- Cobertura de pruebas más amplia

## Autor

**Héctor Lep**  
Estudiante de Ingeniería Civil en Informática  
Universidad Católica de Temuco

## Repositorio

GitHub: [https://github.com/HectorLep/gestion_clientes](https://github.com/HectorLep/gestion_clientes)