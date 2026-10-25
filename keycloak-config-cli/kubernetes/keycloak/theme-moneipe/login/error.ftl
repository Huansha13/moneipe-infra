<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Moneipe</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4 text-[#0f172a] antialiased">
  
  <div class="w-full max-w-[420px] bg-white border border-slate-200/80 rounded-2xl shadow-[0_4px_20px_rgba(15,23,42,0.06)] p-8 sm:p-10">
    
    <div class="flex flex-col items-center justify-center mb-8">
        <div class="flex items-center mb-4">
            <svg class="mr-2.5" xmlns="http://www.w3.org/2000/svg" height="36px" viewBox="0 -960 960 960" width="36px" fill="#0f172a">
              <path d="M240-160q-66 0-113-47T80-320v-320q0-66 47-113t113-47h480q66 0 113 47t47 113v320q0 66-47 113t-113 47H240Zm0-480h480q22 0 42 5t38 16v-21q0-33-23.5-56.5T720-720H240q-33 0-56.5 23.5T160-640v21q18-11 38-16t42-5Zm-74 130 445 108q9 2 18 0t17-8l139-116q-11-15-28-24.5t-37-9.5H240q-26 0-45.5 13.5T166-510Z"/>
            </svg>
            <span class="text-[28px] font-bold text-[#0f172a] tracking-tight">Moneipe</span>
        </div>
    </div>

    <div class="text-center space-y-3 mb-8">
        <h1 class="text-2xl font-bold text-[#0f172a] pb-2">Lo sentimos, hubo un problema</h1>
         ${kcSanitize(message.summary)?no_esc}
    </div>

    <div class="flex justify-center pt-2">
        <a href="#"
           class="w-full bg-[#0f172a] hover:bg-slate-800 text-white px-6 py-2.5 rounded-lg text-sm font-semibold transition-all duration-200 shadow-sm hover:shadow inline-block text-center cursor-pointer"
           onclick="regresar(); return false;">
            Volver al inicio de sesión
        </a>
    </div>

  </div>

  <script>
    function regresar() {
        // Leer origen guardado en sessionStorage desde login.ftl
        let destino = sessionStorage.getItem('moneipeLoginOrigen');
        
        if (!destino) {
            // Fallback: usar valor por defecto
            destino = 'https://moneipe.vercel.app/*';
        }
        
        window.location.href = destino;
    }
  </script>

</body>
</html>
