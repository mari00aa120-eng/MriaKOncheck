@echo off
echo ========================================
echo    KONCHECK - PROBAR CONEXION BD
echo ========================================
echo.
echo Probando conexion a la base de datos...
echo.

REM Verificar que XAMPP este corriendo
echo Verificando servicios XAMPP...
tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I /N "httpd.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Apache esta corriendo
) else (
    echo ❌ Apache no esta corriendo
    echo Por favor inicia XAMPP primero
    pause
    exit
)

tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ MySQL esta corriendo
) else (
    echo ❌ MySQL no esta corriendo
    echo Por favor inicia MySQL en XAMPP
    pause
    exit
)

echo.
echo Abriendo archivo de prueba de login...
start "" "http://localhost/KonCheckKKK/api/auth/fuerza-publica/login.php"

echo.
echo ✅ Archivo de prueba abierto
echo.
echo INFORMACION:
echo - URL API: http://localhost/KonCheckKKK/api/auth/fuerza-publica/login.php
echo - Base de datos: koncheck_db
echo - Tabla: fuerza_publica
echo - Conexion: mysql://root:@localhost:3306/koncheck_db
echo.
echo USUARIOS DE PRUEBA:
echo 1234567890 - Juan Carlos Perez Garcia
echo 9876543210 - Maria Elena Rodriguez Lopez
echo 1122334455 - Carlos Alberto Martinez Silva
echo 5566778899 - Ana Patricia Gonzalez Ruiz
echo 9988776655 - Luis Fernando Castro Morales
echo.
pause