// Servicio de autenticación

// Declare variables before using them
const API_CONFIG = {
  ENDPOINTS: {
    AUTH: {
      LOGIN: "/login",
      REGISTER: "/register",
      VALIDATE: "/validate",
    },
  },
}

function apiRequest(url, options) {
  return fetch(url, options).then((response) => response.json())
}

function setAuthToken(token) {
  localStorage.setItem("authToken", token)
}

function removeAuthToken() {
  localStorage.removeItem("authToken")
}

async function login(correo, password) {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.AUTH.LOGIN, {
      method: "POST",
      body: JSON.stringify({ correo, password }),
    })

    // Guardar token y datos del usuario
    setAuthToken(response.token)
    localStorage.setItem("userId", response.userId)
    localStorage.setItem("userEmail", response.correo)
    localStorage.setItem("userNombres", response.nombres)

    return response
  } catch (error) {
    throw error
  }
}

async function register(datos) {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.AUTH.REGISTER, {
      method: "POST",
      body: JSON.stringify(datos),
    })

    return response
  } catch (error) {
    throw error
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
  window.location.href = "/LandingPage.html"
}
