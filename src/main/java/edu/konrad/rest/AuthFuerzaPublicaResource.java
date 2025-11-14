package edu.konrad.rest;

import edu.komad.model.UsuarioFuerzaPublica;
import edu.konrad.service.AuthFuerzaPublicaService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Path("/auth/fuerza-publica")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthFuerzaPublicaResource {

    @Inject
    private AuthFuerzaPublicaService authService;

    @POST
    @Path("/register")
    public Response registrar(Map<String, Object> datos) {
        try {
            String identificacion = (String) datos.get("identificacion");
            String nombres = (String) datos.get("nombres");
            String apellidos = (String) datos.get("apellidos");
            String password = (String) datos.get("password");
            String rango = (String) datos.get("rango");
            
            // Datos opcionales del registro completo
            LocalDate fechaNacimiento = datos.get("fechaNacimiento") != null ? 
                LocalDate.parse((String) datos.get("fechaNacimiento")) : null;
            String lugarNacimiento = (String) datos.get("lugarNacimiento");
            String rh = (String) datos.get("rh");
            LocalDate fechaExpedicion = datos.get("fechaExpedicion") != null ? 
                LocalDate.parse((String) datos.get("fechaExpedicion")) : null;
            String lugarExpedicion = (String) datos.get("lugarExpedicion");
            Double estatura = datos.get("estatura") != null ? 
                Double.parseDouble(datos.get("estatura").toString()) : null;

            // Validaciones básicas
            if (identificacion == null || nombres == null || apellidos == null || password == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Identificación, nombres, apellidos y contraseña son obligatorios"))
                    .build();
            }

            UsuarioFuerzaPublica usuario = authService.registrarUsuario(
                identificacion, nombres, apellidos, password, rango,
                fechaNacimiento, lugarNacimiento, rh, 
                fechaExpedicion, lugarExpedicion, estatura
            );

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Usuario registrado exitosamente");
            response.put("userId", usuario.getId());
            response.put("identificacion", usuario.getIdentificacion());
            response.put("rango", usuario.getRango());

            return Response.status(Response.Status.CREATED).entity(response).build();

        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/login")
    public Response login(Map<String, String> credenciales) {
        try {
            String identificacion = credenciales.get("identificacion");
            String password = credenciales.get("password");

            if (identificacion == null || password == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Identificación y contraseña son obligatorios"))
                    .build();
            }

            Optional<UsuarioFuerzaPublica> usuario = authService.autenticarUsuario(identificacion, password);

            if (usuario.isPresent()) {
                UsuarioFuerzaPublica u = usuario.get();
                
                // Generar token simple (en producción usar JWT)
                String token = "fp-token-" + u.getId() + "-" + System.currentTimeMillis();

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("token", token);
                response.put("userId", u.getId());
                response.put("identificacion", u.getIdentificacion());
                response.put("nombres", u.getNombres());
                response.put("apellidos", u.getApellidos());
                response.put("rango", u.getRango());
                response.put("tipo", "FUERZA_PUBLICA");

                return Response.ok(response).build();
            } else {
                return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(Map.of("error", "Credenciales inválidas"))
                    .build();
            }

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error interno del servidor"))
                .build();
        }
    }

    @GET
    @Path("/validate/{identificacion}")
    public Response validarUsuario(@PathParam("identificacion") String identificacion) {
        try {
            boolean existe = authService.existeUsuario(identificacion);
            
            Map<String, Object> response = new HashMap<>();
            response.put("exists", existe);
            response.put("identificacion", identificacion);

            return Response.ok(response).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al validar usuario"))
                .build();
        }
    }

    @POST
    @Path("/change-password")
    public Response cambiarPassword(Map<String, String> datos) {
        try {
            String identificacion = datos.get("identificacion");
            String passwordAntiguo = datos.get("passwordAntiguo");
            String passwordNuevo = datos.get("passwordNuevo");

            if (identificacion == null || passwordAntiguo == null || passwordNuevo == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(Map.of("error", "Todos los campos son obligatorios"))
                    .build();
            }

            boolean cambiado = authService.cambiarPassword(identificacion, passwordAntiguo, passwordNuevo);

            if (cambiado) {
                return Response.ok(Map.of("success", true, "message", "Contraseña cambiada exitosamente")).build();
            } else {
                return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(Map.of("error", "Contraseña actual incorrecta"))
                    .build();
            }

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al cambiar contraseña"))
                .build();
        }
    }
}