@echo off
echo ========================================
echo COMPILAR Y DESPLEGAR PROYECTO KONCHECK
echo ========================================
echo.

REM Verificar que Maven esté instalado
mvn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Maven no está instalado o no está en el PATH
    echo Instala Maven desde: https://maven.apache.org/download.cgi
    pause
    exit /b 1
)

REM Verificar que GlassFish esté ejecutándose
netstat -an | findstr :4848 >nul
if %errorlevel% neq 0 (
    echo ERROR: GlassFish no está ejecutándose
    echo Ejecuta primero: scripts\configurar_glassfish_xampp.bat
    pause
    exit /b 1
)

echo 1. Limpiando proyecto anterior...
mvn clean
if %errorlevel% neq 0 (
    echo ERROR: No se pudo limpiar el proyecto
    pause
    exit /b 1
)
echo    ✓ Proyecto limpiado exitosamente

echo.
echo 2. Compilando proyecto...
mvn compile
if %errorlevel% neq 0 (
    echo ERROR: Error de compilación
    echo Revisa los errores de Java arriba
    pause
    exit /b 1
)
echo    ✓ Proyecto compilado exitosamente

echo.
echo 3. Empaquetando WAR...
mvn package
if %errorlevel% neq 0 (
    echo ERROR: Error al crear WAR
    pause
    exit /b 1
)
echo    ✓ WAR creado exitosamente: target\koncheck-backend.war

echo.
echo 4. Desinstalando aplicación anterior (si existe)...
cd /d "C:\glassfish7\bin"
call asadmin undeploy koncheck-backend 2>nul
echo    ✓ Aplicación anterior desinstalada

echo.
echo 5. Desplegando nueva aplicación...
cd /d "%~dp0"
call "C:\glassfish7\bin\asadmin" deploy target\koncheck-backend.war
if %errorlevel% neq 0 (
    echo ERROR: Error al desplegar aplicación
    echo Revisa los logs de GlassFish
    pause
    exit /b 1
)
echo    ✓ Aplicación desplegada exitosamente

echo.
echo 6. Verificando despliegue...
timeout /t 5 /nobreak >nul
curl -s -o nul -w "%%{http_code}" http://localhost:8080/koncheck-backend/ >temp_status.txt 2>nul
set /p status=<temp_status.txt
del temp_status.txt 2>nul

if "%status%"=="200" (
    echo    ✓ Aplicación respondiendo correctamente
) else (
    echo    ⚠ Aplicación desplegada pero puede tener problemas
    echo    Status HTTP: %status%
)

echo.
echo ========================================
echo DESPLIEGUE COMPLETADO
echo ========================================
echo.
echo URLs de prueba:
echo - Aplicación: http://localhost:8080/koncheck-backend/
echo - API Fuerza Pública: http://localhost:8080/koncheck-backend/api/fuerzaPublicas
echo - Test de conexión: test-conexion-fuerza-publica.html
echo.
echo Usuarios de prueba:
echo - ID: 80123456789, Password: policia2024
echo - ID: 79876543210, Password: fuerza123
echo - ID: 81122334455, Password: seguridad456
echo.
echo Para ver logs: tail -f C:\glassfish7\glassfish\domains\domain1\logs\server.log
echo.
pause