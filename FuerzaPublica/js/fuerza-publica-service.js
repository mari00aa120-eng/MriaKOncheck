// Servicio de FuerzaPublica 

async function listarFuerzaPublicas(searchTerm = "", estado = "") {
  try {
    let endpoint = API_CONFIG.ENDPOINTS.FUERZAPUBLICAS.LIST
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
    console.error("Error al listar fuerza publicas:", error)
    throw error
  }
}

async function obtenerFuerzaPublica(id) {
  try {
    const response = await apiRequest(`${API_CONFIG.ENDPOINTS.FUERZAPUBLICAS.GET}/${id}`, {
      method: "GET",
    })

    return response.data
  } catch (error) {
    console.error("Error al obtener fuerza pública:", error)
    throw error
  }
}

async function crearFuerzaPublica(fuerzaPublica) {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.FUERZAPUBLICAS.CREATE, {
      method: "POST",
      body: JSON.stringify(fuerzaPublica),
    })

    return response.data
  } catch (error) {
    console.error("Error al crear fuerza pública:", error)
    throw error
  }
}

async function actualizarFuerzaPublica(id, fuerzaPublica) {
  try {
    const response = await apiRequest(`${API_CONFIG.ENDPOINTS.FUERZAPUBLICAS.UPDATE}/${id}`, {
      method: "PUT",
      body: JSON.stringify(fuerzaPublica),
    })

    return response.data
  } catch (error) {
    console.error("Error al actualizar fuerza pública:", error)
    throw error
  }
}

async function eliminarFuerzaPublica(id) {
  try {
    const response = await apiRequest(`${API_CONFIG.ENDPOINTS.FUERZAPUBLICAS.DELETE}/${id}`, {
      method: "DELETE",
    })

    return response
  } catch (error) {
    console.error("Error al eliminar fuerza pública:", error)
    throw error
  }
}

async function contarFuerzaPublica() {
  try {
    const response = await apiRequest(API_CONFIG.ENDPOINTS.FUERZAPUBLICAS.COUNT, {
      method: "GET",
    })

    return response.count
  } catch (error) {
    console.error("Error al contar fuerza pública:", error)
    return 0
  }
}
