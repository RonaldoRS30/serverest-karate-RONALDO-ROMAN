package karate.runner;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate testUsuarios() {
        return Karate.run("classpath:resources/features")
                .reportDir("karate-reports")
                .backupReportDir(false);
    }
}
