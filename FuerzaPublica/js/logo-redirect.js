// Script para redirección de logos KonCheck en Fuerza Pública
document.addEventListener('DOMContentLoaded', () => {
  // Solo funcionar si estamos en la sección de Fuerza Pública
  const currentPath = window.location.pathname;

  if (!currentPath.includes('FuerzaPublica')) {
    return; // No hacer nada si no estamos en Fuerza Pública
  }

  // Función para obtener la ruta correcta al login según la ubicación actual
  function getLoginPath() {
    const fileName = currentPath.split('/').pop(); // Obtener el nombre del archivo actual
    const currentDir = currentPath.replace(fileName, ''); // Obtener el directorio actual

    console.log(`📍 Archivo actual: ${fileName}`);
    console.log(`📁 Directorio actual: ${currentDir}`);

    // Rutas específicas según la ubicación
    if (currentDir.includes('/Dashboard/ReestablecerContrasena/')) {
      return '../../IngresarFp/IngresarFp.html';
    } else if (currentDir.includes('/RegistrarFp/')) {
      return '../IngresarFp/IngresarFp.html';
    } else if (currentDir.includes('/IngresarFp/')) {
      return 'IngresarFp.html';
    } else {
      // Fallback genérico
      return '../IngresarFp/IngresarFp.html';
    }
  }

  const loginUrl = getLoginPath();
  console.log(`🔗 Ruta de login: ${loginUrl}`);

  // Buscar todos los posibles selectores de logos
  const logoSelectors = [
    '.brand',
    '.logo-container',
    '.logo-section'
  ];

  logoSelectors.forEach(selector => {
    const logoElements = document.querySelectorAll(selector);

    logoElements.forEach(logo => {
      // Solo agregar funcionalidad si no tiene ya un event listener
      if (!logo.hasAttribute('data-redirect-added')) {
        logo.style.cursor = 'pointer';
        logo.setAttribute('data-redirect-added', 'true');

        // Agregar efecto hover si no lo tiene
        if (!logo.style.transition) {
          logo.style.transition = 'transform 0.2s ease';
        }

        logo.addEventListener('mouseenter', () => {
          logo.style.transform = 'scale(1.05)';
        });

        logo.addEventListener('mouseleave', () => {
          logo.style.transform = 'scale(1)';
        });

        logo.addEventListener('click', (e) => {
          e.preventDefault();
          console.log(`🖱️ Click en logo, redirigiendo a: ${loginUrl}`);
          window.location.href = loginUrl;
        });
      }
    });
  });

  // También buscar imágenes de logos directamente
  const logoImages = document.querySelectorAll('img[src*="LOGOINGRESAR"], img[alt*="KonCheck"], img[alt*="logo"]');

  logoImages.forEach(img => {
    // Solo si la imagen no está dentro de un contenedor que ya tiene redirección
    const parentWithRedirect = img.closest('[data-redirect-added="true"]');

    if (!parentWithRedirect && !img.hasAttribute('data-redirect-added')) {
      img.style.cursor = 'pointer';
      img.setAttribute('data-redirect-added', 'true');
      img.style.transition = 'transform 0.2s ease';

      img.addEventListener('mouseenter', () => {
        img.style.transform = 'scale(1.05)';
      });

      img.addEventListener('mouseleave', () => {
        img.style.transform = 'scale(1)';
      });

      img.addEventListener('click', (e) => {
        e.preventDefault();
        console.log(`🖱️ Click en imagen logo, redirigiendo a: ${loginUrl}`);
        window.location.href = loginUrl;
      });
    }
  });

  console.log(`✅ Logo redirect configurado para Fuerza Pública`);
});