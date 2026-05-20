# ADR - PoC Offline First y Notificaciones Locales

## Estado

Aceptado

---

## Contexto

El proyecto STUDYTRACK requiere validar técnicamente el flujo principal de creación de tareas académicas con persistencia offline y programación de notificaciones locales.

El principal riesgo arquitectónico identificado corresponde a la integración asíncrona entre:

- Persistencia local.
- Programación de recordatorios.
- Escalabilidad futura hacia sincronización cloud.

Además, el sistema debe cumplir el requerimiento no funcional RNF-01:

> "La aplicación debe funcionar sin conexión a internet."

Debido a esto, se requiere una arquitectura offline-first desacoplada que permita mantener operativa la aplicación incluso sin conectividad.

---

## Problema Arquitectónico

La principal complejidad técnica corresponde a garantizar:

- Persistencia local inmediata.
- Programación correcta de notificaciones.
- Separación de responsabilidades.
- Escalabilidad futura hacia sincronización automática con Firebase.

También se identificó como riesgo técnico la posible complejidad de sincronización futura entre almacenamiento local y servicios cloud.

---

## Dependencias Seleccionadas

| Dependencia | Propósito |
|---|---|
| Hive | Persistencia local offline |
| flutter_local_notifications | Programación de notificaciones locales |
| Provider | Manejo básico de estado |
| connectivity_plus | Base futura para sincronización reactiva |

---

## Decisión Técnica

Se decidió implementar una arquitectura simplificada inspirada en Clean Architecture, separando:

- Presentación.
- Dominio.
- Datos.

La persistencia local fue implementada mediante Hive debido a:

- Bajo costo de integración.
- Buen rendimiento móvil.
- Simplicidad frente a SQLite.
- Compatibilidad offline-first.

Las notificaciones locales fueron implementadas utilizando flutter_local_notifications, permitiendo validar el flujo principal sin depender de servicios cloud externos.

La PoC se desarrolló en una rama aislada:

```text
feature/poc_offline_notifications
```

permitiendo experimentar sin afectar la rama principal del proyecto.

---

## Consecuencias

### Positivas

- Se validó correctamente la persistencia offline.
- La programación de notificaciones locales funcionó correctamente.
- La arquitectura desacoplada facilita futuras extensiones.
- Se comprobó la viabilidad de una estrategia offline-first.

### Limitaciones

- La sincronización cloud aún no fue implementada.
- No se manejan conflictos de sincronización.
- Las notificaciones recurrentes avanzadas requieren investigación adicional.

### Hallazgos Técnicos

La integración de flutter_local_notifications requirió habilitar:

- Core Library Desugaring en Gradle.
- Configuración adicional Android.

---

## Integración Futura

La arquitectura permitirá integrar posteriormente:

- Firebase Firestore.
- Sincronización automática basada en eventos de conectividad.
- Campo `isSynced` para control de sincronización.
- Reintentos automáticos offline/online.

La futura sincronización utilizará listeners reactivos mediante connectivity_plus para evitar polling constante y optimizar consumo energético.

---

## Resultado de la PoC

La PoC logró validar exitosamente:

- Creación de tareas.
- Persistencia local en Hive.
- Programación de notificaciones locales.
- Flujo asíncrono entre UI, dominio y datos.

La implementación mínima permitió demostrar la viabilidad técnica del caso de uso principal sin necesidad de una interfaz elaborada.