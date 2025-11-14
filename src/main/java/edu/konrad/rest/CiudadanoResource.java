package edu.konrad.rest;

import edu.konrad.model.Ciudadano;
import edu.konrad.service.CiudadanoService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Path("/ciudadanos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CiudadanoResource {
    
    @Inject
    private CiudadanoService ciudadanoService;
    
    @GET
    public Response listarTodos(@QueryParam("search") String searchTerm,
                               @QueryParam("estado") String estado) {
        try {
            List<Ciudadano> ciudadanos;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ciudadanos = ciudadanoService.buscar(searchTerm);
            } else if (estado != null && !estado.trim().isEmpty()) {
                ciudadanos = ciudadanoService.findByEstadoJudicial(estado);
            } else {
                ciudadanos = ciudadanoService.findAll();
            }
            
            return Response.ok(Map.of(
                "success", true,
                "count", ciudadanos.size(),
                "data", ciudadanos
            )).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al obtener ciudadanos"))
                .build();
        }
    }
    
    @GET
    @Path("/{id}")
    public Response obtenerPorId(@PathParam("id") Long id) {
        try {
            Optional<Ciudadano> ciudadano = ciudadanoService.findById(id);
            
            if (ciudadano.isEmpty()) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Ciudadano no encontrado"))
                    .build();
            }
            
            return Response.ok(Map.of(
                "success", true,
                "data", ciudadano.get()
            )).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al obtener ciudadano"))
                .build();
        }
    }
    
    @GET
    @Path("/identificacion/{identificacion}")
    public Response obtenerPorIdentificacion(@PathParam("identificacion") String identificacion) {
        try {
            Optional<Ciudadano> ciudadano = ciudadanoService.findByIdentificacion(identificacion);
            
            if (ciudadano.isEmpty()) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(Map.of("error", "Ciudadano no encontrado"))
                    .build();
            }
            
            return Response.ok(Map.of(
                "success", true,
                "data", ciudadano.get()
            )).build();
            
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al obtener ciudadano"))
                .build();
        }
    }
    
    @POST
    public Response crear(Ciudadano ciudadano) {
        try {
            Ciudadano creado = ciudadanoService.crear(ciudadano);
            
            return Response.status(Response.Status.CREATED)
                .entity(Map.of(
                    "success", true,
                    "message", "Ciudadano creado exitosamente",
                    "data", creado
                ))
                .build();
                
        } catch (BadRequestException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al crear ciudadano"))
                .build();
        }
    }
    
    @PUT
    @Path("/{id}")
    public Response actualizar(@PathParam("id") Long id, Ciudadano ciudadano) {
        try {
            Ciudadano actualizado = ciudadanoService.actualizar(id, ciudadano);
            
            return Response.ok(Map.of(
                "success", true,
                "message", "Ciudadano actualizado exitosamente",
                "data", actualizado
            )).build();
            
        } catch (NotFoundException e) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("error", e.getMessage()))
                .build();
        } catch (BadRequestException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(Map.of("error", e.getMessage()))
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al actualizar ciudadano"))
                .build();
        }
    }
    
    @DELETE
    @Path("/{id}")
    public Response eliminar(@PathParam("id") Long id) {
        try {
            ciudadanoService.eliminar(id);
            
            return Response.ok(Map.of(
                "success", true,
                "message", "Ciudadano eliminado exitosamente"
            )).build();
            
        } catch (NotFoundException e) {
            return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("error", e.getMessage()))
                .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al eliminar ciudadano"))
                .build();
        }
    }
    
    @GET
    @Path("/count")
    public Response contar() {
        try {
            long count = ciudadanoService.count();
            return Response.ok(Map.of(
                "success", true,
                "count", count
            )).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(Map.of("error", "Error al contar ciudadanos"))
                .build();
        }
    }
}
