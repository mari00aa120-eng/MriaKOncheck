// Script para inicializar datos mock que coincidan con la base de datos
function initMockData() {
  // Usuarios de Fuerza Pública que coinciden EXACTAMENTE con la BD XAMPP
  const usuariosFuerzaPublica = [
    {
      id: 1,
      identificacion: '1234567890',
      nombres: 'Juan Carlos',
      apellidos: 'Pérez García',
      password: '123456',
      estadoJudicial: 'No Requerido',
      activo: true,
      fechaCreacion: new Date().toISOString()
    },
    {
      id: 2,
      identificacion: '9876543210',
      nombres: 'María Elena',
      apellidos: 'Rodríguez López',
      password: 'password123',
      estadoJudicial: 'No Requerido',
      activo: true,
      fechaCreacion: new Date().toISOString()
    },
    {
      id: 3,
      identificacion: '1122334455',
      nombres: 'Carlos Alberto',
      apellidos: 'Martínez Silva',
      password: 'admin2024',
      estadoJudicial: 'No Requerido',
      activo: true,
      fechaCreacion: new Date().toISOString()
    },
    {
      id: 4,
      identificacion: '5566778899',
      nombres: 'Ana Patricia',
      apellidos: 'González Ruiz',
      password: 'fuerza2024',
      estadoJudicial: 'No Requerido',
      activo: true,
      fechaCreacion: new Date().toISOString()
    },
    {
      id: 5,
      identificacion: '9988776655',
      nombres: 'Luis Fernando',
      apellidos: 'Castro Morales',
      password: 'policia123',
      estadoJudicial: 'No Requerido',
      activo: true,
      fechaCreacion: new Date().toISOString()
    }
  ];

  // Guardar en localStorage
  localStorage.setItem('usuariosFuerzaPublica', JSON.stringify(usuariosFuerzaPublica));
  
  console.log('✅ Datos mock inicializados correctamente');
  console.log('📋 Usuarios disponibles para pruebas:');
  usuariosFuerzaPublica.forEach(user => {
    console.log(`   ID: ${user.identificacion} | Password: ${user.password} | Nombre: ${user.nombres} ${user.apellidos}`);
  });
}

// Ejecutar automáticamente SIEMPRE para actualizar datos
localStorage.removeItem('usuariosFuerzaPublica');
initMockData();

// Función para limpiar datos mock
function clearMockData() {
  localStorage.removeItem('usuariosFuerzaPublica');
  localStorage.removeItem('fuerzaPublicas');
  localStorage.removeItem('authToken');
  localStorage.removeItem('userId');
  localStorage.removeItem('userType');
  localStorage.removeItem('userLoggedIn');
  console.log('🧹 Datos mock limpiados');
}

// Función para mostrar datos actuales
function showMockData() {
  const usuarios = JSON.parse(localStorage.getItem('usuariosFuerzaPublica') || '[]');
  console.log('📊 Usuarios mock actuales:', usuarios);
  return usuarios;
}