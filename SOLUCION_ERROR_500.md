# Solución al Error 500 en Registro de Administrador

## Problema
Al intentar registrar un administrador, se recibe un error 500 (Internal Server Error).

## Causa Probable
Las tablas de la base de datos no están creadas correctamente o no coinciden con el modelo JPA de herencia JOINED.

## Solución Paso a Paso

### 1. Verificar que el backend esté corriendo
\`\`\`bash
# Verificar health check
curl -k https://localhost:8181/koncheck/api/health
\`\`\`

Deberías ver:
\`\`\`json
{"database":"OK","status":"UP","timestamp":...}
\`\`\`

### 2. Ejecutar el script de verificación y corrección

**Opción A: Desde v0 (Recomendado)**
1. Haz clic en el botón "Run" del script `03_verificar_y_corregir_tablas.sql`
2. Espera a que se complete la ejecución
3. Verifica que todas las tablas se crearon correctamente

**Opción B: Desde MySQL Workbench o línea de comandos**
\`\`\`bash
mysql -h localhost -u koncheck -p koncheck_db < scripts/03_verificar_y_corregir_tablas.sql
\`\`\`

### 3. Verificar los logs del servidor

Después de ejecutar el script, intenta registrar un administrador nuevamente. Los logs mostrarán exactamente en qué paso falla:

\`\`\`
[v0] ========== AdministradorService.registrar() ==========
[v0] Correo: test@example.com
[v0] Paso 1: Verificando si el correo ya existe...
[v0] OK: Correo disponible
[v0] Paso 2: Validando formato de correo...
[v0] OK: Formato de correo válido
[v0] Paso 3: Validando contraseña...
[v0] OK: Contraseña válida
[v0] Paso 4: Generando hash de contraseña...
[v0] OK: Hash generado
[v0] Paso 5: Creando objeto Administrador...
[v0] OK: Objeto creado con identificacion: admin_1234567890
[v0] Paso 6: Guardando en base de datos...
[v0] OK: Administrador guardado con ID: 1
[v0] Paso 7: Generando token JWT...
[v0] OK: Token generado
[v0] ========== REGISTRO COMPLETADO ==========
\`\`\`

### 4. Verificar la estructura de las tablas

Conéctate a MySQL y verifica:

\`\`\`sql
USE koncheck_db;

-- Ver todas las tablas
SHOW TABLES;

-- Ver estructura de personas
DESCRIBE personas;

-- Ver estructura de administradores
DESCRIBE administradores;

-- Verificar foreign key
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    TABLE_SCHEMA = 'koncheck_db'
    AND TABLE_NAME = 'administradores';
\`\`\`

### 5. Probar el registro

Desde el frontend (RegistrarAd.html):
1. Ingresa un correo válido (ej: `admin@koncheck.com`)
2. Ingresa una contraseña válida (ej: `Admin123`)
3. Haz clic en "Completar"

Deberías ver:
\`\`\`
✅ Registro exitoso. Ahora puedes iniciar sesión.
\`\`\`

### 6. Si el error persiste

Revisa los logs del servidor GlassFish:

\`\`\`bash
# En Linux/Mac
tail -f $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log

# En Windows
type %GLASSFISH_HOME%\glassfish\domains\domain1\logs\server.log
\`\`\`

Busca líneas que contengan `[v0]` para ver el flujo de ejecución detallado.

## Errores Comunes y Soluciones

### Error: "El correo ya está registrado"
**Solución**: El correo ya existe en la base de datos. Usa otro correo o elimina el registro existente:
\`\`\`sql
DELETE FROM administradores WHERE correo = 'tu@correo.com';
DELETE FROM personas WHERE identificacion LIKE 'admin_%';
\`\`\`

### Error: "Cannot add or update a child row: a foreign key constraint fails"
**Solución**: La foreign key entre `administradores` y `personas` no está configurada correctamente. Ejecuta el script `03_verificar_y_corregir_tablas.sql`.

### Error: "Table 'koncheck_db.personas' doesn't exist"
**Solución**: Las tablas no están creadas. Ejecuta los scripts en orden:
1. `01_create_tables.sql`
2. `02_insert_test_data.sql`
3. `03_verificar_y_corregir_tablas.sql` (si hay problemas)

### Error de conexión SSL
**Solución**: Acepta el certificado autofirmado en tu navegador:
1. Abre `https://localhost:8181/koncheck/api/health` en tu navegador
2. Acepta el certificado de seguridad
3. Intenta registrar nuevamente

## Verificación Final

Una vez solucionado, deberías poder:
1. ✅ Registrar un nuevo administrador
2. ✅ Iniciar sesión con las credenciales
3. ✅ Ver el token JWT en la respuesta
4. ✅ Acceder al dashboard

## Contacto

Si el problema persiste después de seguir estos pasos, revisa:
- Logs del servidor GlassFish
- Logs de MySQL
- Configuración de persistence.xml
- Configuración del JDBC Connection Pool en GlassFish
