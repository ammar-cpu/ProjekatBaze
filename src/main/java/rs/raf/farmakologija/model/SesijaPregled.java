package rs.raf.farmakologija.model;

import java.time.LocalDate;
import java.time.LocalTime;

public record SesijaPregled(
        int sesijaId,
        LocalDate datum,
        LocalTime pocetak,
        LocalTime zavrsetak,
        String status,
        int izvodjenjeId,
        LocalDate izvodjenjeDatum,
        String eksperimentNaziv,
        String labNaziv
) {}
