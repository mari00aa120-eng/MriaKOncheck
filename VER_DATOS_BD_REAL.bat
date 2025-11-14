@echo off
echo ========================================
echo    KONCHECK - VER DATOS BD REAL
echo ========================================
echo.
echo Abriendo conexion directa a tu base de datos...
echo.

REM Verificar que XAMPP este corriendo
echo Verificando XAMPP...
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
echo Abriendo archivo PHP con conexion directa...
start "" "http://localhost/KonCheckKKK/ver-datos-bd-real.php"

echo.
echo ✅ Archivo abierto correctamente
echo.
echo INFORMACION:
echo - Conexion: mysql://root:@localhost:3306/koncheck_db
echo - Muestra datos reales de tu base de datos
echo - Si hay error, verifica que la BD exista
echo.
pause