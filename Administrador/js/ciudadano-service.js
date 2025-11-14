// Import API_CONFIG and apiRequest
const API_CONFIG = require("./path-to-api-config")
const apiRequest = require("./path-to-api-request")

// Servicio de ciudadanos

async function listarCiudadanos(searchTerm = "", estado = "") {
  try {
    let endpoint = API_CONFIG.ENDPOINTS.CIUDADANOS.LIST
    const params = new URLSearchParams()

    if (searchTerm) params.append("search", searchTerm)
    if (estado) params.append("estado", estado)

    if (params.toString()) {
      endpoint += `?${params.toString()}`
    }

    const response = await apiRequest(endpoint, {
      method: "GET",
    })

    return response.data || []
  } catch (error) {
    console.error("Error al listar ciudadanos:", error)
    throw error
  }
}

async function obtenerCiudadano(id) {
  try {
    const response = await apiRequest(`${API_CONFIG.ENDPOINTS.CIUDADANOS.GET}/${id}`, {
      method: "GET",
    })

    return response.data
  } catch (error) {
    console.error("Error al obtener ciudadano:", error)
    throw error
  }
}

async function crearCiudadano(ciudadano) {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.CIUDADANOS.CREATE, {
      method: "POST",
      body: JSON.stringify(ciudadano),
    })

    return response.data
  } catch (error) {
    console.error("Error al crear ciudadano:", error)
    throw error
  }
}

async function actualizarCiudadano(id, ciudadano) {
  try {
    const response = await apiRequest(`${API_CONFIG.ENDPOINTS.CIUDADANOS.UPDATE}/${id}`, {
      method: "PUT",
      body: JSON.stringify(ciudadano),
    })

    return response.data
  } catch (error) {
    console.error("Error al actualizar ciudadano:", error)
    throw error
  }
}

async function eliminarCiudadano(id) {
  try {
    const response = await apiRequest(`${API_CONFIG.ENDPOINTS.CIUDADANOS.DELETE}/${id}`, {
      method: "DELETE",
    })

    return response
  } catch (error) {
    console.error("Error al eliminar ciudadano:", error)
    throw error
  }
}

async function contarCiudadanos() {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.CIUDADANOS.COUNT, {
      method: "GET",
    })

    return response.count
  } catch (error) {
    console.error("Error al contar ciudadanos:", error)
    return 0
  }
}
