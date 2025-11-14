USE koncheck_db;

CREATE TABLE IF NOT EXISTS fuerza_publica (
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
    estado_judicial VARCHAR(20) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_identificacion (identificacion),
    INDEX idx_estado_judicial (estado_judicial),
    INDEX idx_activo (activo),
    INDEX idx_nombres (nombres),
    INDEX idx_apellidos (apellidos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
