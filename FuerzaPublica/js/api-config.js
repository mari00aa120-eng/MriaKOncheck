// Configuración global de la API
const API_CONFIG = {
  BASE_URL: "http://localhost/KonCheckKKK/api",
  USE_MOCK_DATA: false, // ← CONECTADO A BASE DE DATOS REAL
  ENDPOINTS: {
    AUTH: {
      LOGIN: "/auth/fuerza-publica/login.php",
      REGISTER: "/auth/fuerza-publica/register.php",
      VALIDATE: "/auth/fuerza-publica/validate.php",
    },
    FUERZAPUBLICAS: {
      LIST: "/fuerzaPublicas",
      GET: "/fuerzaPublicas",
      CREATE: "/fuerzaPublicas",
      UPDATE: "/fuerzaPublicas",
      DELETE: "/fuerzaPublicas",
      SEARCH: "/fuerzaPublicas",
      COUNT: "/fuerzaPublicas/count",
    },
  },
}

// Utilidad para obtener el token del localStorage
function getAuthToken() {
  return localStorage.getItem("authToken")
}

// Utilidad para guardar el token
function setAuthToken(token) {
  localStorage.setItem("authToken", token)
}

// Utilidad para eliminar el token
function removeAuthToken() {
  localStorage.removeItem("authToken")
  localStorage.removeItem("userId")
  localStorage.removeItem("userEmail")
  localStorage.removeItem("userNombres")
}

// Utilidad para hacer peticiones HTTP con manejo de errores
async function apiRequest(endpoint, options = {}) {
  // Si está en modo mock, usar localStorage
  if (API_CONFIG.USE_MOCK_DATA) {
    return await mockApiRequest(endpoint, options);
  }

  const token = getAuthToken()

  const defaultHeaders = {
    "Content-Type": "application/json",
  }

  if (token && !endpoint.includes("/auth/")) {
    defaultHeaders["Authorization"] = `Bearer ${token}`
  }

  const config = {
    ...options,
    headers: {
      ...defaultHeaders,
      ...options.headers,
    },
  }

  try {
    const response = await fetch(`${API_CONFIG.BASE_URL}${endpoint}`, config)

    // Si el token expiró, redirigir al login
    if (response.status === 401) {
      removeAuthToken()
      window.location.href = "/FuerzaPublica/IngresarFp/IngresarFp.html"
      throw new Error("Sesión expirada")
    }

    const data = await response.json()

    if (!response.ok) {
      throw new Error(data.error || "Error en la petición")
    }

    return data
  } catch (error) {
    console.error("Error en API request:", error)
    throw error
  }
}

// Simulador de API usando localStorage
async function mockApiRequest(endpoint, options = {}) {
  // Simular delay de red
  await new Promise(resolve => setTimeout(resolve, 300));

  const method = options.method || 'GET';
  const body = options.body ? JSON.parse(options.body) : null;

  // Simular autenticación con BD mock
  if (endpoint.includes('/auth/fuerza-publica/login')) {
    const { identificacion, password } = body;
    
    // Obtener usuarios registrados
    const usuarios = JSON.parse(localStorage.getItem('usuariosFuerzaPublica') || '[]');
    const usuario = usuarios.find(u => u.identificacion === identificacion && u.password === password);
    
    if (usuario) {
      const token = 'mock-token-' + Date.now();
      setAuthToken(token);
      localStorage.setItem('userId', usuario.id);
      localStorage.setItem('userType', 'FUERZA_PUBLICA');
      
      return {
        success: true,
        token,
        userId: usuario.id,
        identificacion: usuario.identificacion,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
        tipo: 'FUERZA_PUBLICA'
      };
    } else {
      throw new Error('Credenciales inválidas. Usuario no registrado o contraseña incorrecta.');
    }
  }

  // Simular registro con BD mock
  if (endpoint.includes('/auth/fuerza-publica/register')) {
    const usuarios = JSON.parse(localStorage.getItem('usuariosFuerzaPublica') || '[]');
    
    // Verificar si ya existe
    const existe = usuarios.find(u => u.identificacion === body.identificacion);
    if (existe) {
      throw new Error('Ya existe un usuario con esta identificación');
    }
    
    // Crear nuevo usuario
    const nuevoUsuario = {
      id: Date.now(),
      ...body,
      fechaCreacion: new Date().toISOString(),
      activo: true
    };
    
    usuarios.push(nuevoUsuario);
    localStorage.setItem('usuariosFuerzaPublica', JSON.stringify(usuarios));
    
    return { 
      success: true, 
      message: 'Usuario registrado exitosamente',
      userId: nuevoUsuario.id,
      identificacion: nuevoUsuario.identificacion
    };
  }

  // Simular validación de usuario
  if (endpoint.includes('/auth/fuerza-publica/validate/')) {
    const identificacion = endpoint.split('/').pop();
    const usuarios = JSON.parse(localStorage.getItem('usuariosFuerzaPublica') || '[]');
    const existe = usuarios.some(u => u.identificacion === identificacion);
    
    return { exists: existe, identificacion };
  }

  // Simular validación de token
  if (endpoint.includes('/auth/validate')) {
    return { valid: !!getAuthToken() };
  }

  // Simular operaciones de fuerza pública
  if (endpoint.includes('/fuerzaPublicas')) {
    const fuerzaPublicas = JSON.parse(localStorage.getItem('fuerzaPublicas') || '[]');
    
    if (method === 'GET') {
      return { data: fuerzaPublicas };
    }
    
    if (method === 'POST') {
      const nuevoRegistro = { ...body, id: Date.now() };
      fuerzaPublicas.push(nuevoRegistro);
      localStorage.setItem('fuerzaPublicas', JSON.stringify(fuerzaPublicas));
      return { data: nuevoRegistro };
    }
    
    if (method === 'PUT') {
      const id = endpoint.split('/').pop();
      const index = fuerzaPublicas.findIndex(f => f.id == id);
      if (index !== -1) {
        fuerzaPublicas[index] = { ...fuerzaPublicas[index], ...body };
        localStorage.setItem('fuerzaPublicas', JSON.stringify(fuerzaPublicas));
        return { data: fuerzaPublicas[index] };
      }
    }
    
    if (method === 'DELETE') {
      const id = endpoint.split('/').pop();
      const index = fuerzaPublicas.findIndex(f => f.id == id);
      if (index !== -1) {
        fuerzaPublicas.splice(index, 1);
        localStorage.setItem('fuerzaPublicas', JSON.stringify(fuerzaPublicas));
        return { success: true };
      }
    }
  }

  return { data: [] };
}

// Verificar si el usuario está autenticado
function isAuthenticated() {
  if (API_CONFIG.USE_MOCK_DATA) {
    return localStorage.getItem('userLoggedIn') === 'true' || !!getAuthToken();
  }
  return !!getAuthToken()
}

// Proteger páginas que requieren autenticación
function requireAuth() {
  if (!isAuthenticated()) {
    window.location.href = "/FuerzaPublica/IngresarFp/IngresarFp.html"
  }
}
