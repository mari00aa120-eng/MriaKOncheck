package edu.konrad.rest;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;

@Path("/health")
public class HealthResource {
    
    @PersistenceContext(unitName = "koncheckPU")
    private EntityManager em;
    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response healthCheck() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            // Verificar conexión a BD
            em.createNativeQuery("SELECT 1").getSingleResult();
            
            health.put("status", "UP");
            health.put("database", "OK");
            health.put("timestamp", System.currentTimeMillis());
            
            return Response.ok(health).build();
            
        } catch (Exception e) {
            health.put("status", "DOWN");
            health.put("database", "ERROR");
            health.put("error", e.getMessage());
            health.put("timestamp", System.currentTimeMillis());
            
            return Response.status(503).entity(health).build();
        }
    }
}
