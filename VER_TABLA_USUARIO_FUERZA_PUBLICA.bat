@echo off
echo ========================================
echo   KONCHECK - VER TABLA USUARIO_FUERZA_PUBLICA
echo ========================================
echo.
echo Abriendo consulta de tabla usuario_fuerza_publica...
echo.

REM Verificar servicios XAMPP
echo Verificando servicios XAMPP...
tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I /N "httpd.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Apache esta corriendo
) else (
    echo ❌ Apache no esta corriendo - Inicia XAMPP
    pause
    exit
)

tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ MySQL esta corriendo
) else (
    echo ❌ MySQL no esta corriendo - Inicia MySQL en XAMPP
    pause
    exit
)

echo.
echo Abriendo archivo PHP...
start "" "http://localhost/KonCheckKKK/ver-tabla-usuario-fuerza-publica.php"

echo.
echo ✅ Archivo abierto correctamente
echo.
echo INFORMACION:
echo - Busca en tabla: usuario_fuerza_publica
echo - Si no existe, busca en: fuerza_publica
echo - Muestra estructura y datos completos
echo - Conexion: mysql://root:@localhost:3306/koncheck_db
echo.
pause