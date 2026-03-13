package com.example.dat.utils;

import com.example.dat.res.Response;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin")
public class DatabaseCleanerController {

    private final DatabaseCleaner databaseCleaner;

    @DeleteMapping("/clear-database")
    public ResponseEntity<Response<String>> clearDatabase() {
        databaseCleaner.clearAllData();
        return ResponseEntity.ok(Response.<String>builder()
                .statusCode(200)
                .message("Database cleared successfully. All user data deleted. Roles preserved.")
                .build());
    }
}
