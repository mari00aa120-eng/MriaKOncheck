// Configuración global de la API
const API_CONFIG = {
  BASE_URL: "https://localhost:8181/koncheck/api",
  ENDPOINTS: {
    AUTH: {
      LOGIN: "/auth/login",
      REGISTER: "/auth/register",
      VALIDATE: "/auth/validate",
    },
    CIUDADANOS: {
      LIST: "/ciudadanos",
      GET: "/ciudadanos",
      CREATE: "/ciudadanos",
      UPDATE: "/ciudadanos",
      DELETE: "/ciudadanos",
      SEARCH: "/ciudadanos",
      COUNT: "/ciudadanos/count",
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
      window.location.href = "/Administrador/IngresarAd/IngresarAd.html"
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

// Verificar si el usuario está autenticado
function isAuthenticated() {
  return !!getAuthToken()
}

// Proteger páginas que requieren autenticación
function requireAuth() {
  if (!isAuthenticated()) {
    window.location.href = "/Administrador/IngresarAd/IngresarAd.html"
  }
}
