package edu.konrad.model;
import edu.konrad.model.FuerzaPublica; // ✅ <-- AGREGA ESTA LÍNEA

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "fuerza_publica")
@NamedQuery(name = "FuerzaPublica.findAll", query = "SELECT f FROM FuerzaPublica f")
@NamedQuery(name = "FuerzaPublica.findByIdentificacion", 
            query = "SELECT f FROM FuerzaPublica f WHERE f.identificacion = :identificacion")
public class FuerzaPublica {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "identificacion", nullable = false, unique = true, length = 20)
    private String identificacion;

    @Column(name = "nombres", nullable = false, length = 100)
    private String nombres;

    @Column(name = "apellidos", nullable = false, length = 100)
    private String apellidos;

    @Column(name = "fecha_nacimiento", nullable = false)
    private LocalDate fechaNacimiento;

    @Column(name = "lugar_nacimiento", nullable = false, length = 100)
    private String lugarNacimiento;

    @Column(name = "rh", nullable = false, length = 5)
    private String rh;

    @Column(name = "fecha_expedicion", nullable = false)
    private LocalDate fechaExpedicion;

    @Column(name = "lugar_expedicion", nullable = false, length = 100)
    private String lugarExpedicion;

    @Column(name = "estatura", nullable = false)
    private Double estatura;

    @Column(name = "estado_judicial", nullable = false, length = 20)
    private String estadoJudicial;

    @Column(name = "rango", nullable = false, length = 50)
    private String rango;

    // Constructores
    public FuerzaPublica() {
    }

    public FuerzaPublica(String identificacion, String nombres, String apellidos, 
                        LocalDate fechaNacimiento, String lugarNacimiento, String rh,
                        LocalDate fechaExpedicion, String lugarExpedicion, Double estatura, 
                        String estadoJudicial, String rango) {
        this.identificacion = identificacion;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.fechaNacimiento = fechaNacimiento;
        this.lugarNacimiento = lugarNacimiento;
        this.rh = rh;
        this.fechaExpedicion = fechaExpedicion;
        this.lugarExpedicion = lugarExpedicion;
        this.estatura = estatura;
        this.estadoJudicial = estadoJudicial;
        this.rango = rango;
    }

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

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

    public String getRango() { return rango; }
    public void setRango(String rango) { this.rango = rango; }

    public String getNombreCompleto() {
        return nombres + " " + apellidos;
    }

    public String getNombreCompletoConRango() {
        return rango + " " + nombres + " " + apellidos;
    }
}