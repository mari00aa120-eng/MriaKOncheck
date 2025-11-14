package edu.konrad.service;
import edu.konrad.model.FuerzaPublica; // ✅ <-- AGREGA ESTA LÍNEA
import edu.konrad.repository.FuerzaPublicaRepository;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import jakarta.ws.rs.BadRequestException;
@Stateless
public class FuerzaPublicaService {

    @Inject
    private FuerzaPublicaRepository fuerzaPublicaRepository;

    // Validar formato de RH
    private boolean validarRH(String rh) {
        String[] rhValidos = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String tipo : rhValidos) {
            if (tipo.equals(rh.toUpperCase())) {
                return true;
            }
        }
        return false;
    }

    // Validar que solo contenga letras
    private boolean validarSoloLetras(String texto) {
        return texto != null && texto.matches("^[a-zA-ZÁÉÍÓÚáéíóúñÑ\\s]+$");
    }

    // Validar que solo contenga números
    private boolean validarSoloNumeros(String texto) {
        return texto != null && texto.matches("^\\d+$");
    }

    // Validar rango de fuerza pública
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

    public FuerzaPublica crearFuerzaPublica(FuerzaPublica fuerzaPublica) {
        // Validaciones
        if (fuerzaPublica.getIdentificacion() == null || fuerzaPublica.getIdentificacion().trim().isEmpty()) {
            throw new RuntimeException("La identificación es obligatoria");
        }
        
        if (!validarSoloNumeros(fuerzaPublica.getIdentificacion())) {
            throw new BadRequestException("La identificación solo debe contener números");
        }
        if (fuerzaPublica.getNombres() == null || fuerzaPublica.getNombres().trim().isEmpty()) {
            throw new RuntimeException("Los nombres son obligatorios");
        }

        if (!validarSoloLetras(fuerzaPublica.getNombres())) {
            throw new RuntimeException("Los nombres solo deben contener letras");
        }

        if (fuerzaPublica.getApellidos() == null || fuerzaPublica.getApellidos().trim().isEmpty()) {
            throw new RuntimeException("Los apellidos son obligatorios");
        }

        if (!validarSoloLetras(fuerzaPublica.getApellidos())) {
            throw new RuntimeException("Los apellidos solo deben contener letras");
        }

        if (fuerzaPublica.getLugarNacimiento() == null || fuerzaPublica.getLugarNacimiento().trim().isEmpty()) {
            throw new RuntimeException("El lugar de nacimiento es obligatorio");
        }

        if (!validarSoloLetras(fuerzaPublica.getLugarNacimiento())) {
            throw new RuntimeException("El lugar de nacimiento solo debe contener letras");
        }

        if (fuerzaPublica.getRh() == null || fuerzaPublica.getRh().trim().isEmpty()) {
            throw new RuntimeException("El RH es obligatorio");
        }

        if (!validarRH(fuerzaPublica.getRh())) {
            throw new RuntimeException("RH inválido. Valores válidos: A+, A-, B+, B-, AB+, AB-, O+, O-");
        }

        if (fuerzaPublica.getLugarExpedicion() == null || fuerzaPublica.getLugarExpedicion().trim().isEmpty()) {
            throw new RuntimeException("El lugar de expedición es obligatorio");
        }

        if (!validarSoloLetras(fuerzaPublica.getLugarExpedicion())) {
            throw new RuntimeException("El lugar de expedición solo debe contener letras");
        }

        if (fuerzaPublica.getEstatura() == null || fuerzaPublica.getEstatura() <= 0) {
            throw new RuntimeException("La estatura es obligatoria y debe ser mayor a 0");
        }

        if (fuerzaPublica.getEstadoJudicial() == null || fuerzaPublica.getEstadoJudicial().trim().isEmpty()) {
            throw new RuntimeException("El estado judicial es obligatorio");
        }

        if (fuerzaPublica.getRango() == null || fuerzaPublica.getRango().trim().isEmpty()) {
            throw new RuntimeException("El rango es obligatorio");
        }

        if (!validarRango(fuerzaPublica.getRango())) {
            throw new RuntimeException("Rango inválido. Valores válidos: Agente, Patrullero, Cabo, Sargento, Subteniente, Teniente, Capitán, Mayor, Coronel, Inspector, Intendente, Comisario, Subcomisario, Brigadier, Comandante");
        }

        // Validar que la identificación no exista
        Optional<FuerzaPublica> existente = fuerzaPublicaRepository.findByIdentificacion(fuerzaPublica.getIdentificacion());
        if (existente.isPresent()) {
            throw new RuntimeException("Ya existe un registro con la identificación: " + fuerzaPublica.getIdentificacion());
        }
        
        return fuerzaPublicaRepository.save(fuerzaPublica);
    }

    public FuerzaPublica actualizarFuerzaPublica(Long id, FuerzaPublica fuerzaPublica) {
        Optional<FuerzaPublica> existente = fuerzaPublicaRepository.findById(id);
        if (existente.isEmpty()) {
            throw new RuntimeException("No se encontró el registro con ID: " + id);
        }

        FuerzaPublica fpActual = existente.get();
        
        // Validar que la nueva identificación no exista (si cambió)
        if (!fpActual.getIdentificacion().equals(fuerzaPublica.getIdentificacion())) {
            Optional<FuerzaPublica> conMismaIdentificacion = fuerzaPublicaRepository.findByIdentificacion(fuerzaPublica.getIdentificacion());
            if (conMismaIdentificacion.isPresent()) {
                throw new RuntimeException("Ya existe otro registro con la identificación: " + fuerzaPublica.getIdentificacion());
            }
        }

        // Actualizar campos
        fpActual.setIdentificacion(fuerzaPublica.getIdentificacion());
        fpActual.setNombres(fuerzaPublica.getNombres());
        fpActual.setApellidos(fuerzaPublica.getApellidos());
        fpActual.setFechaNacimiento(fuerzaPublica.getFechaNacimiento());
        fpActual.setLugarNacimiento(fuerzaPublica.getLugarNacimiento());
        fpActual.setRh(fuerzaPublica.getRh());
        fpActual.setFechaExpedicion(fuerzaPublica.getFechaExpedicion());
        fpActual.setLugarExpedicion(fuerzaPublica.getLugarExpedicion());
        fpActual.setEstatura(fuerzaPublica.getEstatura());
        fpActual.setEstadoJudicial(fuerzaPublica.getEstadoJudicial());
        fpActual.setRango(fuerzaPublica.getRango());

        return fuerzaPublicaRepository.save(fpActual);
    }

    public void eliminarFuerzaPublica(Long id) {
        Optional<FuerzaPublica> existente = fuerzaPublicaRepository.findById(id);
        if (existente.isEmpty()) {
            throw new RuntimeException("No se encontró el registro con ID: " + id);
        }

        // Eliminación física
        fuerzaPublicaRepository.delete(existente.get());
    }

    public List<FuerzaPublica> obtenerTodos() {
        return fuerzaPublicaRepository.findAll();
    }

    public Optional<FuerzaPublica> obtenerPorId(Long id) {
        return fuerzaPublicaRepository.findById(id);
    }

    public Optional<FuerzaPublica> obtenerPorIdentificacion(String identificacion) {
        return fuerzaPublicaRepository.findByIdentificacion(identificacion);
    }

    public List<FuerzaPublica> obtenerPorEstadoJudicial(String estadoJudicial) {
        return fuerzaPublicaRepository.findByEstadoJudicial(estadoJudicial);
    }

    public List<FuerzaPublica> buscarPorNombre(String nombre) {
        return fuerzaPublicaRepository.buscarPorNombre(nombre);
    }

    public List<FuerzaPublica> obtenerActivos() {
        return fuerzaPublicaRepository.findAll();
    }

    public List<FuerzaPublica> obtenerPorRango(String rango) {
        return fuerzaPublicaRepository.findByRango(rango);
    }

    public List<String> obtenerRangosDisponibles() {
        return List.of(
            "Agente", "Patrullero", "Cabo", "Sargento", "Subteniente", 
            "Teniente", "Capitán", "Mayor", "Coronel", "Inspector", 
            "Intendente", "Comisario", "Subcomisario", "Brigadier", "Comandante"
        );
    }
}