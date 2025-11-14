@echo off
echo ====================================
echo   Compilando y ejecutando KonCheck
echo ====================================

REM Verificar si existe Maven
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Maven no encontrado. Intentando usar NetBeans...
    goto :netbeans
)

REM Compilar con Maven
echo Compilando con Maven...
mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo Error al compilar con Maven
    goto :netbeans
)

echo Compilacion exitosa con Maven
goto :deploy

:netbeans
echo Abriendo NetBeans para compilar el proyecto...
start "" "C:\Program Files\NetBeans-23\netbeans\bin\netbeans64.exe" --open "%CD%"
echo.
echo INSTRUCCIONES PARA NETBEANS:
echo 1. NetBeans se abrira automaticamente
echo 2. Haz clic derecho en el proyecto KonCheck
echo 3. Selecciona "Clean and Build"
echo 4. Luego "Run" para ejecutar
echo.
pause
goto :end

:deploy
echo.
echo ====================================
echo   Proyecto compilado exitosamente
echo ====================================
echo.
echo El archivo WAR esta en: target\koncheck-backend.war
echo.
echo SIGUIENTE PASO:
echo Despliega el archivo WAR en GlassFish o ejecuta:
echo asadmin deploy target\koncheck-backend.war
echo.

:end
pause