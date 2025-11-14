package edu.konrad.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;
import java.util.Optional;

public abstract class GenericRepository<T> {
    
    @PersistenceContext(unitName = "koncheckPU")
    protected EntityManager em;
    
    private final Class<T> entityClass;
    
    public GenericRepository(Class<T> entityClass) {
        this.entityClass = entityClass;
    }
    
    public T create(T entity) {
        em.persist(entity);
        em.flush();
        return entity;
    }
    
    public T update(T entity) {
        T merged = em.merge(entity);
        em.flush();
        return merged;
    }
    
    public void delete(Long id) {
        T entity = em.find(entityClass, id);
        if (entity != null) {
            em.remove(entity);
            em.flush();
        }
    }
    
    public Optional<T> findById(Long id) {
        T entity = em.find(entityClass, id);
        return Optional.ofNullable(entity);
    }
    
    public List<T> findAll() {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<T> cq = cb.createQuery(entityClass);
        Root<T> root = cq.from(entityClass);
        cq.select(root);
        return em.createQuery(cq).getResultList();
    }
    
    public long count() {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Long> cq = cb.createQuery(Long.class);
        Root<T> root = cq.from(entityClass);
        cq.select(cb.count(root));
        return em.createQuery(cq).getSingleResult();
    }
    
    protected EntityManager getEntityManager() {
        return em;
    }
}
