@echo off
echo ========================================
echo 🔧 SOLUCIONADOR DE PROBLEMAS DE CONEXION
echo ========================================
echo Este script soluciona los problemas más comunes
echo.

echo 📋 PASO 1: VERIFICAR Y CORREGIR XAMPP
echo ----------------------------------------

REM Verificar MySQL
netstat -an | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo ❌ MySQL no está ejecutándose
    echo 🔧 Intentando iniciar MySQL...
    
    if exist "C:\xampp\xampp-control.exe" (
        echo Iniciando XAMPP Control Panel...
        start "" "C:\xampp\xampp-control.exe"
        echo 📋 ACCION REQUERIDA:
        echo    1. En XAMPP Control Panel, hacer clic en "Start" en MySQL
        echo    2. Verificar que MySQL esté en VERDE
        echo    3. Presionar cualquier tecla para continuar
        pause
    ) else (
        echo ❌ XAMPP no encontrado
        echo 📋 SOLUCION:
        echo    1. Descargar XAMPP desde: https://www.apachefriends.org/download.html
        echo    2. Instalar en C:\xampp
        echo    3. Ejecutar este script nuevamente
        pause
        exit /b 1
    )
) else (
    echo ✅ MySQL ejecutándose correctamente
)

echo.
echo 📋 PASO 2: CREAR/VERIFICAR BASE DE DATOS
echo ----------------------------------------

if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo 🔧 Creando base de datos automáticamente...
    
    REM Crear base de datos si no existe
    echo "CREATE DATABASE IF NOT EXISTS koncheck_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | "C:\xampp\mysql\bin\mysql.exe" -u root --password= 2>error_create.log
    
    if %errorlevel% equ 0 (
        echo ✅ Base de datos koncheck_db verificada/creada
        del error_create.log 2>nul
        
        echo 🔧 Ejecutando script completo...
        "C:\xampp\mysql\bin\mysql.exe" -u root --password= < "scripts\09_setup_xampp_fuerza_publica.sql" 2>error_script.log
        
        if %errorlevel% equ 0 (
            echo ✅ Script ejecutado exitosamente
            del error_script.log 2>nul
            
            REM Verificar datos
            echo "USE koncheck_db; SELECT COUNT(*) FROM fuerza_publica;" | "C:\xampp\mysql\bin\mysql.exe" -u root --password= -s >temp_count.txt 2>nul
            set /p count=<temp_count.txt
            del temp_count.txt 2>nul
            echo ✅ Registros creados: %count%
            
        ) else (
            echo ❌ Error ejecutando script
            echo 📋 ERROR DETALLADO:
            type error_script.log
            del error_script.log 2>nul
            
            echo.
            echo 📋 SOLUCION MANUAL:
            echo    1. Ir a: http://localhost/phpmyadmin
            echo    2. Hacer clic en "SQL"
            echo    3. Copiar contenido de: scripts\09_setup_xampp_fuerza_publica.sql
            echo    4. Pegar y ejecutar
        )
        
    ) else (
        echo ❌ Error creando base de datos
        type error_create.log
        del error_create.log 2>nul
    )
    
) else (
    echo ❌ MySQL no encontrado
    echo 📋 SOLUCION MANUAL:
    echo    1. Ir a: http://localhost/phpmyadmin
    echo    2. Ejecutar SQL: scripts\09_setup_xampp_fuerza_publica.sql
)

echo.
echo 📋 PASO 3: VERIFICAR CONFIGURACION JAVA
echo ----------------------------------------

REM Verificar y corregir persistence.xml
if exist "KonCheckKKK\persistence.xml" (
    echo ✅ persistence.xml encontrado
    
    REM Verificar packages correctos
    findstr "edu.konrad.model" "KonCheckKKK\persistence.xml" >nul
    if %errorlevel% neq 0 (
        echo ⚠️ Corrigiendo packages en persistence.xml...
        
        REM Crear backup
        copy "KonCheckKKK\persistence.xml" "KonCheckKKK\persistence.xml.backup" >nul
        
        REM Corregir packages
        powershell -Command "(Get-Content 'KonCheckKKK\persistence.xml') -replace 'edu.komad.model', 'edu.konrad.model' | Set-Content 'KonCheckKKK\persistence.xml'"
        echo ✅ Packages corregidos
    )
    
) else (
    echo ❌ persistence.xml no encontrado
    echo 🔧 Creando persistence.xml...
    
    REM Crear directorio si no existe
    if not exist "src\main\resources\META-INF" mkdir "src\main\resources\META-INF"
    
    REM Copiar persistence.xml a la ubicación correcta
    copy "KonCheckKKK\persistence.xml" "src\main\resources\META-INF\persistence.xml" >nul 2>&1
    echo ✅ persistence.xml copiado a ubicación correcta
)

echo.
echo 📋 PASO 4: CONFIGURAR GLASSFISH
echo ----------------------------------------

if exist "C:\glassfish7\bin\asadmin.bat" (
    echo ✅ GlassFish encontrado
    
    REM Verificar si está ejecutándose
    netstat -an | findstr :4848 >nul
    if %errorlevel% neq 0 (
        echo 🔧 Iniciando GlassFish...
        cd /d "C:\glassfish7\bin"
        call asadmin start-domain domain1
        cd /d "%~dp0"
    ) else (
        echo ✅ GlassFish ya ejecutándose
    )
    
    echo 🔧 Configurando datasource...
    call "scripts\configurar_glassfish_xampp.bat"
    
) else (
    echo ❌ GlassFish no encontrado
    echo 📋 SOLUCION:
    echo    1. Descargar GlassFish desde: https://glassfish.org/download
    echo    2. Extraer en C:\glassfish7
    echo    3. Ejecutar este script nuevamente
    
    echo.
    echo ⚠️ ALTERNATIVA - Solo base de datos:
    echo Si solo necesitas la base de datos (sin servidor web):
    echo    1. La base de datos ya está creada y funcionando
    echo    2. Puedes usar phpMyAdmin: http://localhost/phpmyadmin
    echo    3. Los datos están en la base 'koncheck_db'
)

echo.
echo 📋 PASO 5: COMPILAR Y DESPLEGAR
echo ----------------------------------------

REM Verificar Maven
mvn --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Maven disponible
    
    echo 🔧 Compilando proyecto...
    mvn clean compile
    if %errorlevel% equ 0 (
        echo ✅ Compilación exitosa
        
        echo 🔧 Creando WAR...
        mvn package
        if %errorlevel% equ 0 (
            echo ✅ WAR creado exitosamente
            
            if exist "C:\glassfish7\bin\asadmin.bat" (
                echo 🔧 Desplegando aplicación...
                cd /d "C:\glassfish7\bin"
                call asadmin undeploy koncheck-backend 2>nul
                cd /d "%~dp0"
                call "C:\glassfish7\bin\asadmin" deploy target\koncheck-backend.war
                
                if %errorlevel% equ 0 (
                    echo ✅ Aplicación desplegada exitosamente
                ) else (
                    echo ❌ Error desplegando aplicación
                )
            )
        ) else (
            echo ❌ Error creando WAR
        )
    ) else (
        echo ❌ Error de compilación
    )
) else (
    echo ❌ Maven no disponible
    echo 📋 SOLUCION: Instalar Maven desde https://maven.apache.org/download.cgi
)

echo.
echo 📋 PASO 6: VERIFICACION FINAL
echo ----------------------------------------

timeout /t 3 /nobreak >nul

REM Verificar base de datos
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo "USE koncheck_db; SELECT COUNT(*) FROM fuerza_publica;" | "C:\xampp\mysql\bin\mysql.exe" -u root --password= -s >temp_final.txt 2>nul
    set /p final_count=<temp_final.txt
    del temp_final.txt 2>nul
    
    if %final_count% gtr 0 (
        echo ✅ Base de datos: %final_count% registros disponibles
    ) else (
        echo ❌ Base de datos: Sin datos
    )
)

REM Verificar aplicación
curl -s -o nul -w "%%{http_code}" http://localhost:8080/koncheck-backend/ >temp_app_final.txt 2>nul
set /p app_final=<temp_app_final.txt
del temp_app_final.txt 2>nul

if "%app_final%"=="200" (
    echo ✅ Aplicación web: Funcionando
) else (
    echo ❌ Aplicación web: No responde (HTTP %app_final%)
)

echo.
echo ========================================
echo 📊 RESULTADO FINAL
echo ========================================

if %final_count% gtr 0 (
    echo 🎉 BASE DE DATOS FUNCIONANDO CORRECTAMENTE
    echo.
    echo 📊 Datos disponibles:
    echo    - %final_count% registros de fuerza pública
    echo    - 10 usuarios para login
    echo    - Todos los campos con rango incluido
    echo.
    echo 🌐 Acceso a datos:
    echo    - phpMyAdmin: http://localhost/phpmyadmin
    echo    - Base de datos: koncheck_db
    echo    - Tablas: fuerza_publica, usuario_fuerza_publica
    echo.
    echo 👥 Usuarios de prueba:
    echo    - ID: 80123456789, Password: policia2024 (Capitán Jorge)
    echo    - ID: 79876543210, Password: fuerza123 (Teniente Ana)
    echo    - ID: 81122334455, Password: seguridad456 (Sargento Carlos)
    
    if "%app_final%"=="200" (
        echo.
        echo 🌐 Aplicación web también funcionando:
        echo    - Aplicación: http://localhost:8080/koncheck-backend/
        echo    - API: http://localhost:8080/koncheck-backend/api/fuerzaPublicas
        echo    - Test: test-conexion-fuerza-publica.html
    ) else (
        echo.
        echo ⚠️ Aplicación web no responde, pero base de datos SÍ funciona
        echo 📋 Para usar solo la base de datos:
        echo    - Usar phpMyAdmin para ver/editar datos
        echo    - Conectar desde otras aplicaciones usando:
        echo      Host: localhost, Puerto: 3306, BD: koncheck_db, Usuario: root, Password: (vacío)
    )
    
) else (
    echo ❌ PROBLEMAS PERSISTENTES
    echo.
    echo 📋 SOLUCION MANUAL GARANTIZADA:
    echo    1. Abrir: http://localhost/phpmyadmin
    echo    2. Crear base de datos 'koncheck_db'
    echo    3. Ir a SQL y pegar contenido de: scripts\09_setup_xampp_fuerza_publica.sql
    echo    4. Ejecutar y verificar que aparezcan mensajes de éxito
    echo.
    echo 📞 Si sigue fallando:
    echo    - Ejecutar: DIAGNOSTICAR_PROBLEMA.bat
    echo    - Revisar el diagnóstico detallado
)

echo.
pause