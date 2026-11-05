package karate.runner;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

class TestRunner {

    @Test
    void testUsuarios() {
        Results results = Runner.path("classpath:resources/features")
                .reportDir("karate-reports")
                .backupReportDir(false)
                .parallel(5);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
