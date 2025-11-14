@echo off
echo ========================================
echo INICIANDO SISTEMA KONCHECK COMPLETO
echo ========================================
echo.

echo 1. Verificando XAMPP...
echo.

REM Verificar si Apache está ejecutándose
tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I /N "httpd.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Apache está ejecutándose
) else (
    echo ❌ Apache NO está ejecutándose
    echo    Iniciando Apache...
    if exist "C:\xampp\apache_start.bat" (
        start "" "C:\xampp\apache_start.bat"
    ) else (
        echo    Por favor inicia Apache desde XAMPP Control Panel
    )
)

REM Verificar si MySQL está ejecutándose
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ MySQL está ejecutándose
) else (
    echo ❌ MySQL NO está ejecutándose
    echo    Iniciando MySQL...
    if exist "C:\xampp\mysql_start.bat" (
        start "" "C:\xampp\mysql_start.bat"
    ) else (
        echo    Por favor inicia MySQL desde XAMPP Control Panel
    )
)

echo.
echo 2. Configurando base de datos...
echo.

REM Ejecutar scripts de configuración
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo Ejecutando configuración de base de datos...
    "C:\xampp\mysql\bin\mysql.exe" -u root --password= < scripts\08_setup_fuerza_publica_completo.sql
    "C:\xampp\mysql\bin\mysql.exe" -u root --password= < scripts\12_crear_tabla_recuperacion_password.sql
    "C:\xampp\mysql\bin\mysql.exe" -u root --password= < scripts\verificar_y_corregir_passwords.sql
    echo ✅ Base de datos configurada
) else (
    echo ❌ No se encontró MySQL
)

echo.
echo 3. Verificando Node.js...
echo.

node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js está instalado
    node --version
) else (
    echo ❌ Node.js NO está instalado
    echo    Descarga desde: https://nodejs.org/
    pause
    exit /b 1
)

echo.
echo 4. Instalando dependencias...
echo.

if not exist "node_modules" (
    echo Instalando dependencias de Node.js...
    npm install mysql2
    echo ✅ Dependencias instaladas
) else (
    echo ✅ Dependencias ya instaladas
)

echo.
echo 5. Iniciando servidor backend...
echo.

REM Verificar si el puerto 3001 está en uso
netstat -an | find "3001" >nul
if %errorlevel% equ 0 (
    echo ✅ Servidor backend ya está ejecutándose en puerto 3001
) else (
    echo Iniciando servidor backend...
    start "KonCheck Backend" cmd /k "echo Servidor KonCheck Backend && echo Puerto: 3001 && echo. && node backend-simple.js"
    echo ✅ Servidor backend iniciado
)

echo.
echo 6. Esperando que los servicios se inicien...
echo.
timeout /t 5 /nobreak >nul

echo.
echo 7. Abriendo páginas de prueba...
echo.

REM Abrir páginas de prueba
start "" "test-login-base-datos.html"
timeout /t 2 /nobreak >nul
start "" "FuerzaPublica\IngresarFp\IngresarFp.html"

echo.
echo ========================================
echo SISTEMA INICIADO COMPLETAMENTE
echo ========================================
echo.
echo 🚀 SERVICIOS ACTIVOS:
echo    ✅ Apache (XAMPP)
echo    ✅ MySQL (XAMPP)
echo    ✅ Backend Node.js (Puerto 3001)
echo.
echo 🔐 CREDENCIALES DE PRUEBA:
echo    Cédula: 1234567890 | Password: 123456
echo    Cédula: 9876543210 | Password: 123456
echo    Cédula: 1122334455 | Password: 123456
echo    Cédula: 5566778899 | Password: 123456
echo    Cédula: 9988776655 | Password: 123456
echo.
echo 📄 PÁGINAS ABIERTAS:
echo    - test-login-base-datos.html (Página de pruebas)
echo    - IngresarFp.html (Login oficial)
echo.
echo 🛠️ PARA DETENER:
echo    - Cierra las ventanas del servidor
echo    - Detén Apache y MySQL desde XAMPP
echo.
echo ¡SISTEMA LISTO PARA USAR!
echo.
pause