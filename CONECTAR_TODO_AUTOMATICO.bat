@echo off
echo ========================================
echo 🚀 CONEXION AUTOMATICA COMPLETA
echo ========================================
echo Este script configura TODA la conexion automaticamente
echo.

set "error_total=0"

echo ⏳ Verificando requisitos...

REM Verificar XAMPP MySQL
netstat -an | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: XAMPP MySQL no está ejecutándose
    echo 📋 SOLUCION: Abrir XAMPP Control Panel e iniciar MySQL
    pause
    exit /b 1
)
echo ✅ XAMPP MySQL ejecutándose

REM Verificar XAMPP Apache
netstat -an | findstr :80 >nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: XAMPP Apache no está ejecutándose
    echo 📋 SOLUCION: Abrir XAMPP Control Panel e iniciar Apache
    pause
    exit /b 1
)
echo ✅ XAMPP Apache ejecutándose

REM Verificar Maven
mvn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Maven no está instalado
    echo 📋 SOLUCION: Instalar Maven desde https://maven.apache.org/download.cgi
    pause
    exit /b 1
)
echo ✅ Maven instalado

REM Verificar Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Java no está instalado
    echo 📋 SOLUCION: Instalar Java JDK 17+
    pause
    exit /b 1
)
echo ✅ Java instalado

echo.
echo ========================================
echo 📊 PASO 1: CONFIGURAR BASE DE DATOS
echo ========================================

REM Verificar si MySQL está disponible
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo ✅ MySQL encontrado en XAMPP
    
    echo 🔧 Creando base de datos automáticamente...
    "C:\xampp\mysql\bin\mysql.exe" -u root --password= < "scripts\09_setup_xampp_fuerza_publica.sql" 2>error_db.log
    
    if %errorlevel% equ 0 (
        echo ✅ Base de datos creada exitosamente
        del error_db.log 2>nul
    ) else (
        echo ❌ Error al crear base de datos
        echo 📋 SOLUCION MANUAL: 
        echo    1. Ir a http://localhost/phpmyadmin
        echo    2. Hacer clic en "SQL"
        echo    3. Copiar contenido de scripts\09_setup_xampp_fuerza_publica.sql
        echo    4. Hacer clic en "Continuar"
        type error_db.log 2>nul
        set /a error_total+=1
    )
) else (
    echo ⚠️ MySQL no encontrado, usar método manual
    echo 📋 SOLUCION MANUAL:
    echo    1. Ir a http://localhost/phpmyadmin
    echo    2. Hacer clic en "SQL"
    echo    3. Copiar contenido de scripts\09_setup_xampp_fuerza_publica.sql
    echo    4. Hacer clic en "Continuar"
    set /a error_total+=1
)

echo.
echo ========================================
echo 🔧 PASO 2: CONFIGURAR GLASSFISH
echo ========================================

if exist "C:\glassfish7\bin\asadmin.bat" (
    echo ✅ GlassFish encontrado
    call "scripts\configurar_glassfish_xampp.bat"
    if %errorlevel% neq 0 (
        echo ❌ Error configurando GlassFish
        set /a error_total+=1
    )
) else (
    echo ⚠️ GlassFish no encontrado
    echo 📋 SOLUCION:
    echo    1. Descargar GlassFish desde: https://glassfish.org/download
    echo    2. Instalar en C:\glassfish7
    echo    3. Ejecutar nuevamente este script
    set /a error_total+=1
)

echo.
echo ========================================
echo 🏗️ PASO 3: COMPILAR PROYECTO
echo ========================================

echo 🔧 Compilando proyecto...
mvn clean compile
if %errorlevel% neq 0 (
    echo ❌ Error de compilación
    echo 📋 SOLUCION: Revisar errores de Java arriba
    set /a error_total+=1
) else (
    echo ✅ Proyecto compilado exitosamente
)

echo 🔧 Creando WAR...
mvn package
if %errorlevel% neq 0 (
    echo ❌ Error creando WAR
    set /a error_total+=1
) else (
    echo ✅ WAR creado: target\koncheck-backend.war
)

echo.
echo ========================================
echo 🚀 PASO 4: DESPLEGAR APLICACION
echo ========================================

if exist "C:\glassfish7\bin\asadmin.bat" (
    echo 🔧 Desplegando aplicación...
    cd /d "C:\glassfish7\bin"
    call asadmin undeploy koncheck-backend 2>nul
    cd /d "%~dp0"
    call "C:\glassfish7\bin\asadmin" deploy target\koncheck-backend.war
    if %errorlevel% neq 0 (
        echo ❌ Error desplegando aplicación
        set /a error_total+=1
    ) else (
        echo ✅ Aplicación desplegada exitosamente
    )
) else (
    echo ⚠️ No se puede desplegar sin GlassFish
    set /a error_total+=1
)

echo.
echo ========================================
echo 🧪 PASO 5: VERIFICAR CONEXION
echo ========================================

timeout /t 3 /nobreak >nul

REM Verificar base de datos
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo USE koncheck_db; SELECT COUNT(*) FROM fuerza_publica; | "C:\xampp\mysql\bin\mysql.exe" -u root --password= -s >temp_count.txt 2>nul
    set /p fp_count=<temp_count.txt
    del temp_count.txt 2>nul
    
    if %fp_count% gtr 0 (
        echo ✅ Base de datos: %fp_count% registros de fuerza pública
    ) else (
        echo ❌ Base de datos: Sin datos
        set /a error_total+=1
    )
)

REM Verificar aplicación
curl -s -o nul -w "%%{http_code}" http://localhost:8080/koncheck-backend/ >temp_app.txt 2>nul
set /p app_status=<temp_app.txt
del temp_app.txt 2>nul

if "%app_status%"=="200" (
    echo ✅ Aplicación: Funcionando (HTTP 200)
) else (
    echo ❌ Aplicación: No responde (HTTP %app_status%)
    set /a error_total+=1
)

REM Verificar API
curl -s -o nul -w "%%{http_code}" http://localhost:8080/koncheck-backend/api/fuerzaPublicas >temp_api.txt 2>nul
set /p api_status=<temp_api.txt
del temp_api.txt 2>nul

if "%api_status%"=="200" (
    echo ✅ API: Funcionando (HTTP 200)
) else (
    echo ❌ API: No responde (HTTP %api_status%)
    set /a error_total+=1
)

echo.
echo ========================================
echo 📊 RESULTADO FINAL
echo ========================================

if %error_total% equ 0 (
    echo 🎉 ¡CONEXION COMPLETADA EXITOSAMENTE!
    echo.
    echo 🌐 URLs disponibles:
    echo    - phpMyAdmin: http://localhost/phpmyadmin
    echo    - Aplicación: http://localhost:8080/koncheck-backend/
    echo    - API: http://localhost:8080/koncheck-backend/api/fuerzaPublicas
    echo    - Test: test-conexion-fuerza-publica.html
    echo.
    echo 👥 Usuarios de prueba:
    echo    - ID: 80123456789, Password: policia2024 (Capitán Jorge)
    echo    - ID: 79876543210, Password: fuerza123 (Teniente Ana)
    echo    - ID: 81122334455, Password: seguridad456 (Sargento Carlos)
    echo.
    echo ✅ ¡Tu sistema está 100%% funcional!
) else (
    echo ❌ SE ENCONTRARON %error_total% PROBLEMAS
    echo.
    echo 📋 SOLUCIONES SUGERIDAS:
    echo    1. Revisar los errores mostrados arriba
    echo    2. Seguir las soluciones manuales indicadas
    echo    3. Consultar: CONECTAR_BASE_DATOS_FACIL.md
    echo    4. Ejecutar: verificar_conexion_completa.bat
    echo.
    echo 🔧 PASOS MANUALES ALTERNATIVOS:
    echo    1. Base de datos: Ir a http://localhost/phpmyadmin
    echo    2. Ejecutar SQL: scripts\09_setup_xampp_fuerza_publica.sql
    echo    3. Configurar servidor: scripts\configurar_glassfish_xampp.bat
    echo    4. Compilar: mvn clean package
    echo    5. Desplegar: asadmin deploy target\koncheck-backend.war
)

echo.
echo 📖 Para más ayuda, consulta: CONECTAR_BASE_DATOS_FACIL.md
echo.
pause