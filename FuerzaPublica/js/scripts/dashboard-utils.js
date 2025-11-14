// Utilidades para el dashboard de Fuerza Pública

// Función para formatear identificación con puntos
function formatearIdentificacion(identificacion) {
  const str = String(identificacion).replace(/\D/g, '');
  if (!str) return identificacion;
  return str.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
}

// Función para validar sesión
function validarSesion() {
  const userLoggedIn = localStorage.getItem('userLoggedIn');
  const userType = localStorage.getItem('userType');
  
  if (!userLoggedIn || userType !== 'FUERZA_PUBLICA') {
    alert('Sesión expirada. Por favor, inicie sesión nuevamente.');
    window.location.href = '../IngresarFp/IngresarFp.html';
    return false;
  }
  return true;
}

// Función para cerrar sesión
function cerrarSesion() {
  localStorage.removeItem('userLoggedIn');
  localStorage.removeItem('userType');
  localStorage.removeItem('userId');
  window.location.href = '../../LandingPage.html';
}

// Función para mostrar notificaciones
function mostrarNotificacion(mensaje, tipo = 'info') {
  const notification = document.createElement('div');
  notification.className = `notification ${tipo}`;
  notification.textContent = mensaje;
  
  // Estilos para la notificación
  notification.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 15px 20px;
    border-radius: 8px;
    color: white;
    font-weight: 600;
    z-index: 10000;
    animation: slideIn 0.3s ease;
  `;
  
  // Colores según el tipo
  switch(tipo) {
    case 'success':
      notification.style.backgroundColor = '#159000';
      break;
    case 'error':
      notification.style.backgroundColor = '#d32f2f';
      break;
    case 'warning':
      notification.style.backgroundColor = '#ff9800';
      break;
    default:
      notification.style.backgroundColor = '#2196f3';
  }
  
  document.body.appendChild(notification);
  
  // Remover después de 3 segundos
  setTimeout(() => {
    notification.style.animation = 'slideOut 0.3s ease';
    setTimeout(() => {
      if (notification.parentNode) {
        notification.parentNode.removeChild(notification);
      }
    }, 300);
  }, 3000);
}

// Agregar estilos de animación
const style = document.createElement('style');
style.textContent = `
  @keyframes slideIn {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
  
  @keyframes slideOut {
    from { transform: translateX(0); opacity: 1; }
    to { transform: translateX(100%); opacity: 0; }
  }
`;
document.head.appendChild(style);

// Función para validar campos de solo letras
function validarSoloLetras(texto) {
  return /^[A-Za-zÁÉÍÓÚáéíóúñÑ\s]+$/.test(texto);
}

// Función para validar campos de solo números
function validarSoloNumeros(texto) {
  return /^[0-9]+$/.test(texto);
}

// Función para validar RH
function validarRH(rh) {
  const rhValidos = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  return rhValidos.includes(rh.toUpperCase());
}

// Función para calcular edad
function calcularEdad(fechaNacimiento) {
  const hoy = new Date();
  const nacimiento = new Date(fechaNacimiento);
  let edad = hoy.getFullYear() - nacimiento.getFullYear();
  const mes = hoy.getMonth() - nacimiento.getMonth();
  
  if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
    edad--;
  }
  
  return edad;
}

// Función para exportar datos a CSV
function exportarCSV(datos, nombreArchivo = 'fuerza_publica.csv') {
  const headers = ['Identificación', 'Nombres', 'Apellidos', 'Fecha Nacimiento', 'Lugar Nacimiento', 'RH', 'Fecha Expedición', 'Lugar Expedición', 'Estatura', 'Estado Judicial'];
  
  let csvContent = headers.join(',') + '\n';
  
  datos.forEach(registro => {
    const fila = [
      registro.identificacion,
      registro.nombres,
      registro.apellidos,
      registro.fechaNacimiento,
      registro.lugarNacimiento,
      registro.rh,
      registro.fechaExpedicion,
      registro.lugarExpedicion,
      registro.estatura,
      registro.estadoJudicial
    ];
    csvContent += fila.join(',') + '\n';
  });
  
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  
  if (link.download !== undefined) {
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', nombreArchivo);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}

// Función para filtrar datos
function filtrarDatos(datos, termino) {
  if (!termino) return datos;
  
  const terminoLower = termino.toLowerCase();
  return datos.filter(registro => 
    registro.identificacion.toLowerCase().includes(terminoLower) ||
    registro.nombres.toLowerCase().includes(terminoLower) ||
    registro.apellidos.toLowerCase().includes(terminoLower) ||
    registro.lugarNacimiento.toLowerCase().includes(terminoLower) ||
    registro.estadoJudicial.toLowerCase().includes(terminoLower)
  );
}

// Exportar funciones para uso global
window.DashboardUtils = {
  formatearIdentificacion,
  validarSesion,
  cerrarSesion,
  mostrarNotificacion,
  validarSoloLetras,
  validarSoloNumeros,
  validarRH,
  calcularEdad,
  exportarCSV,
  filtrarDatos
};