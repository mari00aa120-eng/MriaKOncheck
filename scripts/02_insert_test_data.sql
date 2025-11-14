-- Script de inserción de datos de prueba para KonCheck

USE koncheck_db;

-- Insertar administrador de prueba
-- Password: Admin123 (hash BCrypt)
INSERT INTO personas (nombres, apellidos, identificacion, fecha_nacimiento, lugar_nacimiento, rh, fecha_expedicion, lugar_expedicion, estatura)
VALUES ('Admin', 'Sistema', 'admin', '1990-01-01', 'Bogotá', 'O+', '2010-01-01', 'Bogotá', '1.75');

INSERT INTO administradores (id, correo, password, activo)
VALUES (LAST_INSERT_ID(), 'admin@koncheck.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIq.Xqm3Oi', TRUE);

-- Insertar ciudadanos de prueba
INSERT INTO personas (nombres, apellidos, identificacion, fecha_nacimiento, lugar_nacimiento, rh, fecha_expedicion, lugar_expedicion, estatura)
VALUES 
('Juan', 'Pérez', '1088765432', '1990-05-20', 'Bogotá', 'O+', '2008-05-20', 'Bogotá', '1.75'),
('María', 'Gómez', '1054223781', '1988-02-10', 'Medellín', 'A+', '2006-02-10', 'Medellín', '1.65'),
('Carlos', 'Rodríguez', '1092345876', '1992-09-15', 'Cali', 'B+', '2010-09-15', 'Cali', '1.80'),
('Luisa', 'Martínez', '1067890234', '1985-11-30', 'Barranquilla', 'AB+', '2003-11-30', 'Barranquilla', '1.68'),
('Andrés', 'López', '1034567823', '1994-03-22', 'Cartagena', 'O-', '2012-03-22', 'Cartagena', '1.78');

-- Obtener IDs de las personas insertadas y crear ciudadanos
INSERT INTO ciudadanos (id, estado_judicial)
SELECT id, 'No Requerido' FROM personas WHERE identificacion IN ('1088765432', '1054223781', '1092345876', '1067890234', '1034567823');

-- Insertar usuarios de Fuerza Pública de prueba
-- Contraseñas encriptadas con SHA-256
INSERT INTO usuario_fuerza_publica (identificacion, nombres, apellidos, password, estado_judicial) VALUES
('12345678', 'Juan Carlos', 'Pérez García', SHA2('123456', 256), 'No Requerido'),
('87654321', 'María Elena', 'Rodríguez López', SHA2('password123', 256), 'No Requerido'),
('11223344', 'Carlos Alberto', 'Martínez Silva', SHA2('admin2024', 256), 'No Requerido'),
('55667788', 'Ana Patricia', 'González Ruiz', SHA2('fuerza2024', 256), 'No Requerido'),
('99887766', 'Luis Fernando', 'Castro Morales', SHA2('policia123', 256), 'No Requerido');

SELECT 'Datos de prueba insertados exitosamente' AS mensaje;
SELECT 'Administrador: admin@koncheck.com / Admin123' AS credenciales_admin;
SELECT 'Fuerza Pública - ID: 12345678 / Password: 123456' AS credenciales_fp1;
SELECT 'Fuerza Pública - ID: 87654321 / Password: password123' AS credenciales_fp2;
SELECT 'Fuerza Pública - ID: 11223344 / Password: admin2024' AS credenciales_fp3;
