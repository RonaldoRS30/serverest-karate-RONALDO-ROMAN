package helpers;

import java.util.UUID;

public class DataGenerator {

    // Genera un texto aleatorio de 8 caracteres (ejemplo: "a3f9c2d1")
    private static String idCorto() {
        return UUID.randomUUID().toString().substring(0, 8);
    }

    // Devuelve un nombre único, ejemplo: "Usuario QA a3f9c2d1"
    public static String randomName() {
        return "Usuario QA " + idCorto();
    }

    // Devuelve un email único, ejemplo: "qa_a3f9c2d1@test.com"
    public static String randomEmail() {
        return "qa_" + idCorto() + "@test.com";
    }

    // Devuelve una contraseña aleatoria, ejemplo: "Pwda3f9c2d1"
    public static String randomPassword() {
        return "Pwd" + idCorto();
    }
}