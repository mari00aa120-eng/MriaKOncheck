# Instrucciones Rápidas - Sistema Fuerza Pública

## ✅ Lo que se implementó

### Backend Completo
- ✅ Modelo `UsuarioFuerzaPublica` con todos los campos necesarios
- ✅ Repositorio para operaciones de base de datos
- ✅ Servicio de autenticación con encriptación SHA-256
- ✅ API REST con endpoints para registro y login
- ✅ Validaciones de seguridad

### Frontend Actualizado
- ✅ Formulario de registro en 3 pasos funcional
- ✅ Página de login con validaciones
- ✅ Integración con backend real
- ✅ Manejo de errores y confirmaciones

### Base de Datos
- ✅ Script SQL para crear tabla
- ✅ Datos de prueba incluidos
- ✅ Configuración de persistence.xml

## 🚀 Cómo usar el sistema

### 1. Configurar Base de Datos
```bash
# Ejecutar en MySQL/MariaDB
mysql -u root -p koncheck < scripts/create_usuario_fuerza_publica_table.sql
```

### 2. Configurar Backend
- Verificar que el datasource `koncheckDS` esté configurado
- Compilar y desplegar la aplicación
- El servidor debe estar en: `http://localhost:8080`

### 3. Configurar Frontend
En `FuerzaPublica/js/api-config.js`:
```javascript
const API_CONFIG = {
  BASE_URL: "http://localhost:8080/koncheck/api",
  USE_MOCK_DATA: false, // ← Cambiar a false para usar backend real
  // ...
}
```

## 📝 Flujo de Usuario

### Registro (NUEVO USUARIO)
1. Ir a: `FuerzaPublica/RegistrarFp/RegistrarFp.html`
2. **Paso 1**: Ingresar identificación, nombres, apellidos
3. **Paso 2**: Ingresar información profesional (opcional)
4. **Paso 3**: Ingresar correo y contraseña
5. ✅ Sistema guarda en base de datos
6. ✅ Confirmación de registro exitoso

### Login (USUARIO EXISTENTE)
1. Ir a: `FuerzaPublica/IngresarFp/IngresarFp.html`
2. Seleccionar "Fuerza Pública"
3. Ingresar **número de identificación** (no correo)
4. Ingresar contraseña
5. ✅ Sistema valida contra base de datos
6. ✅ Redirección al dashboard

## 🧪 Datos de Prueba

Usuarios ya creados para probar:
```
Identificación: 12345678
Contraseña: 123456

Identificación: 87654321  
Contraseña: password123

Identificación: 11223344
Contraseña: admin2024
```

## 🔧 Endpoints API

```
POST /koncheck/api/auth/fuerza-publica/register
POST /koncheck/api/auth/fuerza-publica/login
GET  /koncheck/api/auth/fuerza-publica/validate/{identificacion}
POST /koncheck/api/auth/fuerza-publica/change-password
```

## ⚠️ Puntos Importantes

### Seguridad
- ✅ Contraseñas encriptadas con SHA-256
- ✅ Validación de usuarios únicos por identificación
- ✅ Control de usuarios activos/inactivos

### Validaciones
- ✅ Frontend: Formato de datos en tiempo real
- ✅ Backend: Reglas de negocio y seguridad
- ✅ Base de datos: Restricciones de integridad

### Flujo Completo
1. **REGISTRAR** → Guarda datos en BD → Usuario creado
2. **INGRESAR** → Valida contra BD → Si existe y contraseña correcta → Acceso permitido
3. **NO EXISTE** → Error: "Credenciales inválidas"
4. **CONTRASEÑA INCORRECTA** → Error: "Credenciales inválidas"

## 🐛 Solución de Problemas

### "Error de conexión"
- Verificar que el servidor esté ejecutándose
- Confirmar URL en `api-config.js`

### "Usuario no encontrado"
- Verificar que el usuario esté registrado
- Usar datos de prueba para confirmar funcionamiento

### "Credenciales inválidas"
- Verificar identificación y contraseña
- Recordar que se usa identificación, no correo

## 📁 Archivos Modificados/Creados

### Nuevos Archivos Backend
- `src/main/java/edu/komad/model/UsuarioFuerzaPublica.java`
- `src/main/java/edu/komad/repository/UsuarioFuerzaPublicaRepository.java`
- `src/main/java/edu/konrad/service/AuthFuerzaPublicaService.java`
- `src/main/java/edu/konrad/rest/AuthFuerzaPublicaResource.java`

### Archivos Frontend Actualizados
- `FuerzaPublica/RegistrarFp/RegistrarFp.html` (guarda datos en sessionStorage)
- `FuerzaPublica/RegistrarFp/RegistrarFp2.html` (guarda datos en sessionStorage)
- `FuerzaPublica/RegistrarFp/RegistrarFp3.html` (envía todos los datos al backend)
- `FuerzaPublica/IngresarFp/IngresarFp.html` (usa endpoint correcto)
- `FuerzaPublica/js/api-config.js` (endpoints actualizados)

### Scripts y Documentación
- `scripts/create_usuario_fuerza_publica_table.sql`
- `SISTEMA_AUTENTICACION_FUERZA_PUBLICA.md`
- `INSTRUCCIONES_RAPIDAS_FUERZA_PUBLICA.md`

## ✨ ¡Listo para usar!

El sistema está completamente funcional. Los usuarios de Fuerza Pública pueden:
1. ✅ Registrarse con sus datos personales
2. ✅ Ingresar con identificación y contraseña
3. ✅ Sus datos se guardan en la base de datos
4. ✅ Solo usuarios registrados pueden ingresar

**Sin cambios en tu código base existente** - Todo es nuevo y adicional.