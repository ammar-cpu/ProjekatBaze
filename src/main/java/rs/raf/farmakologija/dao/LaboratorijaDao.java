package rs.raf.farmakologija.dao;

import rs.raf.farmakologija.db.DatabaseConnection;
import rs.raf.farmakologija.model.Laboratorija;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LaboratorijaDao {

    // Neparametrizovan upit — koristi Statement (spec zahtev)
    public List<Laboratorija> findAll() throws SQLException {
        String sql = "SELECT lab_id, naziv, zgrada, sprat, br_prostorije FROM laboratorija ORDER BY naziv";
        try (Connection c = DatabaseConnection.get();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            List<Laboratorija> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new Laboratorija(
                        rs.getInt("lab_id"),
                        rs.getString("naziv"),
                        rs.getString("zgrada"),
                        rs.getInt("sprat"),
                        rs.getString("br_prostorije")
                ));
            }
            return result;
        }
    }

    // Poziva koleginicinu proceduru obrisi_laboratoriju koja interno proverava
    // da li u laboratoriji rade istrazivaci i izvrsava brisanje u transakciji.
    // Vraca poruku procedure ('Laboratorija uspesno obrisana' ili opis greske).
    public String delete(int labId) throws SQLException {
        String sql = "CALL obrisi_laboratoriju(?)";
        try (Connection c = DatabaseConnection.get();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, labId);
            ps.execute();
            try (ResultSet rs = ps.getResultSet()) {
                if (rs != null && rs.next()) return rs.getString("poruka");
            }
            return "OK";
        }
    }
}
