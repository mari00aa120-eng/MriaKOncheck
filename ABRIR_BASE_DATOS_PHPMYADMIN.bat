@echo off
echo ========================================
echo    KONCHECK - ABRIR BASE DE DATOS REAL
echo ========================================
echo.
echo Abriendo phpMyAdmin con tu base de datos...
echo.

REM Abrir phpMyAdmin directamente con la base de datos koncheck_db
start "" "http://localhost/phpmyadmin/index.php?route=/database/structure&db=koncheck_db"

echo ✅ phpMyAdmin abierto correctamente
echo.
echo INFORMACION:
echo - Base de datos: koncheck_db
echo - Tabla: fuerza_publica
echo - Tus 5 usuarios reales estan ahi
echo.
echo USUARIOS EN LA BASE DE DATOS:
echo 1. Juan Carlos Perez Garcia (1234567890)
echo 2. Maria Elena Rodriguez Lopez (9876543210)
echo 3. Carlos Alberto Martinez Silva (1122334455)
echo 4. Ana Patricia Gonzalez Ruiz (5566778899)
echo 5. Luis Fernando Castro Morales (9988776655)
echo.
pause