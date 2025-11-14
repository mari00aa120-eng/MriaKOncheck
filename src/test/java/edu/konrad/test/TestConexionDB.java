package edu.konrad.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Clase de prueba para verificar la conexión a la base de datos
 */
public class TestConexionDB {
    
    private static final String URL = "jdbc:mysql://localhost:3306/koncheck_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("TEST DE CONEXION A BASE DE DATOS");
        System.out.println("========================================");
        
        try {
            // Cargar driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ Driver MySQL cargado correctamente");
            
            // Establecer conexión
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Conexión establecida exitosamente");
            
            // Probar consulta básica
            Statement stmt = conn.createStatement();
            
            // Verificar tablas de fuerza pública
            System.out.println("\n📊 VERIFICANDO TABLAS:");
            
            // Tabla fuerza_publica
            try {
                ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM fuerza_publica");
                if (rs1.next()) {
                    int count1 = rs1.getInt(1);
                    System.out.println("✅ Tabla fuerza_publica: " + count1 + " registros");
                }
                rs1.close();
            } catch (Exception e) {
                System.out.println("❌ Tabla fuerza_publica: " + e.getMessage());
            }
            
            // Tabla usuario_fuerza_publica
            try {
                ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM usuario_fuerza_publica");
                if (rs2.next()) {
                    int count2 = rs2.getInt(1);
                    System.out.println("✅ Tabla usuario_fuerza_publica: " + count2 + " registros");
                }
                rs2.close();
            } catch (Exception e) {
                System.out.println("❌ Tabla usuario_fuerza_publica: " + e.getMessage());
            }
            
            // Verificar datos de ejemplo
            System.out.println("\n👥 VERIFICANDO DATOS DE EJEMPLO:");
            
            try {
                ResultSet rs3 = stmt.executeQuery("SELECT identificacion, rango, nombres, apellidos FROM fuerza_publica LIMIT 3");
                while (rs3.next()) {
                    System.out.println("✅ " + rs3.getString("rango") + " " + 
                                     rs3.getString("nombres") + " " + 
                                     rs3.getString("apellidos") + 
                                     " (ID: " + rs3.getString("identificacion") + ")");
                }
                rs3.close();
            } catch (Exception e) {
                System.out.println("❌ Error leyendo datos: " + e.getMessage());
            }
            
            // Verificar usuarios para login
            System.out.println("\n🔐 VERIFICANDO USUARIOS PARA LOGIN:");
            
            try {
                ResultSet rs4 = stmt.executeQuery("SELECT identificacion, rango, nombres, apellidos FROM usuario_fuerza_publica LIMIT 3");
                while (rs4.next()) {
                    System.out.println("✅ " + rs4.getString("rango") + " " + 
                                     rs4.getString("nombres") + " " + 
                                     rs4.getString("apellidos") + 
                                     " (Login: " + rs4.getString("identificacion") + ")");
                }
                rs4.close();
            } catch (Exception e) {
                System.out.println("❌ Error leyendo usuarios: " + e.getMessage());
            }
            
            // Cerrar conexión
            stmt.close();
            conn.close();
            
            System.out.println("\n========================================");
            System.out.println("🎉 TEST COMPLETADO EXITOSAMENTE");
            System.out.println("========================================");
            System.out.println("La base de datos está funcionando correctamente");
            System.out.println("Puedes usar phpMyAdmin: http://localhost/phpmyadmin");
            
        } catch (Exception e) {
            System.out.println("\n========================================");
            System.out.println("❌ ERROR EN LA CONEXION");
            System.out.println("========================================");
            System.out.println("Error: " + e.getMessage());
            System.out.println("\n📋 POSIBLES SOLUCIONES:");
            System.out.println("1. Verificar que XAMPP MySQL esté iniciado");
            System.out.println("2. Verificar que la base de datos 'koncheck_db' exista");
            System.out.println("3. Ejecutar: CREAR_BASE_DATOS_SOLO.bat");
            System.out.println("4. Verificar en: http://localhost/phpmyadmin");
        }
    }
}