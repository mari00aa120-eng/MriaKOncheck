# Guía de Despliegue Completo - KonCheck

Esta guía te llevará paso a paso desde cero hasta tener el sistema KonCheck funcionando completamente.

---

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- ✅ **Java JDK 17 o superior**
  - Verificar: `java -version`
  - Descargar: https://adoptium.net/

- ✅ **Maven 3.8 o superior**
  - Verificar: `mvn -version`
  - Descargar: https://maven.apache.org/download.cgi

- ✅ **Docker y Docker Compose**
  - Verificar: `docker --version` y `docker-compose --version`
  - Descargar: https://www.docker.com/get-started

- ✅ **GlassFish 7**
  - Descargar: https://glassfish.org/download
  - Extraer en una ubicación (ej: `/opt/glassfish7` o `C:\glassfish7`)

---

## 🚀 Paso 1: Preparar el Proyecto

### 1.1 Descargar el Proyecto

\`\`\`bash
# Si tienes el proyecto en un ZIP
unzip koncheck-backend.zip
cd koncheck-backend

# O si está en Git
git clone <tu-repositorio>
cd koncheck-backend
\`\`\`

### 1.2 Dar Permisos a Scripts (Linux/Mac)

\`\`\`bash
chmod +x start.sh
chmod +x stop.sh
\`\`\`

---

## 🗄️ Paso 2: Configurar Base de Datos

### 2.1 Iniciar MySQL con Docker

\`\`\`bash
# Iniciar contenedor MySQL
docker-compose up -d

# Verificar que esté corriendo
docker ps

# Deberías ver algo como:
# CONTAINER ID   IMAGE       PORTS                    NAMES
# abc123def456   mysql:8.0   0.0.0.0:3306->3306/tcp   koncheck-mysql
\`\`\`

### 2.2 Ejecutar Scripts SQL

\`\`\`bash
# Esperar 10 segundos para que MySQL inicie completamente
sleep 10

# Ejecutar script de creación de tablas
docker exec -i koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db < scripts/01_create_tables.sql

# Ejecutar script de datos de prueba
docker exec -i koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db < scripts/02_insert_test_data.sql
\`\`\`

### 2.3 Verificar Base de Datos

\`\`\`bash
# Conectarse a MySQL
docker exec -it koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db

# Dentro de MySQL, ejecutar:
SHOW TABLES;
SELECT COUNT(*) FROM personas;
SELECT COUNT(*) FROM ciudadanos;
SELECT COUNT(*) FROM administradores;

# Deberías ver:
# - 4 tablas (personas, ciudadanos, administradores, documentos)
# - 6 personas (1 admin + 5 ciudadanos)
# - 5 ciudadanos
# - 1 administrador

# Salir de MySQL
exit;
\`\`\`

---

## ⚙️ Paso 3: Configurar GlassFish

### 3.1 Iniciar GlassFish

\`\`\`bash
# Linux/Mac
cd /opt/glassfish7/bin
./asadmin start-domain

# Windows
cd C:\glassfish7\bin
asadmin start-domain
\`\`\`

Deberías ver:
\`\`\`
Waiting for domain1 to start ....
Successfully started the domain : domain1
\`\`\`

### 3.2 Verificar GlassFish

Abrir navegador en: http://localhost:4848

- Usuario: `admin`
- Password: (vacío por defecto)

### 3.3 Configurar JDBC Connection Pool

\`\`\`bash
asadmin create-jdbc-connection-pool \
  --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
  --restype javax.sql.DataSource \
  --property user=koncheck:password=KonCheck2025!:serverName=localhost:portNumber=3306:databaseName=koncheck_db:useSSL=false:allowPublicKeyRetrieval=true \
  KonCheckPool
\`\`\`

### 3.4 Crear JDBC Resource

\`\`\`bash
asadmin create-jdbc-resource \
  --connectionpoolid KonCheckPool \
  jdbc/koncheckDS
\`\`\`

### 3.5 Verificar Conexión

\`\`\`bash
asadmin ping-connection-pool KonCheckPool
\`\`\`

Deberías ver:
\`\`\`
Command ping-connection-pool executed successfully.
\`\`\`

---

## 🔨 Paso 4: Compilar el Proyecto

\`\`\`bash
# Desde la raíz del proyecto
mvn clean package

# Deberías ver al final:
# [INFO] BUILD SUCCESS
# [INFO] Total time: XX.XXX s
\`\`\`

El archivo WAR se generará en: `target/koncheck-backend.war`

---

## 📦 Paso 5: Desplegar en GlassFish

### Opción A: Línea de Comandos (Recomendado)

\`\`\`bash
asadmin deploy --contextroot /koncheck target/koncheck-backend.war
\`\`\`

### Opción B: Admin Console

1. Ir a http://localhost:4848
2. Navegar a: **Applications**
3. Click en **Deploy**
4. Seleccionar `target/koncheck-backend.war`
5. Context Root: `/koncheck`
6. Click **OK**

### Verificar Despliegue

\`\`\`bash
asadmin list-applications
\`\`\`

Deberías ver:
\`\`\`
koncheck-backend  <web>
\`\`\`

---

## ✅ Paso 6: Probar la API

### 6.1 Verificar que la API Responde

\`\`\`bash
curl http://localhost:8080/koncheck/api/auth/login
\`\`\`

Deberías recibir un error (esperado, porque no enviaste credenciales):
\`\`\`json
{"error": "Correo y contraseña son requeridos"}
\`\`\`

### 6.2 Hacer Login

\`\`\`bash
curl -X POST http://localhost:8080/koncheck/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"correo":"admin@koncheck.com","password":"Admin123"}'
\`\`\`

Deberías recibir:
\`\`\`json
{
  "success": true,
  "message": "Login exitoso",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": 1,
  "correo": "admin@koncheck.com",
  "nombres": "Admin",
  "apellidos": "Sistema"
}
\`\`\`

### 6.3 Listar Ciudadanos

\`\`\`bash
# Guardar el token en una variable
TOKEN="<pegar-token-aqui>"

# Listar ciudadanos
curl -X GET http://localhost:8080/koncheck/api/ciudadanos \
  -H "Authorization: Bearer $TOKEN"
\`\`\`

Deberías ver la lista de 5 ciudadanos de prueba.

---

## 🌐 Paso 7: Configurar Frontend

### 7.1 Actualizar URL de la API

Editar el archivo `Administrador/js/api-config.js`:

\`\`\`javascript
const API_CONFIG = {
  BASE_URL: "http://localhost:8080/koncheck/api",  // ✅ Verificar esta URL
  // ... resto del código
};
\`\`\`

### 7.2 Agregar Scripts a los HTML

En cada archivo HTML del frontend, agregar antes del cierre de `</body>`:

**Para IngresarAd.html:**
\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
\`\`\`

**Para RegistrarAd.html:**
\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
\`\`\`

**Para dashboard.html:**
\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
<script src="../js/ciudadano-service.js"></script>
\`\`\`

**Para crearCiudadano.html y editarCiudadano.html:**
\`\`\`html
<script src="../../js/api-config.js"></script>
<script src="../../js/auth-service.js"></script>
<script src="../../js/ciudadano-service.js"></script>
\`\`\`

### 7.3 Servir el Frontend

Opción 1: Servidor HTTP Simple (Python)
\`\`\`bash
cd <carpeta-del-frontend>
python3 -m http.server 3000
\`\`\`

Opción 2: Live Server (VS Code)
- Instalar extensión "Live Server"
- Click derecho en `LandingPage.html` → "Open with Live Server"

Opción 3: Copiar a GlassFish
\`\`\`bash
cp -r <carpeta-frontend>/* /opt/glassfish7/glassfish/domains/domain1/docroot/
\`\`\`

Acceder en: http://localhost:8080/LandingPage.html

---

## 🧪 Paso 8: Probar el Sistema Completo

### 8.1 Abrir el Frontend

Ir a: http://localhost:3000/LandingPage.html (o la URL donde esté servido)

### 8.2 Registrar un Administrador

1. Click en "Registrarse"
2. Llenar el formulario:
   - Nombres: Tu Nombre
   - Apellidos: Tu Apellido
   - Identificación: 123456789
   - Correo: tumail@ejemplo.com
   - Contraseña: TuPassword123
3. Click en "Registrar"

### 8.3 Iniciar Sesión

1. Usar las credenciales que acabas de crear
2. O usar las de prueba:
   - Correo: admin@koncheck.com
   - Password: Admin123

### 8.4 Probar CRUD de Ciudadanos

1. **Listar**: Deberías ver 5 ciudadanos de prueba
2. **Buscar**: Escribir "Juan" en el buscador
3. **Crear**: Click en "+ Crear Ciudadano" y llenar el formulario
4. **Editar**: Click en "✏️ Editar" en cualquier ciudadano
5. **Eliminar**: Click en "🗑️ Eliminar" y confirmar

---

## 📊 Verificación Final

### Checklist de Verificación

- [ ] MySQL corriendo en puerto 3306
- [ ] Base de datos `koncheck_db` creada con 4 tablas
- [ ] 6 registros en tabla `personas`
- [ ] GlassFish corriendo en puerto 8080
- [ ] JDBC Connection Pool `KonCheckPool` creado y funcionando
- [ ] JDBC Resource `jdbc/koncheckDS` creado
- [ ] Aplicación `koncheck-backend` desplegada
- [ ] API responde en http://localhost:8080/koncheck/api
- [ ] Login exitoso con credenciales de prueba
- [ ] Frontend cargando correctamente
- [ ] CRUD de ciudadanos funcionando

---

## 🛠️ Comandos Útiles

### GlassFish

\`\`\`bash
# Iniciar
asadmin start-domain

# Detener
asadmin stop-domain

# Reiniciar
asadmin restart-domain

# Ver logs
tail -f /opt/glassfish7/glassfish/domains/domain1/logs/server.log

# Redesplegar aplicación
asadmin redeploy target/koncheck-backend.war

# Eliminar aplicación
asadmin undeploy koncheck-backend
\`\`\`

### MySQL (Docker)

\`\`\`bash
# Iniciar
docker-compose up -d

# Detener
docker-compose down

# Ver logs
docker logs koncheck-mysql

# Conectarse
docker exec -it koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db

# Backup
docker exec koncheck-mysql mysqldump -ukoncheck -pKonCheck2025! koncheck_db > backup.sql

# Restore
docker exec -i koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db < backup.sql
\`\`\`

### Maven

\`\`\`bash
# Compilar sin tests
mvn clean package -DskipTests

# Limpiar
mvn clean

# Ver dependencias
mvn dependency:tree
\`\`\`

---

## 🐛 Solución de Problemas Comunes

### Error: "Cannot connect to database"

**Causa**: MySQL no está corriendo o credenciales incorrectas

**Solución**:
\`\`\`bash
# Verificar MySQL
docker ps | grep mysql

# Si no está corriendo
docker-compose up -d

# Verificar conexión
docker exec -it koncheck-mysql mysql -ukoncheck -pKonCheck2025! -e "SELECT 1"
\`\`\`

### Error: "Port 3306 already in use"

**Causa**: Ya hay un MySQL corriendo en el puerto 3306

**Solución**:
\`\`\`bash
# Opción 1: Detener MySQL local
sudo systemctl stop mysql

# Opción 2: Cambiar puerto en docker-compose.yml
ports:
  - "3307:3306"  # Usar puerto 3307 en lugar de 3306
\`\`\`

### Error: "Port 8080 already in use"

**Causa**: Otro servicio está usando el puerto 8080

**Solución**:
\`\`\`bash
# Ver qué está usando el puerto
lsof -i :8080

# Cambiar puerto de GlassFish
asadmin set server.http-service.http-listener.http-listener-1.port=8081
\`\`\`

### Error: "Token inválido" en el frontend

**Causa**: Token expirado o no se está enviando correctamente

**Solución**:
1. Hacer logout y login nuevamente
2. Abrir consola del navegador (F12) y verificar errores
3. Verificar que `localStorage.getItem('authToken')` tenga un valor

### Error: "CORS policy" en el navegador

**Causa**: CORS no está configurado correctamente

**Solución**:
1. Verificar que `CorsFilter.java` esté en el proyecto
2. Redesplegar la aplicación: `asadmin redeploy target/koncheck-backend.war`
3. Limpiar caché del navegador

---

## 📞 Soporte

Si encuentras problemas:

1. **Revisar logs de GlassFish**:
   \`\`\`bash
   tail -f /opt/glassfish7/glassfish/domains/domain1/logs/server.log
   \`\`\`

2. **Revisar logs de MySQL**:
   \`\`\`bash
   docker logs koncheck-mysql
   \`\`\`

3. **Revisar consola del navegador** (F12)

4. **Verificar que todos los servicios estén corriendo**:
   \`\`\`bash
   docker ps
   asadmin list-applications
   \`\`\`

---

## 🎉 ¡Listo!

Si llegaste hasta aquí y todo funciona, ¡felicidades! Tienes el sistema KonCheck completamente operativo.

**Credenciales de prueba:**
- Correo: admin@koncheck.com
- Password: Admin123

**URLs importantes:**
- Frontend: http://localhost:3000/LandingPage.html
- API: http://localhost:8080/koncheck/api
- GlassFish Admin: http://localhost:4848

---

**Proyecto:** KonCheck - Sistema de Gestión de Ciudadanos  
**Versión:** 1.0  
**Fecha:** 2025
