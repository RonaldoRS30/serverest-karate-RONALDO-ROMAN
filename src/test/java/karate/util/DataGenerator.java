package karate.util;

import java.util.UUID;

public class DataGenerator {

    private static String idCorto() {
        return UUID.randomUUID().toString().substring(0, 8);
    }

    public static String randomName() {
        return "Usuario QA " + idCorto();
    }

    public static String randomEmail() {
        return "qa_" + idCorto() + "@test.com";
    }

    public static String randomPassword() {
        return "Pwd" + idCorto();
    }
}
