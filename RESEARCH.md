# Investigación Técnica

## Aplicaciones Similares

Existen diversas aplicaciones enfocadas en la gestión del tiempo y tareas académicas:

### Google Calendar
- Permite organizar eventos en un calendario.
- Soporta recordatorios y notificaciones.


### My Study Life
- Aplicación enfocada en estudiantes. Permite registrar clases, tareas y exámenes.
- Funciona offline.

### 4. Notion
- Herramienta muy flexible para organización.
- Permite crear bases de datos y calendarios.
- Mas centrada en equipos de trabajo.

## Detalle Técnico de Como Implementar las Funcionalidades del Movil

### 1 Gestión de Tareas (CRUD)

**Funcionalidad**:  
Crear, editar, eliminar y visualizar tareas.

**Implementación en Flutter**:
- Uso de modelos en Dart (`Task.dart`).
- Manejo de estado con:
  - `setState` (básico) o
  - Provider / Riverpod (recomendado).
- Persistencia de datos:
  - Local: `sqflite` o `hive`.

### 2 Calendario Interactivo

**Funcionalidad**:  
Visualizar tareas en un calendario

**Implementación en Flutter**:
- Uso de librerías como:
    - table_calendar
- Asociación de fechas con listas de tareas.

### 3 Notificaciones Push

**Funcionalidad**:  
Enviar recordatorios automáticos

**Implementación en Flutter**:
- Uso de flutter_local_notifications.
- Programación de notificaciones locales.

### 4 Modo offline

**Funcionalidad**:  
Permitir el uso y guardado de información de manera local

**Implementación en Flutter**:
- Uso de base de datos local utilizando Hive.
- No depende de servicios externos.

### 5 Personalización de Recordatorios

**Funcionalidad**:  
Configurar cuándo recibir notificaciones

**Implementación en Flutter**:
- Uso de DatePicker y TimePicker.
- Cálculo de tiempo previo a la tarea.

