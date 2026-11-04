package runners;

import com.intuit.karate.junit5.Karate;

class UsuariosTest {

    @Karate.Test
    Karate testUsuarios() {
        // Ejecuta todos los .feature de la carpeta "usuarios"
        // El reporte HTML queda en karate-reports/ para que forme parte del proyecto
        return Karate.run("classpath:usuarios")
                .reportDir("karate-reports")
                .backupReportDir(false);
    }
}