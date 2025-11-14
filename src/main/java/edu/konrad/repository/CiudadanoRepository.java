package edu.konrad.repository;

import edu.konrad.model.Ciudadano;
import jakarta.ejb.Stateless;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

@Stateless
public class CiudadanoRepository extends GenericRepository<Ciudadano> {
    
    public CiudadanoRepository() {
        super(Ciudadano.class);
    }
    
    public Optional<Ciudadano> findByIdentificacion(String identificacion) {
        try {
            TypedQuery<Ciudadano> query = em.createQuery(
                "SELECT c FROM Ciudadano c WHERE c.identificacion = :identificacion", 
                Ciudadano.class
            );
            query.setParameter("identificacion", identificacion);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }
    
    public boolean existsByIdentificacion(String identificacion) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(c) FROM Ciudadano c WHERE c.identificacion = :identificacion", 
            Long.class
        );
        query.setParameter("identificacion", identificacion);
        return query.getSingleResult() > 0;
    }
    
    public List<Ciudadano> findByEstadoJudicial(String estadoJudicial) {
        TypedQuery<Ciudadano> query = em.createQuery(
            "SELECT c FROM Ciudadano c WHERE c.estadoJudicial = :estado ORDER BY c.apellidos, c.nombres", 
            Ciudadano.class
        );
        query.setParameter("estado", estadoJudicial);
        return query.getResultList();
    }
    
    public List<Ciudadano> searchByNombreOrApellido(String searchTerm) {
        TypedQuery<Ciudadano> query = em.createQuery(
            "SELECT c FROM Ciudadano c WHERE " +
            "LOWER(c.nombres) LIKE LOWER(:term) OR " +
            "LOWER(c.apellidos) LIKE LOWER(:term) OR " +
            "c.identificacion LIKE :term " +
            "ORDER BY c.apellidos, c.nombres", 
            Ciudadano.class
        );
        query.setParameter("term", "%" + searchTerm + "%");
        return query.getResultList();
    }
}
