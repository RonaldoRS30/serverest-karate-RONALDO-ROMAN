function fn() {
    // Variables disponibles en TODOS los feature files (por ejemplo: baseUrl)
    var config = {
      baseUrl: 'https://serverest.dev'
    };
  
    // Tiempo máximo (en milisegundos) para conectar y para esperar respuesta
    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 10000);
  
    // Devolvemos la configuración para que Karate la use
    return config;
  }