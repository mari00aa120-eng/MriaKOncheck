package edu.konrad.repository;

import edu.konrad.model.FuerzaPublica; // ✅ Import correcto
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;

@Stateless
public class FuerzaPublicaRepository {

    @PersistenceContext(unitName = "koncheckPU")
    private EntityManager em;

    // Guardar o actualizar
    public FuerzaPublica save(FuerzaPublica fuerzaPublica) {
        if (fuerzaPublica.getId() == null) {
            em.persist(fuerzaPublica);
            return fuerzaPublica;
        } else {
            return em.merge(fuerzaPublica);
        }
    }

    // 🔹 Eliminar por ID
    public void delete(Long id) {
        FuerzaPublica fuerzaPublica = em.find(FuerzaPublica.class, id);
        if (fuerzaPublica != null) {
            em.remove(fuerzaPublica);
        }
    }

    // 🔹 Eliminar por objeto (para compatibilidad con el Service)
    public void delete(FuerzaPublica fuerzaPublica) {
        if (fuerzaPublica != null && fuerzaPublica.getId() != null) {
            FuerzaPublica entity = em.merge(fuerzaPublica); // Asegura que esté en el contexto
            em.remove(entity);
        }
    }

    // Buscar por ID
    public Optional<FuerzaPublica> findById(Long id) {
        return Optional.ofNullable(em.find(FuerzaPublica.class, id));
    }

    // Listar todos
    public List<FuerzaPublica> findAll() {
        return em.createNamedQuery("FuerzaPublica.findAll", FuerzaPublica.class)
                .getResultList();
    }

    // Buscar por identificación
    public Optional<FuerzaPublica> findByIdentificacion(String identificacion) {
        try {
            FuerzaPublica fuerzaPublica = em.createNamedQuery("FuerzaPublica.findByIdentificacion", FuerzaPublica.class)
                .setParameter("identificacion", identificacion)
                .getSingleResult();
            return Optional.ofNullable(fuerzaPublica);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    // Buscar por estado judicial
    public List<FuerzaPublica> findByEstadoJudicial(String estadoJudicial) {
        return em.createQuery(
            "SELECT f FROM FuerzaPublica f WHERE f.estadoJudicial = :estadoJudicial AND f.activo = true",
            FuerzaPublica.class)
            .setParameter("estadoJudicial", estadoJudicial)
            .getResultList();
    }

    // Buscar por estado activo
    public List<FuerzaPublica> findByActivo(Boolean activo) {
        return em.createQuery(
            "SELECT f FROM FuerzaPublica f WHERE f.activo = :activo",
            FuerzaPublica.class)
            .setParameter("activo", activo)
            .getResultList();
    }

    // Buscar por nombre o apellido
    public List<FuerzaPublica> buscarPorNombre(String nombre) {
        return em.createQuery(
            "SELECT f FROM FuerzaPublica f WHERE " +
            "(LOWER(f.nombres) LIKE LOWER(:nombre) OR LOWER(f.apellidos) LIKE LOWER(:nombre)) " +
            "AND f.activo = true",
            FuerzaPublica.class)
            .setParameter("nombre", "%" + nombre + "%")
            .getResultList();
    }

    // Buscar por rango
    public List<FuerzaPublica> findByRango(String rango) {
        return em.createQuery(
            "SELECT f FROM FuerzaPublica f WHERE f.rango = :rango AND f.activo = true",
            FuerzaPublica.class)
            .setParameter("rango", rango)
            .getResultList();
    }
}
