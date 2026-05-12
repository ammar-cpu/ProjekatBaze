package rs.raf.farmakologija.model;

import java.time.LocalDate;
import java.time.LocalTime;

public record Sesija(
        int sesijaId,
        LocalDate datum,
        LocalTime pocetak,
        LocalTime zavrsetak,
        String status,
        int izvodjenjeId,
        int labId
) {}
