package edu.konrad.security;

import jakarta.annotation.Priority;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;
import java.io.IOException;
import java.util.logging.Logger;

@Provider
@Priority(Priorities.AUTHENTICATION)
public class AuthFilter implements ContainerRequestFilter {
    
    private static final Logger LOGGER = Logger.getLogger(AuthFilter.class.getName());
    
    @Override
    public void filter(ContainerRequestContext requestContext) throws IOException {
        String path = requestContext.getUriInfo().getPath();
        String method = requestContext.getMethod();
        
        if ("OPTIONS".equals(method)) {
            return;
        }
        
        // Permitir acceso sin autenticación a rutas públicas
        if (path.startsWith("auth/") || path.equals("auth") || path.startsWith("health")) {
            return;
        }
        
        // Obtener token del header Authorization
        String authHeader = requestContext.getHeaderString("Authorization");
        
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            LOGGER.warning("Intento de acceso sin token a: " + path);
            requestContext.abortWith(
                Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"Token no proporcionado\"}")
                    .build()
            );
            return;
        }
        
        String token = authHeader.substring(7); // Remover "Bearer "
        
        try {
            // Validar token
            JwtUtil.validateToken(token);
            
            // Verificar si está expirado
            if (JwtUtil.isTokenExpired(token)) {
                LOGGER.warning("Token expirado para acceso a: " + path);
                requestContext.abortWith(
                    Response.status(Response.Status.UNAUTHORIZED)
                        .entity("{\"error\": \"Token expirado\"}")
                        .build()
                );
                return;
            }
            
            Long userId = JwtUtil.getUserIdFromToken(token);
            String correo = JwtUtil.getCorreoFromToken(token);
            requestContext.setProperty("userId", userId);
            requestContext.setProperty("userEmail", correo);
            
            LOGGER.fine("Acceso autorizado para usuario: " + correo + " a: " + path);
            
        } catch (Exception e) {
            LOGGER.warning("Token inválido para acceso a: " + path + " - Error: " + e.getMessage());
            requestContext.abortWith(
                Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"Token inválido\"}")
                    .build()
            );
        }
    }
}
