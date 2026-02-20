📱 Frontend: App de Vulnerabilidad Sísmica (Flutter)
Esta aplicación móvil permite el registro técnico de edificaciones, integrando geolocalización, captura de imágenes y generación de reportes en PDF.

🛠️ Stack Tecnológico
Framework: Flutter ^3.8.1

Gestión de Estado: provider (v6.1.1)

Backend as a Service: supabase_flutter (v2.10.0) para base de datos y autenticación.

📦 Funcionalidades Principales
📍 Geolocalización: Uso de geolocator y geocoding para ubicar automáticamente la edificación inspeccionada.

📸 Evidencia Visual: Integración de image_picker para capturar fotos del estado estructural.

📄 Reportes Técnicos: Generación y exportación de documentos PDF mediante pdf y printing.

🔒 Autenticación Segura: Manejo de sesiones de usuario con Supabase Auth.

💾 Persistencia Local: Uso de shared_preferences para configuraciones rápidas del usuario.

📂 Estructura del Código (lib/)
El proyecto está organizado de manera modular para facilitar el mantenimiento:

core/: Configuración central.

services/: Lógica de servicios (Auth, Geolocalización, Inspección).

config/ & constants/: Endpoints de la base de datos y configuraciones globales.

data/models/: Definición de objetos de negocio y mapeo de respuestas de la API (auth_response, building_response, etc.).

ui/screens/: Todas las pantallas de la interfaz, incluyendo:

Registro de edificios (dividido en 5 etapas para mejor UX).

Pantallas de administración de perfiles y roles.

Recuperación y reseteo de contraseñas.

ui/widgets/: Componentes reutilizables como logos, campos de texto y diálogos de éxito.

🚀 Instalación y Ejecución
Entrar al directorio:

PowerShell
cd flutter_application_1
Obtener dependencias:

PowerShell
flutter pub get
Configurar Assets:
Asegúrate de que las imágenes base estén en la ruta: assets/images/.

Lanzar la App:

PowerShell
flutter run
📝 Notas para el Desarrollador
Diseño: Se utiliza google_fonts y Material Design para una interfaz moderna y legible en campo.

Entradas de datos: Se implementó intl_phone_field para asegurar que los números de contacto sean válidos internacionalmente.
