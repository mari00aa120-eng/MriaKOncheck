-- Script de creación de tablas para KonCheck
-- Compatible con MySQL 8.0+

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS koncheck_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE koncheck_db;

-- =====================================
-- TABLA BASE: PERSONAS
-- =====================================
CREATE TABLE IF NOT EXISTS personas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    identificacion VARCHAR(20) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    rh VARCHAR(5),
    fecha_expedicion DATE,
    lugar_expedicion VARCHAR(100),
    estatura VARCHAR(10),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_identificacion (identificacion),
    INDEX idx_nombres (nombres),
    INDEX idx_apellidos (apellidos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================
-- TABLA ADMINISTRADORES (hereda de personas)
-- =====================================
CREATE TABLE IF NOT EXISTS administradores (
    id BIGINT PRIMARY KEY,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE,
    INDEX idx_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================
-- TABLA CIUDADANOS (hereda de personas)
-- =====================================
CREATE TABLE IF NOT EXISTS ciudadanos (
    id BIGINT PRIMARY KEY,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(30) UNIQUE NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    estado_judicial VARCHAR(50) DEFAULT 'No Requerido',
    FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE,
    INDEX idx_numero_documento (numero_documento),
    INDEX idx_tipo_documento (tipo_documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================
-- TABLA DOCUMENTOS
-- =====================================
CREATE TABLE IF NOT EXISTS documentos (
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

-- =====================================
-- TABLA USUARIOS FUERZA PÚBLICA
-- =====================================
CREATE TABLE IF NOT EXISTS usuario_fuerza_publica (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    rh VARCHAR(5),
    fecha_expedicion DATE,
    lugar_expedicion VARCHAR(100),
    estatura DOUBLE,
    estado_judicial VARCHAR(50) DEFAULT 'No Requerido',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP NULL,
    
    INDEX idx_identificacion (identificacion),
    INDEX idx_activo (activo),
    INDEX idx_fecha_creacion (fecha_creacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================
-- MENSAJE FINAL
-- =====================================
SELECT '✅ Tablas creadas exitosamente' AS mensaje;
