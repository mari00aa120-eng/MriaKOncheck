package edu.konrad.repository;

import edu.konrad.model.Persona;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
@Transactional
public class PersonaRepository {

    @PersistenceContext(unitName = "koncheckPU")
    private EntityManager em;

    public Persona create(Persona persona) {
        em.persist(persona);
        return persona;
    }

    public Persona findById(Long id) {
        return em.find(Persona.class, id);
    }

    public List<Persona> findAll() {
        return em.createQuery("SELECT p FROM Persona p", Persona.class)
                 .getResultList();
    }
}