# Proyecto Final: Centro de Acopio

> Borrador del contenido para exportar a PDF cuando se integren la aplicación WinForms y todos los módulos de la API. Los datos de portada, capturas, referencias realmente consultadas y evidencia de commits se completan con el equipo; no se inventan.

## Portada

- Universidad: **[Universidad Tecnologica de Panamá]**
- Facultad: **[Ingenieria en Sistemas Computacionales]**
- Licenciatura: **[Lic. Desarrollo y Gestion de Softwar]**
- Asignatura: Desarrollo de Software IV
- Trabajo: Proyecto Final
- Grupo: **[confirmar]**
- Integrantes y cédulas: **[Andrea Torrento, Abrahan Tuñon , Jorge Sarmiento, Moises Murgas]**
- Profesor: **[Rodrigo Yanguez]**
- Fecha de entrega: 2 de diciembre de 2026

## Introducción

El proyecto propone un sistema para organizar las donaciones y entregas de un centro de acopio. La solución se compone de una aplicación de escritorio para la operación, una API que concentra las validaciones y reglas de negocio, y una base de datos SQL Server Express que conserva productos, personas, donaciones y entregas. El inventario disponible se calcula a partir de las donaciones menos las entregas, considerando talla, grupo de edad y sexo para los artículos de ropa.

## Objetivos y alcance

### Objetivo general

Desarrollar un sistema que permita registrar y consultar movimientos de un centro de acopio, controlar las existencias por producto y generar reportes para apoyar su operación.

### Objetivos específicos

- Administrar el catálogo de productos, donantes y beneficiarios.
- Registrar donaciones y entregas con sus datos y validaciones.
- Evitar entregas que superen el inventario disponible y proteger registros relacionados.
- Consultar inventario, totales por tipo, donaciones de ropa y movimientos por fecha.
- Separar la interfaz, las reglas de negocio y la persistencia mediante WinForms, Web API y SQL Server.

### Alcance funcional

El contrato contempla CRUD de productos, donantes, beneficiarios, donaciones y entregas; consulta del inventario; y reportes de totales por tipo, donaciones por tipo, ropa filtrada y movimientos. Una solicitud que excede el stock responde 409; la API es la autoridad para esta regla.

### Fuera de alcance

El contrato compartido no define autenticación, roles, facturación, compras, integración con servicios externos ni despliegue en la nube. No se describen como funcionalidades del sistema.

## Diagramas

Insertar los diagramas exportados de [modelo de datos](diagrama-modelo-datos.md) y [arquitectura y clases](diagramas-arquitectura.md). Completar el diagrama de clases de WinForms desde los archivos reales una vez integrados.

## Guía de usuario

Esta sección necesita capturas de cada pantalla real y confirmación de sus nombres y controles. Flujo operativo recomendado una vez integrada la aplicación:

1. Registrar o consultar el producto que se recibirá.
2. Registrar al donante cuando corresponda; una donación puede ser anónima.
3. Registrar la donación, especificando talla, grupo de edad y sexo cuando el producto sea ropa.
4. Consultar el inventario y confirmar la existencia por clave de stock.
5. Registrar al beneficiario y realizar la entrega sin exceder la cantidad disponible.
6. Consultar los totales, las donaciones por tipo, la ropa filtrada o los movimientos.

Para ejecutar el sistema, seguir [README.md](../README.md). Agregar aquí las capturas numeradas y los pasos reales de cada formulario. WinForms aún no está integrado en esta copia, por lo que no se atribuyen controles ni pantallas inexistentes.

## Funcionalidades y características

La API debe validar nombres, cédulas, teléfonos, tipos, cantidades y campos de ropa. Mantiene la integridad entre donantes/donaciones, beneficiarios/entregas y productos/movimientos. Los procedimientos almacenados acordados devuelven el inventario y los reportes con las columnas del contrato. Las respuestas HTTP siguen los códigos 200, 201, 204, 400, 404 y 409.

**Pendiente de cerrar con el código integrado:** rutas y mensajes observados, capturas de cada pantalla y comprobación de que los cinco procedimientos devuelven exactamente el DTO correspondiente.

## Pruebas y anexos

Anexar el plan completo de [pruebas](PlanPruebas.md), capturas reales guardadas en `docs/evidencia/`, enlace del repositorio y captura de la página de commits de `main` que muestre la participación del equipo. Registrar los resultados observados; no sustituirlos por los resultados esperados.

## Referencias APA 7

Completar con los recursos oficiales de Microsoft Learn que el equipo realmente consultó (ASP.NET Core Web API, Entity Framework Core y HttpClient). Pedir a cada integrante sus fuentes para registrar títulos, autores corporativos y enlaces consultados. No se agregan referencias sin verificar que fueron utilizadas.
