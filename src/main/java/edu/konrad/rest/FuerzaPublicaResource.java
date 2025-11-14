package edu.konrad.rest;

import edu.konrad.model.FuerzaPublica;
import edu.konrad.service.FuerzaPublicaService;

import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/fuerzaPublicas")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class FuerzaPublicaResource {

    @Inject
    private FuerzaPublicaService fuerzaPublicaService;

    @GET
    public Response obtenerTodos() {
        try {
            List<FuerzaPublica> fuerzas = fuerzaPublicaService.obtenerTodos();
            return Response.ok(fuerzas).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error al obtener los registros: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/{id}")
    public Response obtenerPorId(@PathParam("id") Long id) {
        try {
            return fuerzaPublicaService.obtenerPorId(id)
                    .map(fuerza -> Response.ok(fuerza).build())
                    .orElse(Response.status(Response.Status.NOT_FOUND)
                            .entity("Registro no encontrado").build());
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error al obtener el registro: " + e.getMessage())
                    .build();
        }
    }

  
    @POST
    public Response crear(FuerzaPublica fuerzaPublica) {
        FuerzaPublica creada = fuerzaPublicaService.crearFuerzaPublica(fuerzaPublica);
        return Response.status(Response.Status.CREATED).entity(creada).build();
    }

     
    @PUT
    @Path("/{id}")
    public Response actualizarFuerzaPublica(@PathParam("id") Long id, FuerzaPublica fuerzaPublica) {
        try {
            FuerzaPublica registroActualizado = fuerzaPublicaService.actualizarFuerzaPublica(id, fuerzaPublica);
            return Response.ok(registroActualizado).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error al actualizar el registro: " + e.getMessage())
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response eliminarFuerzaPublica(@PathParam("id") Long id) {
        try {
            fuerzaPublicaService.eliminarFuerzaPublica(id);
            return Response.noContent().build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error al eliminar el registro: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/identificacion/{identificacion}")
    public Response obtenerPorIdentificacion(@PathParam("identificacion") String identificacion) {
        try {
            return fuerzaPublicaService.obtenerPorIdentificacion(identificacion)
                    .map(fuerza -> Response.ok(fuerza).build())
                    .orElse(Response.status(Response.Status.NOT_FOUND)
                            .entity("Registro no encontrado").build());
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error al obtener el registro: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/estado/{estado}")
    public Response obtenerPorEstadoJudicial(@PathParam("estado") String estado) {
        try {
            List<FuerzaPublica> fuerzas = fuerzaPublicaService.obtenerPorEstadoJudicial(estado);
            return Response.ok(fuerzas).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error al obtener los registros: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/buscar/{nombre}")
    public Response buscarPorNombre(@PathParam("nombre") String nombre) {
        try {
            List<FuerzaPublica> fuerzas = fuerzaPublicaService.buscarPorNombre(nombre);
            return Response.ok(fuerzas).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error al buscar registros: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/activos")
    public Response obtenerActivos() {
        try {
            List<FuerzaPublica> fuerzas = fuerzaPublicaService.obtenerActivos();
            return Response.ok(fuerzas).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error al obtener registros activos: " + e.getMessage())
                    .build();
        }
    }
}