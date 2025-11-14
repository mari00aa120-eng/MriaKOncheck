# 🔒 CONFIGURACIÓN DE SEGURIDAD PARA PRODUCCIÓN

## ⚠️ IMPORTANTE: ANTES DE DESPLEGAR EN PRODUCCIÓN

Este documento contiene las configuraciones de seguridad OBLIGATORIAS antes de desplegar KonCheck en un entorno de producción.

---

## 1. 🔑 CLAVE SECRETA JWT

### Problema
La clave JWT actual es pública y está en el código fuente.

### Solución OBLIGATORIA

**Opción A: Variable de Entorno en GlassFish**

1. Crear variable de entorno en GlassFish:
\`\`\`bash
asadmin create-jvm-options "-DJWT_SECRET_KEY=TuClaveSecretaSuperSeguraDeAlMenos256BitsParaProduccion2025"
\`\`\`

2. Reiniciar GlassFish:
\`\`\`bash
asadmin restart-domain
\`\`\`

**Opción B: Archivo de Propiedades**

1. Crear archivo `/opt/koncheck/config.properties`:
```properties
jwt.secret.key=TuClaveSecretaSuperSeguraDeAlMenos256BitsParaProduccion2025
