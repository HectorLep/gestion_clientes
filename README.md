# Gestión de Clientes UCT

Aplicación empresarial en Flutter desarrollada en pareja para la **ACTIVIDAD 2** - Sistema de registro de clientes.

---

## 🤝 Equipo de desarrollo

| Miembro     | GitHub |
|------------|--------|
| Héctor Lep | https://github.com/HectorLep |
| Compañero  | https://github.com/sonickiller39 |

---

## 🎯 Descripción

Sistema de registro de clientes que permite:

- Ingresar datos de clientes  
- Almacenarlos localmente  
- Consultarlos, buscarlos y ordenarlos  
- Editar información  
- Gestionar estado (activo/inactivo)  
- Exportar datos a CSV  

---

## ✅ Funcionalidades

- Registro de clientes  
- Listado completo  
- Búsqueda optimizada (debounce)  
- Orden por nombre y fecha  
- Edición de clientes  
- Soft delete (baja/reactivar)  
- Exportación a CSV (Web/Desktop)  
- Validación de RUT (módulo 11)  
- Formateo de RUT en tiempo real  
- Pruebas unitarias  

---

## 🏗️ Arquitectura

```text
lib/
├── models/
├── repositories/
├── services/
├── utils/
├── pages/
└── widgets/
```

**Persistencia:** SharedPreferences (escalable a SQLite)  
**Plataformas:** Web y Escritorio  

---

## 🔒 Seguridad

- Protección contra CSV Injection (`=`, `+`, `-`, `@`)
- Validación de RUT (módulo 11)
- Unicidad de RUT y email

---

## 🧪 Testing

```bash
flutter test
```

---

## 🚀 Instalación

```bash
git clone https://github.com/HectorLep/gestion_clientes.git
cd gestion_clientes
flutter pub get
flutter run
```

---

## 📸 Demo

*(Agregar enlace o capturas aquí cuando estén disponibles)*

---

## 🎓 Contexto

Proyecto desarrollado para la asignatura de Ingeniería Civil en Informática  
Universidad Católica de Temuco