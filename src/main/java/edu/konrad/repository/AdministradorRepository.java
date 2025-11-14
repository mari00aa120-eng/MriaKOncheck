package edu.konrad.repository;

import edu.konrad.model.Administrador;
import jakarta.ejb.Stateless;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.Optional;

@Stateless
public class AdministradorRepository extends GenericRepository<Administrador> {
    
    public AdministradorRepository() {
        super(Administrador.class);
    }
    
    public Optional<Administrador> findByCorreo(String correo) {
        try {
            TypedQuery<Administrador> query = em.createQuery(
                "SELECT a FROM Administrador a WHERE a.correo = :correo", 
                Administrador.class
            );
            query.setParameter("correo", correo);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }
    
    public boolean existsByCorreo(String correo) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(a) FROM Administrador a WHERE a.correo = :correo", 
            Long.class
        );
        query.setParameter("correo", correo);
        return query.getSingleResult() > 0;
    }
    
    public Optional<Administrador> findByIdentificacion(String identificacion) {
        try {
            TypedQuery<Administrador> query = em.createQuery(
                "SELECT a FROM Administrador a WHERE a.identificacion = :identificacion", 
                Administrador.class
            );
            query.setParameter("identificacion", identificacion);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }
}
