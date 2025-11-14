package edu.konrad.service;
import edu.konrad.model.Persona;

import jakarta.ws.rs.BadRequestException;
import edu.konrad.model.Administrador;
import edu.konrad.repository.AdministradorRepository;
import edu.konrad.repository.PersonaRepository;
import edu.konrad.security.JwtUtil;
import at.favre.lib.crypto.bcrypt.BCrypt;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotAuthorizedException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Stateless
public class FuerzaPublicaServicev2 {
    
    @Inject
    private PersonaRepository personaRepository;
    @Inject
    private AdministradorRepository administradorRepository;
    
    public Map<String, Object> registrar(String correo, String password) {
        try {
            System.out.println("[v0] ========== AdministradorService.registrar() ==========");
            System.out.println("[v0] Correo: " + correo);
            
            // Validar que el correo no exista
            System.out.println("[v0] Paso 1: Verificando si el correo ya existe...");
            if (administradorRepository.existsByCorreo(correo)) {
                System.out.println("[v0] ERROR: El correo ya existe en la BD");
                throw new BadRequestException("El correo ya está registrado");
            }
            System.out.println("[v0] OK: Correo disponible");
            
            // Validar formato de correo
            System.out.println("[v0] Paso 2: Validando formato de correo...");
            if (!correo.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                System.out.println("[v0] ERROR: Formato de correo inválido");
                throw new BadRequestException("Formato de correo inválido");
            }
            System.out.println("[v0] OK: Formato de correo válido");
            
            // Validar contraseña
            System.out.println("[v0] Paso 3: Validando contraseña...");
            if (password == null || password.length() < 6) {
                System.out.println("[v0] ERROR: Contraseña muy corta");
                throw new BadRequestException("La contraseña debe tener al menos 6 caracteres");
            }
            System.out.println("[v0] OK: Contraseña válida");
            
            System.out.println("[v0] Paso 4: Generando hash de contraseña...");
            String passwordHash = BCrypt.withDefaults().hashToString(12, password.toCharArray());
            System.out.println("[v0] OK: Hash generado");
            
           System.out.println("[v0] Paso 5: Creando persona asociada...");
            Persona persona = new Persona();
            personaRepository.create(persona);
            System.out.println("[v0] OK: Persona creada con ID: " + persona.getId());

            System.out.println("[v0] Paso 6: Creando objeto Administrador asociado...");
            Administrador admin = new Administrador();
            admin.setId(persona.getId()); // Asociar el ID de Persona
            admin.setCorreo(correo);
            admin.setPassword(passwordHash);
            admin.setActivo(true);
            System.out.println("[v0] OK: Administrador asociado a Persona con ID: " + persona.getId());

            
            System.out.println("[v0] Paso 6: Guardando en base de datos...");
            Administrador saved = administradorRepository.create(admin);
            System.out.println("[v0] OK: Administrador guardado con ID: " + saved.getId());
            
            System.out.println("[v0] Paso 7: Generando token JWT...");
            String token = JwtUtil.generateToken(saved.getId(), saved.getCorreo());
            System.out.println("[v0] OK: Token generado");
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Administrador registrado exitosamente");
            response.put("token", token);
            response.put("administrador", Map.of(
                "id", saved.getId(),
                "correo", saved.getCorreo()
            ));
            
            System.out.println("[v0] ========== REGISTRO COMPLETADO ==========");
            return response;
            
        } catch (BadRequestException e) {
            System.err.println("[v0] BadRequestException en servicio: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.err.println("[v0] ========== ERROR EN SERVICIO ==========");
            System.err.println("[v0] Tipo: " + e.getClass().getName());
            System.err.println("[v0] Mensaje: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error al registrar administrador: " + e.getMessage(), e);
        }
    }
    
    public Map<String, Object> login(String correo, String password) {
        // Buscar administrador por correo
        Optional<Administrador> optAdmin = administradorRepository.findByCorreo(correo);
        
        if (optAdmin.isEmpty()) {
            throw new NotAuthorizedException("Credenciales inválidas");
        }
        
        Administrador admin = optAdmin.get();
        
        // Verificar que esté activo
        if (!admin.getActivo()) {
            throw new NotAuthorizedException("Cuenta desactivada");
        }
        
        // Verificar contraseña
        BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), admin.getPassword());
        
        if (!result.verified) {
            throw new NotAuthorizedException("Credenciales inválidas");
        }
        
        // Generar token JWT
        String token = JwtUtil.generateToken(admin.getId(), admin.getCorreo());
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Login exitoso");
        response.put("token", token);
        response.put("administrador", Map.of(
            "id", admin.getId(),
            "correo", admin.getCorreo()
        ));
        
        return response;
    }
    
    public Optional<Administrador> findById(Long id) {
        return administradorRepository.findById(id);
    }
    
    public Optional<Administrador> findByCorreo(String correo) {
        return administradorRepository.findByCorreo(correo);
    }
}
