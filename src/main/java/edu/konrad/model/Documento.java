package edu.konrad.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "documentos")
public class Documento {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ciudadano_id", nullable = false)
    private Ciudadano ciudadano;
    
    @Column(name = "tipo_documento", nullable = false, length = 50)
    private String tipoDocumento;
    
    @Column(name = "numero_documento", length = 50)
    private String numeroDocumento;
    
    @Column(name = "codigo_barras", length = 100)
    private String codigoBarras;
    
    @Column(name = "fecha_escaneo")
    private LocalDateTime fechaEscaneo;
    
    @Column(name = "escaneado_por", length = 100)
    private String escaneadoPor;
    
    @PrePersist
    protected void onCreate() {
        if (fechaEscaneo == null) {
            fechaEscaneo = LocalDateTime.now();
        }
    }
    
    // Constructores
    public Documento() {}
    
    public Documento(String tipoDocumento, String numeroDocumento) {
        this.tipoDocumento = tipoDocumento;
        this.numeroDocumento = numeroDocumento;
    }
    
    // Getters y Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Ciudadano getCiudadano() {
        return ciudadano;
    }
    
    public void setCiudadano(Ciudadano ciudadano) {
        this.ciudadano = ciudadano;
    }
    
    public String getTipoDocumento() {
        return tipoDocumento;
    }
    
    public void setTipoDocumento(String tipoDocumento) {
        this.tipoDocumento = tipoDocumento;
    }
    
    public String getNumeroDocumento() {
        return numeroDocumento;
    }
    
    public void setNumeroDocumento(String numeroDocumento) {
        this.numeroDocumento = numeroDocumento;
    }
    
    public String getCodigoBarras() {
        return codigoBarras;
    }
    
    public void setCodigoBarras(String codigoBarras) {
        this.codigoBarras = codigoBarras;
    }
    
    public LocalDateTime getFechaEscaneo() {
        return fechaEscaneo;
    }
    
    public void setFechaEscaneo(LocalDateTime fechaEscaneo) {
        this.fechaEscaneo = fechaEscaneo;
    }
    
    public String getEscaneadoPor() {
        return escaneadoPor;
    }
    
    public void setEscaneadoPor(String escaneadoPor) {
        this.escaneadoPor = escaneadoPor;
    }
}
