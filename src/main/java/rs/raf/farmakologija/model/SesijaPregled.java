package rs.raf.farmakologija.model;

import java.time.LocalDate;
import java.time.LocalTime;


public record SesijaPregled(
        int sesijaId,
        LocalDate datum,
        LocalTime pocetak,
        LocalTime zavrsetak,
        String statusSesije,
        String laboratorija,
        String eksperiment,
        LocalDate datumIzvodjenja,
        String statusIzvodjenja
) {}
