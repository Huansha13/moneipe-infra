<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Moneipe</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc; /* Color de fondo general neutro estilo Material */
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4 text-[#0f172a] antialiased">
  
  <!-- Tarjeta principal estilo Angular Material Card -->
  <div class="w-full max-w-[420px] bg-white border border-slate-200/80 rounded-2xl shadow-[0_4px_20px_rgba(15,23,42,0.06)] p-8 sm:p-10">
    
    <!-- Header / Logo -->
    <div class="flex flex-col items-center justify-center mb-8">
        <div class="flex items-center mb-4">
            <!-- Ícono con tu color primario -->
            <svg class="mr-2.5" xmlns="http://www.w3.org/2000/svg" height="36px" viewBox="0 -960 960 960" width="36px" fill="#0f172a">
              <path d="M240-160q-66 0-113-47T80-320v-320q0-66 47-113t113-47h480q66 0 113 47t47 113v320q0 66-47 113t-113 47H240Zm0-480h480q22 0 42 5t38 16v-21q0-33-23.5-56.5T720-720H240q-33 0-56.5 23.5T160-640v21q18-11 38-16t42-5Zm-74 130 445 108q9 2 18 0t17-8l139-116q-11-15-28-24.5t-37-9.5H240q-26 0-45.5 13.5T166-510Z"/>
            </svg>
            <span class="text-[28px] font-bold text-[#0f172a] tracking-tight">Moneipe</span>
        </div>
    </div>

    <!-- Formulario -->
    <form id="login-form" action="${url.loginAction}" method="post" class="space-y-5">
      
      <!-- Input de Usuario (Estilo Material Outlined Input) -->
      <div>
        <label for="username" class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5">Usuario</label>
        <input 
          type="text" 
          id="username"
          name="username"
          value="${(login.username!'')}"
          class="w-full bg-white border border-slate-300 rounded-lg px-4 py-3 text-slate-900 placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#0f172a] focus:ring-2 focus:ring-[#0f172a]/20 transition-all text-sm"
          autocomplete="username"
          required>
      </div>

      <!-- Input de Contraseña -->
      <div>
        <label for="password" class="block text-xs font-semibold uppercase tracking-wider text-slate-600 mb-1.5">Contraseña</label>
        <input 
          type="password" 
          id="password"
          name="password"
          class="w-full bg-white border border-slate-300 rounded-lg px-4 py-3 text-slate-900 placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#0f172a] focus:ring-2 focus:ring-[#0f172a]/20 transition-all text-sm"
          autocomplete="current-password"
          required>
      </div>

      <!-- Enlaces y Botón -->
      <div class="flex items-center justify-between pt-2">
        <a href="${url.loginResetCredentialsUrl!''}" onclick="guardarOrigen(); return true;" class="text-xs text-[#0f172a] hover:underline font-semibold transition-colors">
            ¿Olvidaste tu contraseña?
        </a>
        
        <input type="hidden" name="credentialId" <#if auth?? && auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
        
        <!-- Botón principal (Estilo Material Flat/Elevated Button con bordes redondeados suaves) -->
        <button 
          type="submit" 
          id="login-btn"
          name="login"
          class="bg-[#0f172a] hover:bg-slate-800 text-white px-6 py-2.5 rounded-lg text-sm font-semibold transition-all duration-200 shadow-sm hover:shadow flex items-center justify-center min-w-[110px]">
          <span id="btn-text">Iniciar sesión</span>
        </button>
      </div>

      <!-- Alertas de error -->
      <#if message?has_content && (message.type != 'warning')>
          <div role="alert" class="mt-4 relative flex w-full p-3 text-sm text-white bg-slate-800 rounded-lg shadow-sm">
              <p>${kcSanitize(message.summary)?no_esc}</p>
          </div>
      </#if>
    </form>
  </div>

  <!-- Script para guardar origen y activar loader -->
  <script>
    // Extraer el origen desde los parámetros de la URL
    // redirect_uri contiene la URL a donde debe regresar: http://localhost:4200
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        let origen = null;
        
        // Obtener redirect_uri que contiene el origen
        const redirectUri = urlParams.get('redirect_uri');
        console.log("redirect_uri:", redirectUri);
        
        if (redirectUri) {
            try {
                const url = new URL(redirectUri);
                origen = url.origin;
                console.log("Origen extraído de redirect_uri:", origen);
                sessionStorage.setItem('moneipeLoginOrigen', origen);
            } catch (e) {
                console.error("Error al procesar redirect_uri:", e);
                sessionStorage.setItem('moneipeLoginOrigen', 'https://moneipe.vercel.app/*');
            }
        } else {
            console.log("No hay redirect_uri, usando valor por defecto");
            sessionStorage.setItem('moneipeLoginOrigen', 'https://moneipe.vercel.app/*');
        }
    });
    
    function guardarOrigen() {
        return true;
    }
  </script>
  
  <script>
    const loginForm = document.getElementById('login-form');
    const loginBtn = document.getElementById('login-btn');
    const btnText = document.getElementById('btn-text');

    loginForm.addEventListener('submit', function(e) {
        loginBtn.disabled = true;
        loginBtn.classList.add('opacity-75', 'cursor-not-allowed');
        
        btnText.innerHTML = `
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white inline-block" xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#ffffff">
                <path d="M325-111.5q-73-31.5-127.5-86t-86-127.5Q80-398 80-480.5t31.5-155q31.5-72.5 86-127t127.5-86Q398-880 480-880q17 0 28.5 11.5T520-840q0 17-11.5 28.5T480-800q-133 0-226.5 93.5T160-480q0 133 93.5 226.5T480-160q133 0 226.5-93.5T800-480q0-17 11.5-28.5T840-520q17 0 28.5 11.5T880-480q0 82-31.5 155t-86 127.5q-54.5 54.5-127 86T480.5-80Q398-80 325-111.5Z"/>
            </svg>
        `;
    });
  </script>
</body>
</html>