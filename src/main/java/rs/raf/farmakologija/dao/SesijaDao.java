package rs.raf.farmakologija.dao;

import rs.raf.farmakologija.db.DatabaseConnection;
import rs.raf.farmakologija.model.Sesija;
import rs.raf.farmakologija.model.SesijaPregled;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class SesijaDao {

    // Neparametrizovan upit — koristi Statement (spec zahtev)
    public List<SesijaPregled> findAllForPregled() throws SQLException {
        String sql = "SELECT sesija_id, datum, pocetak, zavrsetak, status_sesije, " +
                "laboratorija, eksperiment, datum_izvodjenja, status_izvodjenja " +
                "FROM pregled_sesija ORDER BY datum, pocetak";
        try (Connection c = DatabaseConnection.get();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            List<SesijaPregled> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new SesijaPregled(
                        rs.getInt("sesija_id"),
                        rs.getDate("datum").toLocalDate(),
                        rs.getTime("pocetak").toLocalTime(),
                        rs.getTime("zavrsetak").toLocalTime(),
                        rs.getString("status_sesije"),
                        rs.getString("laboratorija"),
                        rs.getString("eksperiment"),
                        rs.getDate("datum_izvodjenja").toLocalDate(),
                        rs.getString("status_izvodjenja")
                ));
            }
            return result;
        }
    }

    // Parametrizovan upit — koristi PreparedStatement (spec zahtev)
    public Sesija findById(int sesijaId) throws SQLException {
        String sql = "SELECT sesija_id, datum, pocetak, zavrsetak, status_sesije AS status, " +
                "izvodjenje_id, lab_id FROM sesija WHERE sesija_id = ?";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sesijaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Sesija(
                            rs.getInt("sesija_id"),
                            rs.getDate("datum").toLocalDate(),
                            rs.getTime("pocetak").toLocalTime(),
                            rs.getTime("zavrsetak").toLocalTime(),
                            rs.getString("status"),
                            rs.getInt("izvodjenje_id"),
                            rs.getInt("lab_id")
                    );
                }
                return null;
            }
        }
    }

    // Poziva koleginicinu proceduru izmeni_sesiju koja proverava
    // preklapanje termina i izvrsava izmenu unutar transakcije.
    // Vraca poruku procedure ('Sesija uspesno izmenjena' ili opis greske).
    public String izmeni(int sesijaId, LocalDate datum,
                         LocalTime pocetak, LocalTime zavrsetak) throws SQLException {
        String sql = "CALL izmeni_sesiju(?, ?, ?, ?)";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sesijaId);
            ps.setDate(2, Date.valueOf(datum));
            ps.setTime(3, Time.valueOf(pocetak));
            ps.setTime(4, Time.valueOf(zavrsetak));
            ps.execute();
            try (ResultSet rs = ps.getResultSet()) {
                if (rs != null && rs.next()) return rs.getString("poruka");
            }
            return "OK";
        }
    }
}
