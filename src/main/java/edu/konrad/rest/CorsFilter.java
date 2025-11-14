package edu.konrad.rest;

import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerResponseContext;
import jakarta.ws.rs.container.ContainerResponseFilter;
import jakarta.ws.rs.ext.Provider;
import java.io.IOException;

@Provider
public class CorsFilter implements ContainerResponseFilter {
    
    @Override
    public void filter(ContainerRequestContext requestContext, 
                      ContainerResponseContext responseContext) throws IOException {
        
        String origin = requestContext.getHeaderString("Origin");
        
        // En producción, configurar lista específica de dominios
        if (isDevelopment()) {
            // Permitir cualquier origen en desarrollo
            if (origin != null) {
                responseContext.getHeaders().add("Access-Control-Allow-Origin", origin);
            } else {
                // Para archivos locales (file://) que no envían Origin
                responseContext.getHeaders().add("Access-Control-Allow-Origin", "*");
            }
        } else {
            // En producción, solo dominios específicos
            if (origin != null && isAllowedOrigin(origin)) {
                responseContext.getHeaders().add("Access-Control-Allow-Origin", origin);
            }
        }
        
        responseContext.getHeaders().add("Access-Control-Allow-Credentials", "true");
        responseContext.getHeaders().add("Access-Control-Allow-Headers", 
            "origin, content-type, accept, authorization, x-requested-with");
        responseContext.getHeaders().add("Access-Control-Allow-Methods", 
            "GET, POST, PUT, DELETE, OPTIONS, HEAD");
        responseContext.getHeaders().add("Access-Control-Max-Age", "3600");
        
        System.out.println("[v0] CORS Filter - Origin: " + origin + ", Method: " + requestContext.getMethod());
    }
    
    private boolean isDevelopment() {
        String env = System.getenv("ENVIRONMENT");
        return env == null || env.equals("development") || env.equals("dev");
    }
    
    private boolean isAllowedOrigin(String origin) {
        // Lista de dominios permitidos en producción
        return origin.equals("https://koncheck.com") ||
               origin.equals("https://www.koncheck.com") ||
               origin.equals("https://app.koncheck.com");
    }
}
