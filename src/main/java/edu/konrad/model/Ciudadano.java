package edu.konrad.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "ciudadanos")
@PrimaryKeyJoinColumn(name = "id")
public class Ciudadano extends Persona {
    
    @Column(name = "estado_judicial", length = 50)
    private String estadoJudicial = "No Requerido";
    
    @OneToMany(mappedBy = "ciudadano", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Documento> documentos = new ArrayList<>();
    
    // Constructores
    public Ciudadano() {
        super();
    }
    
    public Ciudadano(String nombres, String apellidos, String identificacion) {
        super(nombres, apellidos, identificacion);
        this.estadoJudicial = "No Requerido";
    }
    
    // Getters y Setters
    public String getEstadoJudicial() {
        return estadoJudicial;
    }
    
    public void setEstadoJudicial(String estadoJudicial) {
        this.estadoJudicial = estadoJudicial;
    }
    
    public List<Documento> getDocumentos() {
        return documentos;
    }
    
    public void setDocumentos(List<Documento> documentos) {
        this.documentos = documentos;
    }
    
    public void addDocumento(Documento documento) {
        documentos.add(documento);
        documento.setCiudadano(this);
    }
    
    public void removeDocumento(Documento documento) {
        documentos.remove(documento);
        documento.setCiudadano(null);
    }
}
