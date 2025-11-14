package edu.konrad.service;

import edu.komad.model.UsuarioFuerzaPublica;
import edu.komad.repository.UsuarioFuerzaPublicaRepository;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import java.security.MessageDigest;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

@Stateless
public class AuthFuerzaPublicaService {

    @Inject
    private UsuarioFuerzaPublicaRepository usuarioRepository;

    /**
     * Registrar nuevo usuario de Fuerza Pública
     */
    public UsuarioFuerzaPublica registrarUsuario(String identificacion, String nombres, String apellidos, 
                                               String password, String rango, LocalDate fechaNacimiento, 
                                               String lugarNacimiento, String rh, LocalDate fechaExpedicion, 
                                               String lugarExpedicion, Double estatura) {
        
        // Validar formato de identificación
        if (identificacion == null || !identificacion.matches("^\\d{10,11}$")) {
            throw new RuntimeException("La identificación debe tener entre 10 y 11 dígitos");
        }
        
        // Verificar si ya existe
        if (usuarioRepository.existsByIdentificacion(identificacion)) {
            throw new RuntimeException("Ya existe un usuario con esta identificación");
        }

        // Validar rango
        if (rango != null && !validarRango(rango)) {
            throw new RuntimeException("Rango inválido");
        }

        // Crear nuevo usuario
        UsuarioFuerzaPublica usuario = new UsuarioFuerzaPublica();
        usuario.setIdentificacion(identificacion);
        usuario.setNombres(nombres);
        usuario.setApellidos(apellidos);
        usuario.setPassword(encriptarPassword(password));
        usuario.setRango(rango != null ? rango : "Agente");
        usuario.setFechaNacimiento(fechaNacimiento);
        usuario.setLugarNacimiento(lugarNacimiento);
        usuario.setRh(rh);
        usuario.setFechaExpedicion(fechaExpedicion);
        usuario.setLugarExpedicion(lugarExpedicion);
        usuario.setEstatura(estatura);
        usuario.setEstadoJudicial("No Requerido");

        return usuarioRepository.save(usuario);
    }

    /**
     * Autenticar usuario (login)
     */
    public Optional<UsuarioFuerzaPublica> autenticarUsuario(String identificacion, String password) {
        // Validar formato de identificación
        if (identificacion == null || !identificacion.matches("^\\d{10,11}$")) {
            return Optional.empty();
        }
        
        String passwordEncriptado = encriptarPassword(password);
        Optional<UsuarioFuerzaPublica> usuario = usuarioRepository.findByIdentificacionAndPassword(identificacion, passwordEncriptado);
        
        if (usuario.isPresent()) {
            // Actualizar último acceso
            UsuarioFuerzaPublica u = usuario.get();
            u.actualizarUltimoAcceso();
            usuarioRepository.save(u);
        }
        
        return usuario;
    }

    /**
     * Verificar si existe un usuario
     */
    public boolean existeUsuario(String identificacion) {
        return usuarioRepository.existsByIdentificacion(identificacion);
    }

    /**
     * Obtener usuario por identificación
     */
    public Optional<UsuarioFuerzaPublica> obtenerUsuario(String identificacion) {
        return usuarioRepository.findByIdentificacion(identificacion);
    }

    /**
     * Validar rango de fuerza pública
     */
    private boolean validarRango(String rango) {
        String[] rangosValidos = {
            "Agente", "Patrullero", "Cabo", "Sargento", "Subteniente", 
            "Teniente", "Capitán", "Mayor", "Coronel", "Inspector", 
            "Intendente", "Comisario", "Subcomisario", "Brigadier", "Comandante"
        };
        for (String rangoValido : rangosValidos) {
            if (rangoValido.equalsIgnoreCase(rango)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Encriptar password usando SHA-256
     */
    private String encriptarPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error al encriptar password", e);
        }
    }

    /**
     * Cambiar contraseña
     */
    public boolean cambiarPassword(String identificacion, String passwordAntiguo, String passwordNuevo) {
        Optional<UsuarioFuerzaPublica> usuario = autenticarUsuario(identificacion, passwordAntiguo);
        
        if (usuario.isPresent()) {
            UsuarioFuerzaPublica u = usuario.get();
            u.setPassword(encriptarPassword(passwordNuevo));
            usuarioRepository.save(u);
            return true;
        }
        
        return false;
    }
}