package edu.konrad;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.glassfish.jersey.servlet.ServletContainer;
import org.glassfish.jersey.server.ResourceConfig;

public class Main {
    public static void main(String[] args) throws Exception {
        // Configurar Jersey
        ResourceConfig config = new ResourceConfig();
        config.packages("edu.konrad.rest");
        
        // Crear servidor Jetty
        Server server = new Server(3001);
        
        // Configurar contexto
        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath("/");
        server.setHandler(context);
        
        // Agregar servlet de Jersey
        ServletHolder jerseyServlet = context.addServlet(ServletContainer.class, "/api/*");
        jerseyServlet.setInitOrder(0);
        jerseyServlet.setInitParameter("jersey.config.server.provider.packages", "edu.konrad.rest");
        
        // Configurar CORS
        context.addFilter(CorsFilter.class, "/*", null);
        
        try {
            server.start();
            System.out.println("🚀 Servidor iniciado en http://localhost:3001");
            System.out.println("📊 API disponible en http://localhost:3001/api/");
            server.join();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}