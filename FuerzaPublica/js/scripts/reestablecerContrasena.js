document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("reset-form") || document.getElementById("resetForm");
  const cedula = document.getElementById("cedula");
  const password = document.getElementById("new-password") || document.getElementById("password");
  const confirmPassword = document.getElementById("confirm-password") || document.getElementById("confirmPassword");
  const cedulaError = document.getElementById("cedula-error") || document.getElementById("cedulaError");
  const passwordError = document.getElementById("password-error") || document.getElementById("passwordError");
  const confirmError = document.getElementById("confirm-error") || document.getElementById("confirmError");
  const modal = document.getElementById("successModal");
  const closeBtn = document.querySelector(".close");

  const API_BASE = 'http://localhost:3001';

  // Validación de cédula en tiempo real
  if (cedula) {
    cedula.addEventListener("input", (e) => {
      const value = e.target.value;
      const soloNumeros = /^[0-9]*$/;
      
      if (!soloNumeros.test(value)) {
        e.target.value = value.replace(/[^0-9]/g, '');
      }
      
      // Limitar a máximo 10 caracteres
      if (value.length > 10) {
        e.target.value = value.slice(0, 10);
      }
      
      if (cedulaError) {
        if (value.length !== 10) {
          cedulaError.textContent = "La cédula debe tener exactamente 10 dígitos";
          cedulaError.style.display = "block";
          cedulaError.title = "La cédula debe tener exactamente 10 dígitos";
        } else {
          cedulaError.textContent = "";
          cedulaError.style.display = "none";
        }
      }
    });
  }

  // Validación de contraseña en tiempo real
  if (password && passwordError) {
    password.addEventListener("input", (e) => {
      const value = e.target.value;
      
      if (value.length > 10) {
        passwordError.textContent = "La contraseña no puede tener más de 10 caracteres";
        passwordError.style.display = "block";
        passwordError.title = "La contraseña no puede tener más de 10 caracteres";
      } else {
        passwordError.textContent = "";
        passwordError.style.display = "none";
      }
    });
  }

  // Validación de confirmación de contraseña en tiempo real
  if (confirmPassword && confirmError && password) {
    confirmPassword.addEventListener("input", (e) => {
      const value = e.target.value;
      const passwordValue = password.value;
      
      if (value !== passwordValue) {
        confirmError.textContent = "Las contraseñas no coinciden";
        confirmError.style.display = "block";
        confirmError.title = "Las contraseñas no coinciden";
      } else {
        confirmError.textContent = "";
        confirmError.style.display = "none";
      }
    });
  }

  // Función para mostrar overlay con iframe
  let overlayEl = null;
  function mostrarOverlayIframe(path) {
    if (overlayEl) return;

    overlayEl = document.createElement('div');
    overlayEl.className = 'kc-overlay';
    overlayEl.style.cssText = `
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.45);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 9999;
    `;
    
    const iframe = document.createElement('iframe');
    iframe.className = 'kc-iframe';
    iframe.src = path;
    iframe.title = 'Operación Exitosa';
    iframe.style.cssText = `
      width: 760px;
      max-width: calc(100% - 40px);
      height: 460px;
      border: none;
      border-radius: 12px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.4);
      background: white;
    `;
    
    overlayEl.appendChild(iframe);
    document.body.appendChild(overlayEl);

    // Cerrar si hace click fuera del iframe
    overlayEl.addEventListener('click', (ev) => {
      if (ev.target === overlayEl) {
        cerrarOverlay();
      }
    });

    // Cerrar con Esc
    const escHandler = (ev) => {
      if (ev.key === 'Escape') cerrarOverlay();
    };
    document.addEventListener('keydown', escHandler);

    // Limpieza al cerrar
    overlayEl._cleanup = () => {
      document.removeEventListener('keydown', escHandler);
    };
  }

  function cerrarOverlay() {
    if (!overlayEl) return;
    if (overlayEl._cleanup) overlayEl._cleanup();
    overlayEl.remove();
    overlayEl = null;
  }

  // Envío del formulario
  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const cedulaValue = cedula ? cedula.value.trim() : "";
    const passwordValue = password.value.trim();
    const confirmValue = confirmPassword.value.trim();

    // Limpiar errores
    if (cedulaError) {
      cedulaError.textContent = "";
      cedulaError.style.display = "none";
    }
    if (passwordError) {
      passwordError.textContent = "";
      passwordError.style.display = "none";
    }
    if (confirmError) {
      confirmError.textContent = "";
      confirmError.style.display = "none";
    }

    // Validar cédula (exactamente 10 dígitos)
    if (cedula && cedulaValue.length !== 10) {
      alert('❌ La cédula debe tener exactamente 10 dígitos');
      return;
    }

    // Validar contraseña (máximo 10 caracteres para este sistema)
    if (passwordValue.length === 0 || passwordValue.length > 10) {
      alert('❌ La contraseña debe tener entre 1 y 10 caracteres');
      return;
    }

    if (passwordValue !== confirmValue) {
      alert('❌ Las contraseñas no coinciden');
      return;
    }

    try {
      // Verificar que la cédula esté registrada
      const validateResponse = await fetch(`${API_BASE}/api/auth/fuerza-publica/validate/${cedulaValue}`);
      const validateData = await validateResponse.json();

      if (!validateData.exists) {
        alert('❌ El número de cédula no está registrado en el sistema');
        return;
      }

      // Cambiar la contraseña en la base de datos
      const changeResponse = await fetch(`${API_BASE}/api/auth/fuerza-publica/change-password`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          identificacion: cedulaValue,
          newPassword: passwordValue
        })
      });

      const changeData = await changeResponse.json();

      if (!changeData.success) {
        alert(`❌ Error: ${changeData.error}`);
        return;
      }

      alert('✅ Contraseña actualizada exitosamente');
      
      // Mostrar prompt de operación exitosa si existe
      const promptPath = '../PROMPTS/operacionExitosa.html';
      if (document.querySelector('link[href*="operacionExitosa"]') || window.location.href.includes('Dashboard')) {
        mostrarOverlayIframe(promptPath);
        
        // Redirigir después de 3 segundos
        setTimeout(() => {
          cerrarOverlay();
          window.location.href = "../../IngresarFp/IngresarFp.html";
        }, 3000);
      } else {
        // Si no hay prompt, redirigir directamente
        setTimeout(() => {
          window.location.href = "../../IngresarFp/IngresarFp.html";
        }, 1500);
      }

    } catch (error) {
      alert('❌ Error al verificar la cédula. Intente nuevamente.');
      console.error('Error:', error);
    }
  });

  // Cerrar modal si existe
  if (closeBtn && modal) {
    closeBtn.addEventListener("click", () => {
      modal.classList.add("hidden");
      form.reset();
    });
  }

  // Redirección del logo al login si existe
  const brand = document.querySelector('.brand');
  if (brand) {
    brand.addEventListener('click', () => {
      window.location.href = "../../IngresarFp/IngresarFp.html";
    });
  }
});