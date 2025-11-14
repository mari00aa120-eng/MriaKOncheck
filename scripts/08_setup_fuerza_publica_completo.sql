-- ========================================
-- SCRIPT COMPLETO PARA FUERZA PÚBLICA
-- ========================================
-- Este script crea las tablas y datos de prueba para el módulo de Fuerza Pública

USE koncheck_db;

-- ========================================
-- 1. CREAR TABLA FUERZA_PUBLICA
-- ========================================
DROP TABLE IF EXISTS fuerza_publica;

CREATE TABLE fuerza_publica (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    identificacion VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    lugar_nacimiento VARCHAR(100) NOT NULL,
    rh VARCHAR(5) NOT NULL,
    fecha_expedicion DATE NOT NULL,
    lugar_expedicion VARCHAR(100) NOT NULL,
    estatura DECIMAL(3,2) NOT NULL,
    estado_judicial VARCHAR(50) NOT NULL DEFAULT 'No Requerido',
    rango VARCHAR(50) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    
    -- Índices para optimizar consultas
    INDEX idx_identificacion (identificacion),
    INDEX idx_estado_judicial (estado_judicial),
    INDEX idx_rango (rango),
    INDEX idx_activo (activo),
    INDEX idx_nombres (nombres),
    INDEX idx_apellidos (apellidos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 2. CREAR TABLA USUARIO_FUERZA_PUBLICA
-- ========================================
DROP TABLE IF EXISTS usuario_fuerza_publica;

CREATE TABLE usuario_fuerza_publica (
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
    rango VARCHAR(50),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP NULL,
    
    -- Índices para optimizar consultas
    INDEX idx_identificacion (identificacion),
    INDEX idx_rango (rango),
    INDEX idx_activo (activo),
    INDEX idx_fecha_creacion (fecha_creacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 3. INSERTAR DATOS DE PRUEBA - FUERZA_PUBLICA CON RANGOS
-- ========================================
INSERT INTO fuerza_publica (
    identificacion, nombres, apellidos, fecha_nacimiento, lugar_nacimiento, 
    rh, fecha_expedicion, lugar_expedicion, estatura, estado_judicial, rango
) VALUES
('80123456789', 'Jorge', 'Ramírez Vásquez', '1980-03-15', 'Bogotá', 'O+', '1998-03-15', 'Bogotá', 1.78, 'No Requerido', 'Capitán'),
('79876543210', 'Ana', 'Morales Jiménez', '1985-07-22', 'Medellín', 'A+', '2003-07-22', 'Medellín', 1.68, 'No Requerido', 'Teniente'),
('81122334455', 'Carlos', 'Herrera Silva', '1982-11-10', 'Cali', 'B+', '2000-11-10', 'Cali', 1.82, 'No Requerido', 'Sargento'),
('82556677889', 'Patricia', 'Gutiérrez Ruiz', '1987-05-08', 'Barranquilla', 'AB+', '2005-05-08', 'Barranquilla', 1.65, 'No Requerido', 'Cabo'),
('83988776655', 'Luis', 'Castañeda Morales', '1984-12-03', 'Cartagena', 'O-', '2002-12-03', 'Cartagena', 1.80, 'No Requerido', 'Agente'),
('84357924680', 'Sandra', 'Vargas Herrera', '1988-09-18', 'Bucaramanga', 'A-', '2006-09-18', 'Bucaramanga', 1.62, 'No Requerido', 'Patrullero'),
('85468135790', 'Roberto', 'Jiménez Ortiz', '1981-01-25', 'Pereira', 'B-', '1999-01-25', 'Pereira', 1.85, 'No Requerido', 'Inspector'),
('86111222233', 'Diana', 'Moreno Sánchez', '1986-04-12', 'Manizales', 'AB-', '2004-04-12', 'Manizales', 1.63, 'No Requerido', 'Subteniente'),
('87444555566', 'Andrés', 'Ramírez Torres', '1979-08-30', 'Ibagué', 'O+', '1997-08-30', 'Ibagué', 1.79, 'No Requerido', 'Mayor'),
('88777888899', 'Claudia', 'Hernández Ruiz', '1978-02-14', 'Santa Marta', 'A+', '1996-02-14', 'Santa Marta', 1.67, 'No Requerido', 'Coronel');

-- ========================================
-- 4. INSERTAR DATOS DE PRUEBA - USUARIO_FUERZA_PUBLICA
-- ========================================
INSERT INTO usuario_fuerza_publica (
    identificacion, nombres, apellidos, password, fecha_nacimiento, 
    lugar_nacimiento, rh, fecha_expedicion, lugar_expedicion, 
    estatura, estado_judicial
) VALUES
('1234567890', 'Juan Carlos', 'Pérez García', SHA2('123456', 256), '1985-03-15', 'Bogotá', 'O+', '2003-03-15', 'Bogotá', 1.75, 'No Requerido'),
('9876543210', 'María Elena', 'Rodríguez López', SHA2('password123', 256), '1990-07-22', 'Medellín', 'A+', '2008-07-22', 'Medellín', 1.65, 'No Requerido'),
('1122334455', 'Carlos Alberto', 'Martínez Silva', SHA2('admin2024', 256), '1988-11-10', 'Cali', 'B+', '2006-11-10', 'Cali', 1.80, 'No Requerido'),
('5566778899', 'Ana Patricia', 'González Ruiz', SHA2('fuerza2024', 256), '1992-05-08', 'Barranquilla', 'AB+', '2010-05-08', 'Barranquilla', 1.68, 'No Requerido'),
('9988776655', 'Luis Fernando', 'Castro Morales', SHA2('policia123', 256), '1987-12-03', 'Cartagena', 'O-', '2005-12-03', 'Cartagena', 1.78, 'No Requerido');

-- ========================================
-- 5. VERIFICACIONES
-- ========================================
SELECT 'VERIFICACIÓN DE TABLAS CREADAS' AS mensaje;

-- Verificar tabla fuerza_publica
SELECT 
    'fuerza_publica' as tabla,
    COUNT(*) as total_registros,
    COUNT(DISTINCT identificacion) as identificaciones_unicas
FROM fuerza_publica;

-- Verificar tabla usuario_fuerza_publica
SELECT 
    'usuario_fuerza_publica' as tabla,
    COUNT(*) as total_registros,
    COUNT(DISTINCT identificacion) as identificaciones_unicas
FROM usuario_fuerza_publica;

-- Mostrar algunos registros de ejemplo
SELECT 'DATOS DE EJEMPLO - FUERZA_PUBLICA' AS mensaje;
SELECT identificacion, nombres, apellidos, estado_judicial FROM fuerza_publica LIMIT 5;

SELECT 'DATOS DE EJEMPLO - USUARIO_FUERZA_PUBLICA' AS mensaje;
SELECT identificacion, nombres, apellidos, activo FROM usuario_fuerza_publica LIMIT 5;

SELECT 'SETUP COMPLETADO EXITOSAMENTE' AS mensaje;