package rs.raf.farmakologija.auth;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserStore {

    private static final Path FILE = Path.of("users.txt");

    private final Map<String, String> users = new HashMap<>();

    public UserStore() {
        load();
    }

    public boolean exists(String username) {
        return users.containsKey(username);
    }

    public boolean authenticate(String username, String password) {
        String hash = users.get(username);
        return hash != null && hash.equals(PasswordHasher.hash(password));
    }

    public void register(String username, String password) throws IOException {
        if (users.containsKey(username)) {
            throw new IllegalArgumentException("Korisnik već postoji.");
        }
        String hash = PasswordHasher.hash(password);
        users.put(username, hash);
        Files.writeString(FILE, username + ":" + hash + System.lineSeparator(),
                StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.APPEND);
    }

    private void load() {
        if (!Files.exists(FILE)) return;
        try {
            List<String> lines = Files.readAllLines(FILE, StandardCharsets.UTF_8);
            for (String line : lines) {
                if (line.isBlank()) continue;
                int sep = line.indexOf(':');
                if (sep <= 0) continue;
                users.put(line.substring(0, sep), line.substring(sep + 1));
            }
        } catch (IOException e) {
            throw new RuntimeException("Greška pri učitavanju users.txt", e);
        }
    }
}
