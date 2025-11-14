# Integración Frontend con Backend REST API

## Archivos JavaScript Creados

Se han creado 3 archivos JavaScript modulares para conectar el frontend HTML existente con el backend REST API:

### 1. `api-config.js` - Configuración Global
- Define la URL base de la API
- Endpoints organizados por módulos
- Funciones utilitarias para manejo de tokens
- Función `apiRequest()` para peticiones HTTP con manejo automático de errores
- Protección de rutas con `requireAuth()`

### 2. `auth-service.js` - Servicio de Autenticación
- `login(correo, password)` - Iniciar sesión
- `register(datos)` - Registrar nuevo administrador
- `validateToken()` - Validar token JWT
- `logout()` - Cerrar sesión

### 3. `ciudadano-service.js` - Servicio de Ciudadanos
- `listarCiudadanos(searchTerm, estado)` - Listar con filtros
- `obtenerCiudadano(id)` - Obtener por ID
- `crearCiudadano(ciudadano)` - Crear nuevo
- `actualizarCiudadano(id, ciudadano)` - Actualizar existente
- `eliminarCiudadano(id)` - Eliminar
- `contarCiudadanos()` - Contar total

---

## Cómo Integrar en los Archivos HTML

### Paso 1: Agregar los scripts en cada HTML

Agrega estas líneas en el `<head>` o antes del cierre de `</body>` en cada archivo HTML:

\`\`\`html
<!-- Scripts de integración API -->
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
<script src="../js/ciudadano-service.js"></script>
\`\`\`

**Nota:** Ajusta la ruta `../js/` según la ubicación del archivo HTML.

---

## Ejemplos de Integración por Página

### IngresarAd.html (Login)

\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>

<script>
async function handleLogin(event) {
    event.preventDefault();
    
    const correo = document.getElementById('correo').value;
    const password = document.getElementById('password').value;
    
    try {
        const response = await login(correo, password);
        
        // Mostrar mensaje de éxito
        alert('Inicio de sesión exitoso');
        
        // Redirigir al dashboard
        window.location.href = '../Dashboard/dashboard.html';
        
    } catch (error) {
        alert('Error: ' + error.message);
    }
}

// Agregar evento al formulario
document.getElementById('loginForm').addEventListener('submit', handleLogin);
</script>
\`\`\`

### RegistrarAd.html (Registro)

\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>

<script>
async function handleRegister(event) {
    event.preventDefault();
    
    const datos = {
        nombres: document.getElementById('nombres').value,
        apellidos: document.getElementById('apellidos').value,
        identificacion: document.getElementById('identificacion').value,
        correo: document.getElementById('correo').value,
        password: document.getElementById('password').value
    };
    
    // Validar que las contraseñas coincidan
    const confirmPassword = document.getElementById('confirmPassword').value;
    if (datos.password !== confirmPassword) {
        alert('Las contraseñas no coinciden');
        return;
    }
    
    try {
        const response = await register(datos);
        
        alert('Registro exitoso. Por favor inicia sesión.');
        window.location.href = '../IngresarAd/IngresarAd.html';
        
    } catch (error) {
        alert('Error: ' + error.message);
    }
}

document.getElementById('registerForm').addEventListener('submit', handleRegister);
</script>
\`\`\`

### dashboard.html (Listar Ciudadanos)

\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
<script src="../js/ciudadano-service.js"></script>

<script>
// Proteger la página
requireAuth();

async function cargarCiudadanos() {
    try {
        const ciudadanos = await listarCiudadanos();
        const tbody = document.querySelector('#tablaCiudadanos tbody');
        tbody.innerHTML = '';
        
        if (ciudadanos.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;">No hay ciudadanos registrados</td></tr>';
            return;
        }
        
        ciudadanos.forEach((c) => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${c.identificacion}</td>
                <td>${c.nombres}</td>
                <td>${c.apellidos}</td>
                <td>
                    <span class="estado-badge ${c.estadoJudicial === 'No Requerido' ? 'no-requerido' : 'requerido'}">
                        ${c.estadoJudicial === 'No Requerido' ? '🟢' : '🔴'} ${c.estadoJudicial}
                    </span>
                </td>
                <td class="acciones">
                    <button class="btn-accion btn-editar" onclick="editarCiudadano(${c.id})">✏️ Editar</button>
                    <button class="btn-accion btn-eliminar" onclick="confirmarEliminar(${c.id})">🗑️ Eliminar</button>
                    <button class="btn-accion btn-reporte" onclick="generarReporte(${c.id})">📄 Reporte</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
        
    } catch (error) {
        alert('Error al cargar ciudadanos: ' + error.message);
    }
}

function editarCiudadano(id) {
    localStorage.setItem('ciudadanoId', id);
    window.location.href = '../editarCiudadano/editarCiudadano.html';
}

function confirmarEliminar(id) {
    localStorage.setItem('ciudadanoId', id);
    window.location.href = 'PROMPTS/eliminarCiudadano.html';
}

function generarReporte(id) {
    localStorage.setItem('ciudadanoId', id);
    window.location.href = 'PROMPTS/generarReporte.html';
}

// Búsqueda en tiempo real
let searchTimeout;
document.getElementById('searchInput').addEventListener('input', function(e) {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(async () => {
        const searchTerm = e.target.value;
        try {
            const ciudadanos = await listarCiudadanos(searchTerm);
            // Actualizar tabla con resultados filtrados
            cargarCiudadanos();
        } catch (error) {
            console.error('Error en búsqueda:', error);
        }
    }, 500);
});

// Cargar al iniciar
cargarCiudadanos();
</script>
\`\`\`

### crearCiudadano.html (Crear)

\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
<script src="../js/ciudadano-service.js"></script>

<script>
requireAuth();

async function handleCrear(event) {
    event.preventDefault();
    
    const ciudadano = {
        nombres: document.getElementById('nombres').value,
        apellidos: document.getElementById('apellidos').value,
        identificacion: document.getElementById('identificacion').value,
        fechaNacimiento: document.getElementById('fechaNacimiento').value,
        lugarNacimiento: document.getElementById('lugarNacimiento').value,
        rh: document.getElementById('rh').value,
        fechaExpedicion: document.getElementById('fechaExpedicion').value,
        lugarExpedicion: document.getElementById('lugarExpedicion').value,
        estatura: document.getElementById('estatura').value
    };
    
    try {
        await crearCiudadano(ciudadano);
        
        // Redirigir a página de éxito
        window.location.href = '../Dashboard/PROMPTS/operacionExitosa.html';
        
    } catch (error) {
        alert('Error al crear ciudadano: ' + error.message);
    }
}

document.getElementById('formCrear').addEventListener('submit', handleCrear);
</script>
\`\`\`

### editarCiudadano.html (Editar)

\`\`\`html
<script src="../js/api-config.js"></script>
<script src="../js/auth-service.js"></script>
<script src="../js/ciudadano-service.js"></script>

<script>
requireAuth();

let ciudadanoId = null;

async function cargarDatos() {
    ciudadanoId = localStorage.getItem('ciudadanoId');
    
    if (!ciudadanoId) {
        alert('No se especificó el ciudadano a editar');
        window.location.href = '../Dashboard/dashboard.html';
        return;
    }
    
    try {
        const ciudadano = await obtenerCiudadano(ciudadanoId);
        
        // Llenar el formulario
        document.getElementById('nombres').value = ciudadano.nombres;
        document.getElementById('apellidos').value = ciudadano.apellidos;
        document.getElementById('identificacion').value = ciudadano.identificacion;
        document.getElementById('fechaNacimiento').value = ciudadano.fechaNacimiento;
        document.getElementById('lugarNacimiento').value = ciudadano.lugarNacimiento;
        document.getElementById('rh').value = ciudadano.rh;
        document.getElementById('fechaExpedicion').value = ciudadano.fechaExpedicion;
        document.getElementById('lugarExpedicion').value = ciudadano.lugarExpedicion;
        document.getElementById('estatura').value = ciudadano.estatura;
        
    } catch (error) {
        alert('Error al cargar datos: ' + error.message);
        window.location.href = '../Dashboard/dashboard.html';
    }
}

async function handleActualizar(event) {
    event.preventDefault();
    
    const ciudadano = {
        nombres: document.getElementById('nombres').value,
        apellidos: document.getElementById('apellidos').value,
        identificacion: document.getElementById('identificacion').value,
        fechaNacimiento: document.getElementById('fechaNacimiento').value,
        lugarNacimiento: document.getElementById('lugarNacimiento').value,
        rh: document.getElementById('rh').value,
        fechaExpedicion: document.getElementById('fechaExpedicion').value,
        lugarExpedicion: document.getElementById('lugarExpedicion').value,
        estatura: document.getElementById('estatura').value
    };
    
    try {
        await actualizarCiudadano(ciudadanoId, ciudadano);
        
        window.location.href = '../Dashboard/PROMPTS/operacionExitosa.html';
        
    } catch (error) {
        alert('Error al actualizar ciudadano: ' + error.message);
    }
}

// Cargar datos al iniciar
cargarDatos();

document.getElementById('formEditar').addEventListener('submit', handleActualizar);
</script>
\`\`\`

### eliminarCiudadano.html (Confirmar Eliminación)

\`\`\`html
<script src="../../js/api-config.js"></script>
<script src="../../js/auth-service.js"></script>
<script src="../../js/ciudadano-service.js"></script>

<script>
requireAuth();

async function confirmarEliminacion() {
    const ciudadanoId = localStorage.getItem('ciudadanoId');
    
    if (!ciudadanoId) {
        alert('No se especificó el ciudadano a eliminar');
        window.location.href = '../dashboard.html';
        return;
    }
    
    try {
        await eliminarCiudadano(ciudadanoId);
        
        localStorage.removeItem('ciudadanoId');
        window.location.href = 'operacionExitosa.html';
        
    } catch (error) {
        alert('Error al eliminar ciudadano: ' + error.message);
    }
}

function cancelar() {
    localStorage.removeItem('ciudadanoId');
    window.location.href = '../dashboard.html';
}
</script>
\`\`\`

---

## Configuración de la URL de la API

Para cambiar la URL de la API (por ejemplo, en producción), solo edita el archivo `api-config.js`:

\`\`\`javascript
const API_CONFIG = {
    BASE_URL: 'https://localhost:8181/koncheck/api',  // Cambiar aquí
    // ... resto del código
};
\`\`\`

**Nota:** Actualizado a HTTPS 8181

---

## Manejo de Errores

Todos los servicios incluyen manejo automático de errores:

- **401 Unauthorized**: Redirige automáticamente al login
- **400 Bad Request**: Muestra el mensaje de error del servidor
- **500 Internal Server Error**: Muestra mensaje genérico
- **Network Error**: Muestra error de conexión

---

## Almacenamiento Local

Los siguientes datos se guardan en `localStorage`:

- `authToken`: Token JWT de autenticación
- `userId`: ID del usuario autenticado
- `userEmail`: Correo del usuario
- `userNombres`: Nombres del usuario
- `ciudadanoId`: ID temporal para operaciones de edición/eliminación

---

## Seguridad

- Todos los endpoints (excepto `/auth/*`) requieren token JWT
- El token se envía automáticamente en el header `Authorization: Bearer <token>`
- Las páginas protegidas verifican autenticación con `requireAuth()`
- El token expira en 24 horas (configurable en el backend)

---

## Testing

Para probar la integración:

1. Iniciar el backend (GlassFish + MySQL)
2. Abrir `LandingPage.html` en el navegador
3. Registrar un nuevo administrador
4. Iniciar sesión
5. Probar CRUD de ciudadanos

---

## Troubleshooting

### Error: "CORS policy"
- Verificar que `CorsFilter.java` esté desplegado en el backend
- Verificar que la URL en `api-config.js` sea `https://localhost:8181/koncheck/api`
- Aceptar el certificado SSL autofirmado en el navegador

**Nota:** Agregada nota sobre certificado SSL

### Error: "Token no proporcionado"
- Hacer login nuevamente
- Verificar que el token se guarde en localStorage

### Error: "Failed to fetch"
- Verificar que el backend esté corriendo
- Verificar la URL de la API
- Abrir consola del navegador para más detalles

---

**Nota:** El frontend HTML NO se modifica. Solo se agregan los scripts JavaScript para conectar con la API REST.
