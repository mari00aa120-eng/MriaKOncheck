package edu.komad.dto;

import java.time.LocalDate;

public class FuerzaPublicaRequest {
    private String identificacion;
    private String nombres;
    private String apellidos;
    private LocalDate fechaNacimiento;
    private String lugarNacimiento;
    private String rh;
    private LocalDate fechaExpedicion;
    private String lugarExpedicion;
    private Double estatura;
    private String estadoJudicial;

    // Constructores
    public FuerzaPublicaRequest() {}

    // Getters y Setters
    public String getIdentificacion() { return identificacion; }
    public void setIdentificacion(String identificacion) { this.identificacion = identificacion; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public LocalDate getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(LocalDate fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public String getLugarNacimiento() { return lugarNacimiento; }
    public void setLugarNacimiento(String lugarNacimiento) { this.lugarNacimiento = lugarNacimiento; }

    public String getRh() { return rh; }
    public void setRh(String rh) { this.rh = rh; }

    public LocalDate getFechaExpedicion() { return fechaExpedicion; }
    public void setFechaExpedicion(LocalDate fechaExpedicion) { this.fechaExpedicion = fechaExpedicion; }

    public String getLugarExpedicion() { return lugarExpedicion; }
    public void setLugarExpedicion(String lugarExpedicion) { this.lugarExpedicion = lugarExpedicion; }

    public Double getEstatura() { return estatura; }
    public void setEstatura(Double estatura) { this.estatura = estatura; }

    public String getEstadoJudicial() { return estadoJudicial; }
    public void setEstadoJudicial(String estadoJudicial) { this.estadoJudicial = estadoJudicial; }
}