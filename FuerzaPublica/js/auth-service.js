// Servicio de autenticación para Fuerza Pública

async function login(identificacion, password) {
  try {
    const response = await apiRequest("/auth/fuerza-publica/login.php", {
      method: "POST",
      body: JSON.stringify({ identificacion, password }),
    })

    // Guardar token y datos del usuario
    setAuthToken(response.token)
    localStorage.setItem("userId", response.userId)
    localStorage.setItem("userIdentificacion", response.identificacion)
    localStorage.setItem("userNombres", response.nombres)
    localStorage.setItem("userApellidos", response.apellidos)
    localStorage.setItem("userTipo", "FUERZA_PUBLICA")
    localStorage.setItem("userLoggedIn", "true")

    return response
  } catch (error) {
    throw error
  }
}

async function register(datos) {
  try {
    const response = await apiRequest("/auth/fuerza-publica/register", {
      method: "POST",
      body: JSON.stringify(datos),
    })

    return response
  } catch (error) {
    throw error
  }
}

// Función para validar si un usuario existe
async function validarUsuarioExiste(identificacion) {
  try {
    const response = await apiRequest(`/auth/fuerza-publica/validate/${identificacion}`, {
      method: "GET",
    })

    return response.exists
  } catch (error) {
    return false
  }
}

async function validateToken() {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.AUTH.VALIDATE, {
      method: "GET",
    })

    return response.valid
  } catch (error) {
    return false
  }
}

function logout() {
  removeAuthToken()
  localStorage.removeItem("userLoggedIn")
  localStorage.removeItem("userTipo")
  window.location.href = "/LandingPage.html"
}
