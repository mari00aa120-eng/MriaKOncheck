package edu.konrad.service;

import edu.konrad.model.Ciudadano;
import edu.konrad.repository.CiudadanoRepository;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.ws.rs.BadRequestException;
import jakarta.ws.rs.NotFoundException;
import java.util.List;
import java.util.Optional;

@Stateless
public class CiudadanoService {
    
    @Inject
    private CiudadanoRepository ciudadanoRepository;
    
    public Ciudadano crear(Ciudadano ciudadano) {
        // Validar identificación única
        if (ciudadanoRepository.existsByIdentificacion(ciudadano.getIdentificacion())) {
            throw new BadRequestException("Ya existe un ciudadano con esa identificación");
        }
        
        // Validar campos obligatorios
        if (ciudadano.getNombres() == null || ciudadano.getNombres().trim().isEmpty()) {
            throw new BadRequestException("El nombre es obligatorio");
        }
        
        if (ciudadano.getApellidos() == null || ciudadano.getApellidos().trim().isEmpty()) {
            throw new BadRequestException("Los apellidos son obligatorios");
        }
        
        if (ciudadano.getIdentificacion() == null || ciudadano.getIdentificacion().trim().isEmpty()) {
            throw new BadRequestException("La identificación es obligatoria");
        }
        
        // Establecer estado por defecto si no viene
        if (ciudadano.getEstadoJudicial() == null || ciudadano.getEstadoJudicial().trim().isEmpty()) {
            ciudadano.setEstadoJudicial("No Requerido");
        }
        
        return ciudadanoRepository.create(ciudadano);
    }
    
    public Ciudadano actualizar(Long id, Ciudadano ciudadanoActualizado) {
        // Buscar ciudadano existente
        Ciudadano existente = ciudadanoRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Ciudadano no encontrado"));
        
        // Validar identificación única (si cambió)
        if (!existente.getIdentificacion().equals(ciudadanoActualizado.getIdentificacion())) {
            if (ciudadanoRepository.existsByIdentificacion(ciudadanoActualizado.getIdentificacion())) {
                throw new BadRequestException("Ya existe un ciudadano con esa identificación");
            }
        }
        
        // Actualizar campos
        existente.setNombres(ciudadanoActualizado.getNombres());
        existente.setApellidos(ciudadanoActualizado.getApellidos());
        existente.setIdentificacion(ciudadanoActualizado.getIdentificacion());
        existente.setFechaNacimiento(ciudadanoActualizado.getFechaNacimiento());
        existente.setLugarNacimiento(ciudadanoActualizado.getLugarNacimiento());
        existente.setRh(ciudadanoActualizado.getRh());
        existente.setFechaExpedicion(ciudadanoActualizado.getFechaExpedicion());
        existente.setLugarExpedicion(ciudadanoActualizado.getLugarExpedicion());
        existente.setEstatura(ciudadanoActualizado.getEstatura());
        existente.setEstadoJudicial(ciudadanoActualizado.getEstadoJudicial());
        
        return ciudadanoRepository.update(existente);
    }
    
    public void eliminar(Long id) {
        if (!ciudadanoRepository.findById(id).isPresent()) {
            throw new NotFoundException("Ciudadano no encontrado");
        }
        ciudadanoRepository.delete(id);
    }
    
    public Optional<Ciudadano> findById(Long id) {
        return ciudadanoRepository.findById(id);
    }
    
    public Optional<Ciudadano> findByIdentificacion(String identificacion) {
        return ciudadanoRepository.findByIdentificacion(identificacion);
    }
    
    public List<Ciudadano> findAll() {
        return ciudadanoRepository.findAll();
    }
    
    public List<Ciudadano> findByEstadoJudicial(String estado) {
        return ciudadanoRepository.findByEstadoJudicial(estado);
    }
    
    public List<Ciudadano> buscar(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return findAll();
        }
        return ciudadanoRepository.searchByNombreOrApellido(searchTerm);
    }
    
    public long count() {
        return ciudadanoRepository.count();
    }
}
