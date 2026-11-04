package runners;

import com.intuit.karate.junit5.Karate;

class UsuariosTest {

    @Karate.Test
    Karate testUsuarios() {
        // Ejecuta todos los .feature de la carpeta "usuarios"
        return Karate.run("classpath:usuarios");
    }
}