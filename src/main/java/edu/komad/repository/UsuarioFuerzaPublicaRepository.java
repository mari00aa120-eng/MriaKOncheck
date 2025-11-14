package edu.komad.repository;

import edu.komad.model.UsuarioFuerzaPublica;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.Optional;

@Stateless
public class UsuarioFuerzaPublicaRepository {

    @PersistenceContext(unitName = "koncheckPU")
    private EntityManager em;

    public UsuarioFuerzaPublica save(UsuarioFuerzaPublica usuario) {
        if (usuario.getId() == null) {
            em.persist(usuario);
            return usuario;
        } else {
            return em.merge(usuario);
        }
    }

    public void delete(Long id) {
        UsuarioFuerzaPublica usuario = em.find(UsuarioFuerzaPublica.class, id);
        if (usuario != null) {
            em.remove(usuario);
        }
    }

    public Optional<UsuarioFuerzaPublica> findById(Long id) {
        return Optional.ofNullable(em.find(UsuarioFuerzaPublica.class, id));
    }

    public List<UsuarioFuerzaPublica> findAll() {
        return em.createNamedQuery("UsuarioFuerzaPublica.findAll", UsuarioFuerzaPublica.class)
                .getResultList();
    }

    public Optional<UsuarioFuerzaPublica> findByIdentificacion(String identificacion) {
        try {
            UsuarioFuerzaPublica usuario = em.createNamedQuery("UsuarioFuerzaPublica.findByIdentificacion", UsuarioFuerzaPublica.class)
                    .setParameter("identificacion", identificacion)
                    .getSingleResult();
            return Optional.ofNullable(usuario);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public boolean existsByIdentificacion(String identificacion) {
        Long count = em.createQuery("SELECT COUNT(u) FROM UsuarioFuerzaPublica u WHERE u.identificacion = :identificacion AND u.activo = true", Long.class)
                .setParameter("identificacion", identificacion)
                .getSingleResult();
        return count > 0;
    }

    public Optional<UsuarioFuerzaPublica> findByIdentificacionAndPassword(String identificacion, String password) {
        try {
            UsuarioFuerzaPublica usuario = em.createQuery("SELECT u FROM UsuarioFuerzaPublica u WHERE u.identificacion = :identificacion AND u.password = :password AND u.activo = true", UsuarioFuerzaPublica.class)
                    .setParameter("identificacion", identificacion)
                    .setParameter("password", password)
                    .getSingleResult();
            return Optional.ofNullable(usuario);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public List<UsuarioFuerzaPublica> findByRango(String rango) {
        return em.createQuery("SELECT u FROM UsuarioFuerzaPublica u WHERE u.rango = :rango AND u.activo = true", UsuarioFuerzaPublica.class)
                .setParameter("rango", rango)
                .getResultList();
    }
}