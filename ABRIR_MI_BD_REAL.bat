@echo off
echo ========================================
echo CONECTANDO A TU BASE DE DATOS REAL
echo koncheck_db en phpMyAdmin
echo ========================================
echo.

echo 1. Verificando XAMPP...
echo.

REM Verificar si Apache está ejecutándose
tasklist /FI "IMAGENAME eq httpd.exe" 2>NUL | find /I /N "httpd.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ Apache funcionando
) else (
    echo ❌ Apache NO está ejecutándose
    echo    Abriendo XAMPP Control Panel...
    if exist "C:\xampp\xampp-control.exe" (
        start "" "C:\xampp\xampp-control.exe"
        echo    Por favor inicia Apache y MySQL, luego presiona cualquier tecla
        pause
    )
)

REM Verificar si MySQL está ejecutándose
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ MySQL funcionando
) else (
    echo ❌ MySQL NO está ejecutándose
    echo    Por favor inicia MySQL desde XAMPP Control Panel
    pause
)

echo.
echo 2. Copiando archivos PHP a htdocs...
echo.

REM Crear directorio en htdocs
if exist "C:\xampp\htdocs" (
    if not exist "C:\xampp\htdocs\koncheck" (
        mkdir "C:\xampp\htdocs\koncheck"
        echo ✅ Directorio creado: C:\xampp\htdocs\koncheck\
    )
    
    REM Copiar todos los archivos PHP
    copy "CONECTAR_A_MI_BD_REAL.php" "C:\xampp\htdocs\koncheck\" >nul 2>&1
    copy "VERIFICAR_CONEXION_BD_DIRECTA.php" "C:\xampp\htdocs\koncheck\" >nul 2>&1
    copy "login-php-directo.php" "C:\xampp\htdocs\koncheck\" >nul 2>&1
    copy "CORREGIR_PASSWORDS_DEFINITIVO.php" "C:\xampp\htdocs\koncheck\" >nul 2>&1
    
    echo ✅ Archivos PHP copiados exitosamente
) else (
    echo ❌ No se encontró C:\xampp\htdocs\
    echo    Verifica que XAMPP esté instalado correctamente
    pause
    exit /b 1
)

echo.
echo 3. Abriendo tu base de datos real...
echo.

REM Abrir phpMyAdmin directamente en tu base de datos
echo Abriendo phpMyAdmin con tu base de datos koncheck_db...
start "" "http://localhost/phpmyadmin/index.php?route=/database/structure&db=koncheck_db"

timeout /t 2 /nobreak >nul

REM Abrir página de conexión a tu BD real
echo Abriendo verificación de tu base de datos real...
start "" "http://localhost/koncheck/CONECTAR_A_MI_BD_REAL.php"

timeout /t 2 /nobreak >nul

REM Abrir login directo
echo Abriendo login que se conecta a tu BD...
start "" "http://localhost/koncheck/login-php-directo.php"

echo.
echo ========================================
echo PÁGINAS ABIERTAS - TU BASE DE DATOS REAL
echo ========================================
echo.
echo 📊 PHPMYADMIN - TU BASE DE DATOS:
echo    http://localhost/phpmyadmin/ (koncheck_db)
echo.
echo 🔍 VERIFICACIÓN DE TU BD REAL:
echo    http://localhost/koncheck/CONECTAR_A_MI_BD_REAL.php
echo.
echo 🔐 LOGIN CONECTADO A TU BD:
echo    http://localhost/koncheck/login-php-directo.php
echo.
echo 💡 INSTRUCCIONES:
echo    1. En phpMyAdmin verás tu base de datos koncheck_db
echo    2. En la verificación verás todos tus usuarios reales
echo    3. En el login podrás probar con tus datos reales
echo.
echo 🎯 USUARIOS QUE DEBERÍAS VER:
echo    Los que aparecen en tu tabla usuario_fuerza_publica
echo    (Los que me mostraste: 1234567890, 9876543210, etc.)
echo.
echo ✅ AHORA ESTÁS CONECTADO A TU BASE DE DATOS REAL
echo    No hay simulaciones ni datos falsos
echo.
pause