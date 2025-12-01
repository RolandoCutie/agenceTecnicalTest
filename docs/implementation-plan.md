# Plan de Implementación del Test Práctico (Flutter)

Este documento guía los pasos para implementar el test siguiendo Clean Architecture y MobX.

## Resumen del Alcance
- Arquitectura: Clean Architecture (domain/data/presentation).
- Estado: MobX (`mobx`, `flutter_mobx`, `mobx_codegen` + `build_runner`).
- Plataforma: Flutter multiplaforma.
- Rutas: `MaterialApp` con páginas en `presentation/pages/`.

## Tareas Principales
1. Preparación
   - Leer requerimientos del PDF y listar funcionalidades.
   - Confirmar supuestos (API, datos locales, navegación, pruebas).
2. Estructura del proyecto
   - Crear carpetas `lib/features/<feature>/{domain,data,presentation}`.
   - Definir entidades y contratos de repositorios en `domain`.
3. Estado con MobX
   - Crear `Store` por feature en `presentation/stores/`.
   - Generar código con `build_runner`.
4. Datos
   - Implementar repositorios en `data/repositories`.
   - Implementar data sources (remote/local) si aplica.
5. UI
   - Páginas y widgets en `presentation/pages/` y `presentation/widgets/`.
   - Usar `Observer` para reaccionar al estado de MobX.
6. Integración
   - Rutas en `lib/main.dart`.
   - Inyección simple de dependencias (constructor/locators) según sea necesario.
7. Pruebas
   - `flutter_test` para widgets y lógica de `usecases`.

## Checklist por Feature (Plantilla)
- Domain
  - [ ] Entidades definidas
  - [ ] Repositorio (contrato)
  - [ ] UseCases
- Data
  - [ ] Repo Impl
  - [ ] Data Sources
- Presentation
  - [ ] Store (MobX)
  - [ ] Página y Widgets
  - [ ] Navegación
- Infra
  - [ ] Registro/DI
  - [ ] Manejo de errores
- Tests
  - [ ] Unit (usecases)
  - [ ] Widget

## Próximos Pasos
- Esperar confirmación de la primera funcionalidad a implementar.
- Tras confirmación, crear el esqueleto de la feature y actualizar `pubspec.yaml` con MobX.

---

## Requerimientos del Test (Paso 1)

### Funcionalidades
- Login:
   - Campos: usuario, contraseña y enlace "Olvidé mi contraseña" (UI sin backend real).
   - Botones: Login con Facebook y Login con Google (deben funcionar con sus SDKs).
- Listado de productos:
   - Grid de dos columnas con lazy loading.
   - Cada ítem: thumbnail e inmediatamente debajo el título (contenido fake permitido).
   - Redirección al listado tras login exitoso.
- Drawer en listado:
   - Opciones: Perfil, Mis productos, Configuraciones (pantallas vacías).
   - Cerrar sesión: termina la sesión si el login fue por Facebook/Google y vuelve a login.
- Detalle de producto:
   - Mapa (Google Maps) ocupando 1/3 de la altura de la pantalla mostrando la ubicación del usuario (Android/iOS).
   - Debajo: widget con thumbnail a la izquierda, nombre del producto y descripción fake debajo del nombre.
   - Botón "Realizar compra".
- Flujo de compra:
   - Modal de confirmación Sí/No.
   - Sí: alerta de éxito y redirección a la página de inicio (listado).
   - No: cierra el modal sin cambios.
- Publicación:
   - Subir el test a Git y compartir enlace público.

### Supuestos y Alcances
- Autenticación:
   - Facebook/Google: uso de `flutter_facebook_auth` y `google_sign_in`.
   - Usuario/contraseña: solo UI; "Olvidé mi contraseña" navega a pantalla informativa vacía o placeholder.
- Productos:
   - Fuente local (lista en memoria) con paginación/lazy usando `GridView.builder` y `ScrollController`.
- Navegación:
   - `MaterialApp` con rutas nombradas; tras login → pantalla de productos; Drawer disponible en listado.
- Maps y ubicación:
   - `google_maps_flutter` para Android/iOS; permisos de ubicación mediante `geolocator` (web/desktop fuera de alcance, usar placeholder si se abre en esas plataformas).
- Estado:
   - Stores MobX para `auth`, `products` y `session/navigation`.
- Pruebas:
   - Mínimas y enfocadas en navegación y lógica básica de stores/usecases.
- Plataformas:
   - Prioridad Android/iOS; soporte web/desktop opcional con placeholders.
- Estilo/Versionado:
   - Mensajes y commits manuales (evitar apariencia de IA).

### Criterios de Aceptación
- Login:
   - Campos usuario/contraseña y enlace "Olvidé mi contraseña" visibles.
   - Botones Facebook/Google autentican y redirigen al listado; en error permanecen en login con mensaje.
- Listado:
   - Grid 2 columnas con carga diferida; cada ítem muestra thumbnail y título.
- Drawer:
   - Perfil/Mis productos/Configuraciones navegan a pantallas vacías; Cerrar sesión limpia sesión (Facebook/Google) y vuelve a login.
- Detalle:
   - Mapa visible ocupando ~33% superior mostrando ubicación del usuario (Android/iOS con permisos).
   - Se visualiza thumbnail a la izquierda, nombre y descripción debajo del nombre.
   - Botón "Realizar compra" disponible.
- Compra:
   - Modal Sí/No; Sí muestra alerta de éxito y redirige al listado; No cierra el modal.
- Publicación:
   - Proyecto compila en Android/iOS; enlace público accesible.
