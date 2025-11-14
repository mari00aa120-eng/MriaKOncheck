package edu.konrad.rest;

import edu.konrad.service.AdministradorService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.StringWriter;
import java.io.PrintWriter;
import java.util.Map;

@Path("/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthResource {
    
    @Inject
    private AdministradorService administradorService;
    
    @POST
    @Path("/register")
    public Response registrar(Map<String, String> credentials) {
        try {
            System.out.println("[v0] ========== INICIO REGISTRO ==========");
            System.out.println("[v0] Recibiendo solicitud de registro");
            String correo = credentials.get("correo");
            String password = credentials.get("password");
            
            System.out.println("[v0] Correo recibido: " + correo);
            System.out.println("[v0] Password recibido: " + (password != null ? "***" : "null"));
            
            if (correo == null || password == null) {
                System.out.println("[v0] Error: Correo o contraseña nulos");
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Correo y contraseña son requeridos"))
                    .build();
            }
            
            System.out.println("[v0] Llamando a administradorService.registrar()");
            Map<String, Object> result = administradorService.registrar(correo, password);
            System.out.println("[v0] Registro exitoso para: " + correo);
            System.out.println("[v0] ========== FIN REGISTRO EXITOSO ==========");
            
            return Response.status(Response.Status.CREATED).entity(result).build();
            
        } catch (BadRequestException e) {
            System.err.println("[v0] ========== ERROR BAD REQUEST ==========");
            System.err.println("[v0] BadRequestException: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        } catch (Exception e) {
            System.err.println("[v0] ========== ERROR INTERNO ==========");
            System.err.println("[v0] Tipo de error: " + e.getClass().getName());
            System.err.println("[v0] Mensaje: " + e.getMessage());
            
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            System.err.println("[v0] Stack trace completo:");
            System.err.println(sw.toString());
            
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of(
                    "error", "Error interno del servidor",
                    "message", e.getMessage() != null ? e.getMessage() : "Error desconocido",
                    "type", e.getClass().getSimpleName()
                ))
                .build();
        }
    }
    
    @POST
    @Path("/login")
    public Response login(Map<String, String> credentials) {
        try {
            String correo = credentials.get("correo");
            String password = credentials.get("password");
            
            if (correo == null || password == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Correo y contraseña son requeridos"))
                    .build();
            }
            
            Map<String, Object> result = administradorService.login(correo, password);
            return Response.ok(result).build();
            
        } catch (NotAuthorizedException e) {
            return Response.status(Response.Status.UNAUTHORIZED)
                .entity(Map.of("error", e.getMessage()))
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error interno del servidor"))
                .build();
        }
    }
    
    @GET
    @Path("/validate")
    public Response validateToken(@HeaderParam("Authorization") String authHeader) {
        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(Map.of("valid", false, "error", "Token no proporcionado"))
                    .build();
            }
            
            String token = authHeader.substring(7);
            Long userId = edu.konrad.security.JwtUtil.getUserIdFromToken(token);
            String correo = edu.konrad.security.JwtUtil.getCorreoFromToken(token);
            
            return Response.ok(Map.of(
                "valid", true,
                "userId", userId,
                "correo", correo
            )).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.UNAUTHORIZED)
                .entity(Map.of("valid", false, "error", "Token inválido"))
                .build();
        }
    }
}
