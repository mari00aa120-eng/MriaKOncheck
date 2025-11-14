-- Script para verificar y corregir las tablas de la base de datos
-- Ejecutar este script si hay problemas con el registro de administradores

USE koncheck_db;

-- Verificar si las tablas existen
SELECT 'Verificando tablas existentes...' AS mensaje;

SELECT 
    TABLE_NAME, 
    TABLE_ROWS 
FROM 
    information_schema.TABLES 
WHERE 
    TABLE_SCHEMA = 'koncheck_db' 
    AND TABLE_NAME IN ('personas', 'administradores', 'ciudadanos', 'documentos');

-- Eliminar tablas si existen (para recrearlas correctamente)
SELECT 'Eliminando tablas existentes...' AS mensaje;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS documentos;
DROP TABLE IF EXISTS ciudadanos;
DROP TABLE IF EXISTS administradores;
DROP TABLE IF EXISTS personas;

SET FOREIGN_KEY_CHECKS = 1;

-- Crear tabla personas (tabla padre)
SELECT 'Creando tabla personas...' AS mensaje;

CREATE TABLE personas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    rh VARCHAR(5),
    fecha_expedicion DATE,
    lugar_expedicion VARCHAR(100),
    estatura VARCHAR(10),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_identificacion (identificacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla administradores (hereda de personas)
SELECT 'Creando tabla administradores...' AS mensaje;

CREATE TABLE administradores (
    id BIGINT PRIMARY KEY,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE,
    INDEX idx_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla ciudadanos (hereda de personas)
SELECT 'Creando tabla ciudadanos...' AS mensaje;

CREATE TABLE ciudadanos (
    id BIGINT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla documentos
SELECT 'Creando tabla documentos...' AS mensaje;

CREATE TABLE documentos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ciudadano_id BIGINT NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    numero_documento VARCHAR(50),
    codigo_barras VARCHAR(100),
    fecha_escaneo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    escaneado_por VARCHAR(100),
    FOREIGN KEY (ciudadano_id) REFERENCES ciudadanos(id) ON DELETE CASCADE,
    INDEX idx_ciudadano (ciudadano_id),
    INDEX idx_codigo_barras (codigo_barras)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT 'Tablas creadas exitosamente' AS mensaje;

-- Verificar estructura de las tablas
SELECT 'Verificando estructura de personas...' AS mensaje;
DESCRIBE personas;

SELECT 'Verificando estructura de administradores...' AS mensaje;
DESCRIBE administradores;

SELECT 'Verificando estructura de ciudadanos...' AS mensaje;
DESCRIBE ciudadanos;

SELECT 'Verificando estructura de documentos...' AS mensaje;
DESCRIBE documentos;

SELECT '✅ Script completado. Las tablas están listas para usar.' AS mensaje;
