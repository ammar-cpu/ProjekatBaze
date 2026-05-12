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

    public List<SesijaPregled> findAllForPregled() throws SQLException {
        String sql = """
                SELECT s.sesija_id, s.datum, s.pocetak, s.zavrsetak,
                       s.status_sesije AS status,
                       iz.izvodjenje_id, iz.datum AS izvodjenje_datum,
                       e.naziv AS eksperiment_naziv,
                       l.naziv AS lab_naziv
                FROM sesija s
                JOIN izvodjenje iz
                       ON s.izvodjenje_id = iz.izvodjenje_id
                      AND s.lab_id        = iz.lab_id
                JOIN eksperiment e
                       ON iz.eks_id = e.eks_id
                JOIN laboratorija l
                       ON s.lab_id = l.lab_id
                ORDER BY s.datum, s.pocetak
                """;
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
                        rs.getString("status"),
                        rs.getInt("izvodjenje_id"),
                        rs.getDate("izvodjenje_datum").toLocalDate(),
                        rs.getString("eksperiment_naziv"),
                        rs.getString("lab_naziv")
                ));
            }
            return result;
        }
    }

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

    public int update(int sesijaId, LocalDate datum, LocalTime pocetak,
                      LocalTime zavrsetak, String status) throws SQLException {
        String sql = "UPDATE sesija SET datum = ?, pocetak = ?, zavrsetak = ?, status_sesije = ? " +
                "WHERE sesija_id = ?";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(datum));
            ps.setTime(2, Time.valueOf(pocetak));
            ps.setTime(3, Time.valueOf(zavrsetak));
            ps.setString(4, status);
            ps.setInt(5, sesijaId);
            return ps.executeUpdate();
        }
    }
}
