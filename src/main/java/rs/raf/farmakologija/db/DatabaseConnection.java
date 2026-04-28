package rs.raf.farmakologija.db;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DatabaseConnection {

    private static final Properties props = load();

    private DatabaseConnection() {}

    public static Connection get() throws SQLException {
        return DriverManager.getConnection(
                props.getProperty("db.url"),
                props.getProperty("db.user"),
                props.getProperty("db.password"));
    }

    private static Properties load() {
        Properties p = new Properties();
        try (InputStream in = DatabaseConnection.class
                .getResourceAsStream("/db.properties")) {
            if (in == null) throw new IllegalStateException("db.properties nije pronađen na klasnoj putanji");
            p.load(in);
        } catch (IOException e) {
            throw new RuntimeException("Greška pri čitanju db.properties", e);
        }
        return p;
    }
}
