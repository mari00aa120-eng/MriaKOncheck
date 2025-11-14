@echo off
cls
echo ========================================
echo       ABRIR BASE DE DATOS KONCHECK
echo ========================================
echo.

echo 1. Verificando XAMPP...
tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I /N "httpd.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Apache está corriendo
) else (
    echo ❌ Apache no está corriendo
    echo    Inicia XAMPP primero
    pause
    exit
)

tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ MySQL está corriendo
) else (
    echo ❌ MySQL no está corriendo
    echo    Inicia XAMPP primero
    pause
    exit
)

echo.
echo 2. Abriendo phpMyAdmin...
start "" "http://localhost/phpmyadmin"

echo.
echo 3. Esperando 3 segundos...
timeout /t 3 /nobreak >nul

echo.
echo 4. Abriendo directamente la base de datos koncheck_db...
start "" "http://localhost/phpmyadmin/index.php?route=/database/structure&db=koncheck_db"

echo.
echo ✅ Base de datos abierta en el navegador
echo.
echo 📋 Información de la base de datos:
echo    Nombre: koncheck_db
echo    Tabla principal: usuario_fuerza_publica
echo    Total usuarios: 5
echo.
echo 🔍 Usuarios disponibles:
echo    1234567890 - Juan Carlos Pérez García
echo    9876543210 - María Elena Rodríguez López
echo    1122334455 - Carlos Alberto Martínez Silva
echo    5566778899 - Ana Patricia González Ruiz
echo    9988776655 - Luis Fernando Castro Morales
echo.
pause