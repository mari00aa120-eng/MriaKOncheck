-- ========================================
-- VERIFICACIÓN DE CAMPOS OBLIGATORIOS
-- ========================================
-- Este script verifica que no haya campos NULL en las tablas

USE koncheck_db;

-- ========================================
-- 1. VERIFICAR TABLA FUERZA_PUBLICA
-- ========================================
SELECT 'VERIFICANDO CAMPOS NULL EN FUERZA_PUBLICA' AS mensaje;

-- Contar registros con campos NULL
SELECT 
    'Registros con identificacion NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE identificacion IS NULL OR identificacion = '';

SELECT 
    'Registros con nombres NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE nombres IS NULL OR nombres = '';

SELECT 
    'Registros con apellidos NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE apellidos IS NULL OR apellidos = '';

SELECT 
    'Registros con fecha_nacimiento NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE fecha_nacimiento IS NULL;

SELECT 
    'Registros con lugar_nacimiento NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE lugar_nacimiento IS NULL OR lugar_nacimiento = '';

SELECT 
    'Registros con rh NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE rh IS NULL OR rh = '';

SELECT 
    'Registros con fecha_expedicion NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE fecha_expedicion IS NULL;

SELECT 
    'Registros con lugar_expedicion NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE lugar_expedicion IS NULL OR lugar_expedicion = '';

SELECT 
    'Registros con estatura NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE estatura IS NULL OR estatura = 0;

SELECT 
    'Registros con estado_judicial NULL' as campo,
    COUNT(*) as cantidad
FROM fuerza_publica 
WHERE estado_judicial IS NULL OR estado_judicial = '';

-- ========================================
-- 2. VERIFICAR TABLA USUARIO_FUERZA_PUBLICA
-- ========================================
SELECT 'VERIFICANDO CAMPOS NULL EN USUARIO_FUERZA_PUBLICA' AS mensaje;

-- Contar registros con campos NULL obligatorios
SELECT 
    'Registros con identificacion NULL' as campo,
    COUNT(*) as cantidad
FROM usuario_fuerza_publica 
WHERE identificacion IS NULL OR identificacion = '';

SELECT 
    'Registros con nombres NULL' as campo,
    COUNT(*) as cantidad
FROM usuario_fuerza_publica 
WHERE nombres IS NULL OR nombres = '';

SELECT 
    'Registros con apellidos NULL' as campo,
    COUNT(*) as cantidad
FROM usuario_fuerza_publica 
WHERE apellidos IS NULL OR apellidos = '';

SELECT 
    'Registros con password NULL' as campo,
    COUNT(*) as cantidad
FROM usuario_fuerza_publica 
WHERE password IS NULL OR password = '';

SELECT 
    'Registros con activo NULL' as campo,
    COUNT(*) as cantidad
FROM usuario_fuerza_publica 
WHERE activo IS NULL;

-- ========================================
-- 3. MOSTRAR REGISTROS COMPLETOS
-- ========================================
SELECT 'MUESTRA DE REGISTROS COMPLETOS - FUERZA_PUBLICA' AS mensaje;
SELECT 
    identificacion,
    nombres,
    apellidos,
    fecha_nacimiento,
    lugar_nacimiento,
    rh,
    fecha_expedicion,
    lugar_expedicion,
    estatura,
    estado_judicial,
    activo
FROM fuerza_publica 
LIMIT 5;

SELECT 'MUESTRA DE REGISTROS COMPLETOS - USUARIO_FUERZA_PUBLICA' AS mensaje;
SELECT 
    identificacion,
    nombres,
    apellidos,
    CASE 
        WHEN password IS NOT NULL AND password != '' THEN 'CONTRASEÑA CONFIGURADA'
        ELSE 'SIN CONTRASEÑA'
    END as password_status,
    fecha_nacimiento,
    lugar_nacimiento,
    rh,
    fecha_expedicion,
    lugar_expedicion,
    estatura,
    estado_judicial,
    activo
FROM usuario_fuerza_publica 
LIMIT 5;

-- ========================================
-- 4. RESUMEN FINAL
-- ========================================
SELECT 'RESUMEN FINAL DE VERIFICACIÓN' AS mensaje;

SELECT 
    'fuerza_publica' as tabla,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN identificacion IS NOT NULL AND identificacion != '' THEN 1 END) as identificaciones_validas,
    COUNT(CASE WHEN nombres IS NOT NULL AND nombres != '' THEN 1 END) as nombres_validos,
    COUNT(CASE WHEN apellidos IS NOT NULL AND apellidos != '' THEN 1 END) as apellidos_validos,
    COUNT(CASE WHEN fecha_nacimiento IS NOT NULL THEN 1 END) as fechas_nacimiento_validas,
    COUNT(CASE WHEN estatura IS NOT NULL AND estatura > 0 THEN 1 END) as estaturas_validas
FROM fuerza_publica;

SELECT 
    'usuario_fuerza_publica' as tabla,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN identificacion IS NOT NULL AND identificacion != '' THEN 1 END) as identificaciones_validas,
    COUNT(CASE WHEN nombres IS NOT NULL AND nombres != '' THEN 1 END) as nombres_validos,
    COUNT(CASE WHEN apellidos IS NOT NULL AND apellidos != '' THEN 1 END) as apellidos_validos,
    COUNT(CASE WHEN password IS NOT NULL AND password != '' THEN 1 END) as passwords_validas,
    COUNT(CASE WHEN activo IS NOT NULL THEN 1 END) as estados_activo_validos
FROM usuario_fuerza_publica;

SELECT 'VERIFICACIÓN COMPLETADA' AS mensaje;