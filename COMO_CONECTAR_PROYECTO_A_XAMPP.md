# 🚀 Cómo Conectar tu Proyecto Java a XAMPP

## 📋 Requisitos Previos

### ✅ Software Necesario:
- **XAMPP** (Apache + MySQL + PHP)
- **Java JDK 17+** (tu proyecto usa JDK 25)
- **Maven** (para compilar el proyecto)
- **GlassFish Server** o **WildFly** (servidor de aplicaciones Jakarta EE)

---

## 🔧 PASO 1: Configurar XAMPP

### 1.1 Iniciar Servicios XAMPP
```bash
# Abrir XAMPP Control Panel
# Iniciar Apache (puerto 80)
# Iniciar MySQL (puerto 3306)
```

### 1.2 Crear Base de Datos
1. Ir a: `http://localhost/phpmyadmin`
2. Ejecutar el script: `scripts/09_setup_xampp_fuerza_publica.sql`
3. Verificar que se creó la BD `koncheck_db` con las tablas

---

## 🗄️ PASO 2: Configurar Base de Datos

### 2.1 Verificar Configuración MySQL
```sql
-- En phpMyAdmin, ejecutar:
SHOW DATABASES;
USE koncheck_db;
SHOW TABLES;

-- Verificar datos
SELECT COUNT(*) FROM fuerza_publica;
SELECT COUNT(*) FROM usuario_fuerza_publica;
```

### 2.2 Configurar Usuario MySQL (Opcional)
```sql
-- Si quieres crear un usuario específico:
CREATE USER 'koncheck'@'localhost' IDENTIFIED BY 'KonCheck2025!';
GRANT ALL PRIVILEGES ON koncheck_db.* TO 'koncheck'@'localhost';
FLUSH PRIVILEGES;
```

---

## ⚙️ PASO 3: Configurar Servidor de Aplicaciones

### Opción A: GlassFish Server

#### 3.1 Descargar e Instalar GlassFish
```bash
# Descargar GlassFish 7.x desde:
# https://glassfish.org/download

# Extraer en: C:\glassfish7
# Agregar al PATH: C:\glassfish7\bin
```

#### 3.2 Iniciar GlassFish
```bash
# Abrir Command Prompt como Administrador
cd C:\glassfish7\bin
asadmin start-domain domain1

# Verificar: http://localhost:4848 (Admin Console)
# Aplicación: http://localhost:8080
```

#### 3.3 Configurar Datasource en GlassFish
```bash
# 1. Copiar MySQL driver
copy "mysql-connector-j-8.1.0.jar" "C:\glassfish7\glassfish\domains\domain1\lib\"

# 2. Reiniciar GlassFish
asadmin restart-domain domain1

# 3. Crear Connection Pool
asadmin create-jdbc-connection-pool ^
  --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource ^
  --restype javax.sql.DataSource ^
  --property user=root:password=:serverName=localhost:port=3306:databaseName=koncheck_db:useSSL=false:allowPublicKeyRetrieval=true ^
  koncheckPool

# 4. Crear JDBC Resource
asadmin create-jdbc-resource ^
  --connectionpoolid koncheckPool ^
  java:jboss/datasources/koncheckDS

# 5. Verificar
asadmin ping-connection-pool koncheckPool
```

### Opción B: WildFly Server

#### 3.1 Descargar e Instalar WildFly
```bash
# Descargar WildFly 30.x desde:
# https://www.wildfly.org/downloads/

# Extraer en: C:\wildfly-30.0.0.Final
```

#### 3.2 Configurar MySQL en WildFly
```bash
# 1. Copiar driver MySQL
copy "mysql-connector-j-8.1.0.jar" "C:\wildfly-30.0.0.Final\standalone\deployments\"

# 2. Copiar datasource config
copy "koncheck-ds.xml" "C:\wildfly-30.0.0.Final\standalone\deployments\"

# 3. Iniciar WildFly
cd C:\wildfly-30.0.0.Final\bin
standalone.bat

# Verificar: http://localhost:9990 (Admin Console)
# Aplicación: http://localhost:8080
```

---

## 🏗️ PASO 4: Compilar y Desplegar Proyecto

### 4.1 Compilar con Maven
```bash
# En la carpeta del proyecto KonCheckKKK
cd C:\ruta\a\tu\proyecto\KonCheckKKK

# Limpiar y compilar
mvn clean compile

# Crear WAR
mvn package

# Resultado: target/koncheck-backend.war
```

### 4.2 Desplegar en GlassFish
```bash
# Opción 1: Línea de comandos
asadmin deploy target/koncheck-backend.war

# Opción 2: Admin Console
# Ir a: http://localhost:4848
# Applications > Deploy
# Seleccionar: target/koncheck-backend.war
```

### 4.3 Desplegar en WildFly
```bash
# Opción 1: Hot deployment
copy "target\koncheck-backend.war" "C:\wildfly-30.0.0.Final\standalone\deployments\"

# Opción 2: Admin Console
# Ir a: http://localhost:9990
# Deployments > Add
# Seleccionar: target/koncheck-backend.war
```

---

## 🧪 PASO 5: Probar Conexión

### 5.1 Verificar Despliegue
```bash
# URLs de prueba:
http://localhost:8080/koncheck-backend/
http://localhost:8080/koncheck-backend/api/fuerzaPublicas
```

### 5.2 Usar Test HTML
1. Abrir: `test-conexion-fuerza-publica.html`
2. Hacer clic en **"Ejecutar Test Completo"**
3. Verificar que todas las pruebas pasen

### 5.3 Probar Login
```bash
# Endpoint de login:
POST http://localhost:8080/koncheck-backend/api/auth/fuerza-publica/login

# Body JSON:
{
  "identificacion": "80123456789",
  "password": "policia2024"
}
```

---

## 📁 PASO 6: Estructura de Archivos

### 6.1 Ubicación de Archivos Importantes
```
KonCheckKKK/
├── src/main/
│   ├── java/edu/konrad/
│   │   ├── model/          # Entidades JPA
│   │   ├── repository/     # Repositorios
│   │   ├── service/        # Servicios de negocio
│   │   └── rest/          # Endpoints REST
│   ├── resources/
│   │   └── META-INF/
│   │       └── persistence.xml  # Configuración JPA
│   └── webapp/
│       └── WEB-INF/
│           └── web.xml     # Configuración web
├── koncheck-ds.xml         # Datasource (WildFly)
├── pom.xml                # Dependencias Maven
└── target/
    └── koncheck-backend.war  # Archivo desplegable
```

### 6.2 Archivos de Configuración Clave
- **persistence.xml**: Configuración JPA/Hibernate
- **koncheck-ds.xml**: Datasource para WildFly
- **pom.xml**: Dependencias y plugins Maven

---

## 🚨 Solución de Problemas

### Error: "Driver not found"
```bash
# Solución:
# 1. Descargar mysql-connector-j-8.1.0.jar
# 2. Copiar a la carpeta lib del servidor
# 3. Reiniciar servidor
```

### Error: "Connection refused"
```bash
# Verificar:
# 1. XAMPP MySQL está ejecutándose (puerto 3306)
# 2. Base de datos koncheck_db existe
# 3. Credenciales correctas (root sin password)
```

### Error: "Deployment failed"
```bash
# Verificar:
# 1. Java JDK 17+ instalado
# 2. Maven compilación exitosa
# 3. Servidor iniciado correctamente
# 4. Puerto 8080 disponible
```

### Error: "Entity not found"
```bash
# Verificar:
# 1. Tablas creadas en BD
# 2. Entidades JPA correctas
# 3. persistence.xml configurado
# 4. Datasource funcionando
```

---

## 📊 Datos de Prueba Disponibles

### 👥 Usuarios de Login
| Identificación | Contraseña | Nombre |
|----------------|------------|--------|
| 80123456789 | policia2024 | Capitán Jorge Ramírez |
| 79876543210 | fuerza123 | Teniente Ana Morales |
| 81122334455 | seguridad456 | Sargento Carlos Herrera |

### 📋 Endpoints Disponibles
```
GET    /api/fuerzaPublicas              # Listar todos
GET    /api/fuerzaPublicas/{id}         # Obtener por ID
GET    /api/fuerzaPublicas/identificacion/{id}  # Buscar por cédula
POST   /api/fuerzaPublicas              # Crear nuevo
PUT    /api/fuerzaPublicas/{id}         # Actualizar
DELETE /api/fuerzaPublicas/{id}         # Eliminar

POST   /api/auth/fuerza-publica/login   # Login
POST   /api/auth/fuerza-publica/register # Registro
```

---

## ✅ Checklist Final

- [ ] XAMPP Apache y MySQL iniciados
- [ ] Base de datos `koncheck_db` creada con datos
- [ ] Servidor de aplicaciones instalado e iniciado
- [ ] MySQL driver copiado al servidor
- [ ] Datasource configurado correctamente
- [ ] Proyecto compilado con Maven
- [ ] WAR desplegado exitosamente
- [ ] Test de conexión exitoso
- [ ] Endpoints funcionando
- [ ] Login de usuarios funcionando

---

## 🎯 Comandos Rápidos

### Iniciar Todo
```bash
# 1. Iniciar XAMPP (Apache + MySQL)
# 2. Iniciar servidor de aplicaciones
cd C:\glassfish7\bin
asadmin start-domain domain1

# 3. Compilar y desplegar
cd C:\ruta\proyecto\KonCheckKKK
mvn clean package
asadmin deploy target/koncheck-backend.war

# 4. Probar
# Abrir: test-conexion-fuerza-publica.html
```

### Logs Útiles
```bash
# GlassFish logs
tail -f C:\glassfish7\glassfish\domains\domain1\logs\server.log

# WildFly logs
tail -f C:\wildfly-30.0.0.Final\standalone\log\server.log

# MySQL logs (XAMPP)
# Ver en: C:\xampp\mysql\data\*.err
```

---

**¡Tu proyecto Java ya está conectado a XAMPP!** 🎉

Para cualquier problema, revisa los logs del servidor y verifica que todos los servicios estén ejecutándose correctamente.